var fs = require('fs');
var path = require('path');
var { execSync } = require('child_process');

var PKG_DIR = path.resolve(__dirname, '..', 'src', 'packages');

var APP_NAMES = [
  'EscuelaDashboard', 'EscuelaAlumnos', 'EscuelaApoderados', 'EscuelaMatriculas',
  'EscuelaRequisitos', 'EscuelaConfiguracion', 'EscuelaInstitucion', 'EscuelaAnioPeriodos',
  'EscuelaGradosSecciones', 'EscuelaAreasCursos', 'EscuelaMallaCurricular', 'EscuelaDocentes',
  'EscuelaAsignacionDocente', 'EscuelaHorarios', 'EscuelaCalificaciones', 'EscuelaAsistencias',
  'EscuelaEvaluaciones', 'EscuelaPromedios', 'EscuelaConceptosPago', 'EscuelaMetodosPago',
  'EscuelaDeudas', 'EscuelaPagos', 'EscuelaChatbot'
];

var NM_SOURCE = path.resolve(__dirname, '..', 'src', 'packages', 'EscuelaDashboard', 'node_modules');

if (!fs.existsSync(NM_SOURCE)) {
  console.log('Installing dependencies in EscuelaDashboard first...');
  execSync('npm install', {
    cwd: path.resolve(__dirname, '..', 'src', 'packages', 'EscuelaDashboard'),
    stdio: 'inherit'
  });
}

var env = Object.assign({}, process.env);
env.NODE_OPTIONS = '--openssl-legacy-provider';
if (fs.existsSync(NM_SOURCE)) {
  env.NODE_PATH = NM_SOURCE + (process.env.NODE_PATH ? ';' + process.env.NODE_PATH : '');
}

APP_NAMES.forEach(function(name) {
  var pkgDir = path.join(PKG_DIR, name);
  if (!fs.existsSync(pkgDir)) {
    console.log('Skipping ' + name + ' (directory not found)');
    return;
  }

  console.log('Building ' + name + '...');
  try {
    execSync('npx webpack --config webpack.config.js', {
      cwd: pkgDir,
      stdio: 'pipe',
      env: env
    });
    console.log('  OK');
  } catch (e) {
    console.log('  FAILED');
    var stderr = e.stderr ? e.stderr.toString() : '';
    if (stderr) {
      var lines = stderr.split('\n').filter(function(l) { return l.trim(); }).slice(-3);
      lines.forEach(function(l) { console.log('  ' + l.trim()); });
    }
  }
});

console.log('\nDone building all escuela apps.');
