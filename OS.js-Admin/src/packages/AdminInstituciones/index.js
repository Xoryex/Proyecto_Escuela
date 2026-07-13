import osjs from 'osjs';
import {name as applicationName} from './metadata.json';

var register = function(core, args, options, metadata) {
  var token = localStorage.getItem('admin_token');
  var proc = core.make('osjs/application', {args, options, metadata});
  proc.createWindow({
    id: metadata.name,
    title: metadata.title.en_EN,
    icon: proc.resource(proc.metadata.icon),
    dimension: {width: 1200, height: 750},
    position: {left: 50, top: 50}
  })
    .on('destroy', () => proc.destroy())
    .render($content => {
      var iframe = document.createElement('iframe');
      iframe.src = 'http://localhost:5173/os/admin/instituciones?token=' + token;
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      iframe.style.border = 'none';
      $content.appendChild(iframe);
    });
  return proc;
};

osjs.register(applicationName, register);
