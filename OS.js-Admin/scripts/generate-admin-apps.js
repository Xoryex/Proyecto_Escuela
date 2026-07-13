var fs = require('fs');
var path = require('path');

var ROUTES = [
  { name: 'AdminDashboard',       title: 'Dashboard',       route: '/os/admin/dashboard' },
  { name: 'AdminInstituciones',   title: 'Instituciones',   route: '/os/admin/instituciones' },
  { name: 'AdminRoles',           title: 'Roles',           route: '/os/admin/roles' },
  { name: 'AdminSedes',           title: 'Sedes',           route: '/os/admin/sedes' },
  { name: 'AdminSuscripciones',   title: 'Suscripciones',   route: '/os/admin/suscripciones' },
  { name: 'AdminUsuarios',        title: 'Usuarios',        route: '/os/admin/usuarios' },
  { name: 'AdminReportes',        title: 'Reportes',        route: '/os/admin/reportes' }
];

var OUT_DIR = path.resolve(__dirname, '..', 'src', 'packages');

ROUTES.forEach(function(r) {
  var pkgDir = path.join(OUT_DIR, r.name);
  if (!fs.existsSync(pkgDir)) {
    fs.mkdirSync(pkgDir, { recursive: true });
  }

  var pkg = {
    name: r.name,
    scripts: { build: 'webpack' },
    osjs: { type: 'package' }
  };
  fs.writeFileSync(path.join(pkgDir, 'package.json'), JSON.stringify(pkg, null, 2) + '\n', 'utf-8');

  var webpackConfig = [
    "const path = require('path');",
    "const mode = process.env.NODE_ENV || 'development';",
    "const minimize = mode === 'production';",
    "const CopyWebpackPlugin = require('copy-webpack-plugin');",
    "module.exports = {",
    "  mode, devtool: 'source-map',",
    "  entry: [path.resolve(__dirname, 'index.js')],",
    "  optimization: { minimize },",
    "  externals: { osjs: 'OSjs' },",
    "  plugins: [new CopyWebpackPlugin({ patterns: [{from: 'data', to: 'data'}, 'icon.png'] })],",
    "  module: { rules: [{ test: /\\.js$/, exclude: /(node_modules|bower_components)/, use: { loader: 'babel-loader' } }] }",
    "};",
    ""
  ].join('\n');
  fs.writeFileSync(path.join(pkgDir, 'webpack.config.js'), webpackConfig, 'utf-8');

  var indexContent = [
    "import osjs from 'osjs';",
    "import {name as applicationName} from './metadata.json';",
    "",
    "var register = function(core, args, options, metadata) {",
    "  var token = localStorage.getItem('admin_token');",
    "  var proc = core.make('osjs/application', {args, options, metadata});",
    "  proc.createWindow({",
    "    id: metadata.name,",
    "    title: metadata.title.en_EN,",
    "    icon: proc.resource(proc.metadata.icon),",
    "    dimension: {width: 1200, height: 750},",
    "    position: {left: 50, top: 50}",
    "  })",
    "    .on('destroy', () => proc.destroy())",
    "    .render($content => {",
    "      var iframe = document.createElement('iframe');",
    "      iframe.src = 'http://localhost:5173" + r.route + "?token=' + token;",
    "      iframe.style.width = '100%';",
    "      iframe.style.height = '100%';",
    "      iframe.style.border = 'none';",
    "      $content.appendChild(iframe);",
    "    });",
    "  return proc;",
    "};",
    "",
    "osjs.register(applicationName, register);",
    ""
  ].join('\n');
  fs.writeFileSync(path.join(pkgDir, 'index.js'), indexContent, 'utf-8');

  var iconSrc = path.resolve(__dirname, '..', 'node_modules', '@osjs', 'calculator-application', 'icon.png');
  if (fs.existsSync(iconSrc)) {
    fs.writeFileSync(path.join(pkgDir, 'icon.png'), fs.readFileSync(iconSrc));
  }

  var meta = {
    type: 'application',
    name: r.name,
    icon: 'icon.png',
    category: null,
    server: null,
    title: { en_EN: r.title },
    description: { en_EN: r.title },
    files: ['main.js']
  };
  fs.writeFileSync(path.join(pkgDir, 'metadata.json'), JSON.stringify(meta, null, 2) + '\n', 'utf-8');

  var dataDir = path.join(pkgDir, 'data');
  if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir);
  }
  fs.writeFileSync(path.join(dataDir, 'index.html'), '<!DOCTYPE html><html><body><h1>' + r.title + '</h1></body></html>', 'utf-8');

  console.log('Generated: ' + r.name);
});

console.log('\nDone.');
