var fs = require('fs');
var path = require('path');

var ROUTES = [
  { name: 'EscuelaDashboard',       title: 'Dashboard',       route: '/os/escuela/dashboard' },
  { name: 'EscuelaAlumnos',         title: 'Alumnos',         route: '/os/escuela/alumnos' },
  { name: 'EscuelaApoderados',      title: 'Apoderados',      route: '/os/escuela/apoderados' },
  { name: 'EscuelaMatriculas',      title: 'Matr\u00edculas', route: '/os/escuela/matriculas' },
  { name: 'EscuelaRequisitos',      title: 'Requisitos',      route: '/os/escuela/matriculas/requisitos' },
  { name: 'EscuelaConfiguracion',   title: 'Configuraci\u00f3n', route: '/os/escuela/configuracion/usuarios' },
  { name: 'EscuelaInstitucion',     title: 'Instituci\u00f3n', route: '/os/escuela/infraestructura/institucion' },
  { name: 'EscuelaAnioPeriodos',    title: 'A\u00f1o y Periodos', route: '/os/escuela/infraestructura/anio-periodos' },
  { name: 'EscuelaGradosSecciones', title: 'Grados y Aulas',  route: '/os/escuela/infraestructura/grados-secciones' },
  { name: 'EscuelaAreasCursos',     title: '\u00c1reas y Cursos', route: '/os/escuela/academica/areas-cursos' },
  { name: 'EscuelaMallaCurricular', title: 'Malla Curricular', route: '/os/escuela/academica/malla-curricular' },
  { name: 'EscuelaDocentes',        title: 'Docentes',        route: '/os/escuela/academica/docentes' },
  { name: 'EscuelaAsignacionDocente', title: 'Asignaci\u00f3n Docente', route: '/os/escuela/academica/asignacion-docente' },
  { name: 'EscuelaHorarios',        title: 'Horarios',        route: '/os/escuela/academica/horarios' },
  { name: 'EscuelaCalificaciones',  title: 'Calificaciones',  route: '/os/escuela/evaluaciones/calificaciones' },
  { name: 'EscuelaAsistencias',     title: 'Asistencias',     route: '/os/escuela/evaluaciones/asistencias' },
  { name: 'EscuelaEvaluaciones',    title: 'Evaluaciones',    route: '/os/escuela/evaluaciones/evaluaciones' },
  { name: 'EscuelaPromedios',       title: 'Promedios',       route: '/os/escuela/evaluaciones/promedios' },
  { name: 'EscuelaConceptosPago',   title: 'Conceptos de Pago', route: '/os/escuela/tesoreria/conceptos-pago' },
  { name: 'EscuelaMetodosPago',     title: 'M\u00e9todos de Pago', route: '/os/escuela/tesoreria/metodos-pago' },
  { name: 'EscuelaDeudas',          title: 'Deudas',          route: '/os/escuela/tesoreria/deudas-alumnos' },
  { name: 'EscuelaPagos',           title: 'Pagos',           route: '/os/escuela/tesoreria/pagos' },
  { name: 'EscuelaChatbot',         title: 'Asistente IA',    route: '/os/escuela/chatbot' }
];

var OUT_DIR = path.resolve(__dirname, '..', 'src', 'packages');

var PKG_TEMPLATE = {
  name: '__NAME__',
  version: '1.0.0',
  description: 'OS.js Iframe Application - Escuela Module',
  scripts: { build: 'webpack', watch: 'webpack --watch' },
  devDependencies: {
    '@babel/core': '^8.0.1',
    '@babel/preset-env': '^8.0.2',
    '@osjs/dev-meta': '^2.1.0',
    'babel-loader': '^10.1.1',
    'copy-webpack-plugin': '^14.0.0',
    'css-loader': '^7.1.4',
    'mini-css-extract-plugin': '^2.10.2',
    sass: '^1.101.0',
    'sass-loader': '^17.0.0',
    webpack: '^5.108.4',
    'webpack-cli': '^7.2.1'
  },
  osjs: { type: 'package' }
};

var WEBPACK_CONFIG = [
  "const path = require('path');",
  "const MiniCssExtractPlugin = require('mini-css-extract-plugin');",
  "const CopyWebpackPlugin = require('copy-webpack-plugin');",
  "",
  "const mode = process.env.NODE_ENV || 'development';",
  "const minimize = mode === 'production';",
  "",
  "module.exports = {",
  "  mode,",
  "  devtool: 'source-map',",
  "  entry: path.resolve(__dirname, 'index.js'),",
  "  externals: { osjs: 'OSjs' },",
  "  optimization: { minimize },",
  "  plugins: [",
  "    new CopyWebpackPlugin({ patterns: ['icon.png'] }),",
  "    new MiniCssExtractPlugin({ filename: '[name].css', chunkFilename: '[id].css' })",
  "  ],",
  "  module: {",
  "    rules: [",
  "      {",
  "        test: /\\.(sa|sc|c)ss$/,",
  "        exclude: /(node_modules|bower_components)/,",
  "        use: [",
  "          MiniCssExtractPlugin.loader,",
  "          { loader: 'css-loader', options: { sourceMap: true } },",
  "          { loader: 'sass-loader', options: { sourceMap: true } }",
  "        ]",
  "      },",
  "      {",
  "        test: /\\.js$/,",
  "        exclude: /(node_modules|bower_components)/,",
  "        use: { loader: 'babel-loader' }",
  "      }",
  "    ]",
  "  }",
  "};",
  ""
].join('\n');

var SCSS_CONTENT = [
  ".WindowContent {",
  "  padding: 0 !important;",
  "  overflow: hidden;",
  "}",
  "",
  "iframe {",
  "  width: 100%;",
  "  height: 100%;",
  "  border: none;",
  "}",
  ""
].join('\n');

