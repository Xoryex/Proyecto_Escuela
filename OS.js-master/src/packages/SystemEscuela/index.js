import './index.scss';
import osjs from 'osjs';
import {name as applicationName} from './metadata.json';

const register = (core, args, options, metadata) => {
  const proc = core.make('osjs/application', {args, options, metadata});

  proc.createWindow({
    id: 'SystemEscuelaWindow',
    title: metadata.title.en_EN,
    icon: proc.resource(proc.metadata.icon),
    dimension: {width: 1200, height: 750},
    position: {left: 150, top: 50}
  })
    .on('destroy', () => proc.destroy())
    .render(($content) => {
      const iframe = document.createElement('iframe');
      iframe.src = 'http://localhost:5173/escuela/login';
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      iframe.style.border = 'none';
      iframe.setAttribute('allowfullscreen', 'true');
      $content.appendChild(iframe);
    });

  return proc;
};

osjs.register(applicationName, register);
