import './index.scss';
import osjs from 'osjs';
import {name as applicationName} from './metadata.json';

var ROUTE = '/os/escuela/apoderados';

var register = function(core, args, options, metadata) {
  var token = localStorage.getItem('escuela_token');
  var proc = core.make('osjs/application', {args: args, options: options, metadata: metadata});
  proc.createWindow({
    id: metadata.name,
    title: metadata.title.en_EN,
    icon: proc.resource(proc.metadata.icon),
    dimension: {width: 1200, height: 750},
    position: {left: 50, top: 50}
  })
    .on('destroy', function() { proc.destroy(); })
    .render(function($content) {
      var iframe = document.createElement('iframe');
      iframe.src = 'http://localhost:5173' + ROUTE + '?token=' + token;
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      iframe.style.border = 'none';
      $content.appendChild(iframe);
    });
  return proc;
};

osjs.register(applicationName, register);