var INDEX_TEMPLATE = [
  "import './index.scss';",
  "import osjs from 'osjs';",
  "import {name as applicationName} from './metadata.json';",
  "",
  "var ROUTE = '__ROUTE__';",
  "",
  "var register = function(core, args, options, metadata) {",
  "  var token = localStorage.getItem('escuela_token');",
  "  var proc = core.make('osjs/application', {args: args, options: options, metadata: metadata});",
  "  proc.createWindow({",
  "    id: metadata.name,",
  "    title: metadata.title.en_EN,",
  "    icon: proc.resource(proc.metadata.icon),",
  "    dimension: {width: 1200, height: 750},",
  "    position: {left: 50, top: 50}",
  "  })",
  "    .on('destroy', function() { proc.destroy(); })",
  "    .render(function($content) {",
  "      var iframe = document.createElement('iframe');",
  "      iframe.src = 'http://localhost:5173' + ROUTE + '?token=' + token;",
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

var ICON_BASE64 = 'iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAADDwAAAw8BrwUcegAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAOHSURBVFiF7dfNUxtlHAfw3+/ZDXnZXVISWjrBIoSCQewro+MFBZnBNk6Pjk7raKe2h7Zw8F7/Bmcs6jhTDzp2xhnvKLW0aC89iDhDEqMkfaEQm6QxKQTCsy/P40FKQ0rC7hY89XvN7vP97MvzPBsEm3mt/3S4qSk0BACQTsdHfrl+adTOOGj1hP7+k8ebAgeHG3a0vopEAAAAzgzIF+7czM5PjYxPfH15OwA40PfB8Z3Nh4bKiytjB7IZAAf63j+xs/nw+VrF1SG/fTY+8c1lAOBWAfjG6yff2/XcwXNWiu1AKgHY2/vOh7ube874/R2vECLaKq4MYzoUCndvZuamP7/281fflkMeAbC3993TuwOHz/gbO17equLKGIYKDzLxyUx6+ssbN767BAAc+wZOnfA3tH/kb+zsER2ubSmujK6XIJedmczlk5+QxWV2gWpcEcS6/6UcAEAQnMA4KoVF+rHo8uzxrfCmXdPxyVmPw1gKBntChDgsrw9mwpjG781OxdMPlyQNfZ067siIAICICG6ppYVxDpH41Kynjm0phDGNz6cisXS+KFNe3wX4+FGve9sQEdzy8/9B/vw9KTu50dp6qJMQh91iSP0di9/PLzkok7oBvE8cs+HrvnpH2nXOITYTScgurrfs2RcyC2FMg9T9WDz9T1FcYXIIQK56bM35hojgdAf2qpxD7K/phOyGmpAni5VNsaYmPCKC09O8V+UcojORGcXFjXLIWnF+WVgxPKaKLQHKIS53oEPlDCJ//HrLq3j0OpFAKpMVS+gLIUpWhrMOeAwh4FaCwSItQC77AARHo/V9fTXE5nlrEMSnm6lPBdiKPAM8AxDgfFt2PlNhHAWv5I4xbtTXORuCSARLd4QZFEp0GZBY+5bgTNXVYnKULiYvrF1994G33pTrXzgn1beFBdFtaoHS1AXILWSBiNU3m/Xgkq4vz45pNHUxEb06BrDBV3H3/vAR2Rs6K3mDYUFw1YSYBXBGdXVpblSjd79IRsd/LP+t6vM3A9kMUKt4U8CjvLjv6FFZaR+SfaHBSkg1AGdUp8XbV3Q6P5KMXfuh1vimZ0D3/vARSW4bVnxdg2QVUgngTNVp8dYVXb13MRmd2PCKbQPWQZS2YaWha9AwVDG3kAUkDo0Wb/9kqHOfJqLXx6yMZ3cNwJcOHHvbJQWGF0sL3KDZkUTs6vdQ4z9gtfwLI2G1KSAqw9QAAAAASUVORK5CYII=';

var ICON_BUFFER = Buffer.from(ICON_BASE64, 'base64');

ROUTES.forEach(function(r) {
  var pkgDir = path.join(OUT_DIR, r.name);
  if (!fs.existsSync(pkgDir)) {
    fs.mkdirSync(pkgDir, { recursive: true });
  }

  var pkg = JSON.parse(JSON.stringify(PKG_TEMPLATE));
  pkg.name = r.name;
  fs.writeFileSync(path.join(pkgDir, 'package.json'), JSON.stringify(pkg, null, 2) + '\n', 'utf-8');

  fs.writeFileSync(path.join(pkgDir, 'webpack.config.js'), WEBPACK_CONFIG, 'utf-8');
  fs.writeFileSync(path.join(pkgDir, 'index.scss'), SCSS_CONTENT, 'utf-8');
  fs.writeFileSync(path.join(pkgDir, 'icon.png'), ICON_BUFFER);

  var indexContent = INDEX_TEMPLATE.replace('__ROUTE__', r.route);
  fs.writeFileSync(path.join(pkgDir, 'index.js'), indexContent, 'utf-8');

  var meta = {
    type: 'application',
    name: r.name,
    category: 'network',
    icon: 'icon.png',
    singleton: true,
    title: { en_EN: r.title },
    description: { en_EN: r.title },
    files: ['main.js', 'main.css']
  };
  fs.writeFileSync(path.join(pkgDir, 'metadata.json'), JSON.stringify(meta, null, 2) + '\n', 'utf-8');

  console.log('Created package: ' + r.name);
});

console.log('\nDone. Generated ' + ROUTES.length + ' packages.');
