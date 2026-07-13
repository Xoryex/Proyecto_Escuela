import {
  Core,
  CoreServiceProvider,
  DesktopServiceProvider,
  VFSServiceProvider,
  NotificationServiceProvider,
  SettingsServiceProvider,
  AuthServiceProvider
} from '@osjs/client';

import {PanelServiceProvider} from '@osjs/panels';
import {GUIServiceProvider} from '@osjs/gui';
import {DialogServiceProvider} from '@osjs/dialogs';
import config from './config.js';
import './index.scss';

import {adminAuthAdapter} from './providers/AdminAuthProvider.js';

const init = () => {
  var params = new URLSearchParams(window.location.search);
  var tokenFromUrl = params.get('token');

  if (tokenFromUrl) {
    var userFromUrl = params.get('user');
    if (userFromUrl) {
      try {
        localStorage.setItem('admin_token', tokenFromUrl);
        localStorage.setItem('admin_user', decodeURIComponent(userFromUrl));
      } catch (e) {}
    }
    window.history.replaceState({}, '', window.location.pathname);
  }

  var token = localStorage.getItem('admin_token');
  if (!token) {
    window.location.href = 'http://localhost:5173/os/admin/login';
    return;
  }

  var clientConfig = Object.assign({}, config, {
    auth: {
      login: {
        username: '__token__',
        password: '__token__'
      }
    }
  });

  const osjs = new Core(clientConfig, {});

  osjs.register(CoreServiceProvider);
  osjs.register(DesktopServiceProvider);
  osjs.register(VFSServiceProvider);
  osjs.register(NotificationServiceProvider);
  osjs.register(SettingsServiceProvider, {before: true});
  osjs.register(AuthServiceProvider, {before: true, args: {adapter: adminAuthAdapter}});
  osjs.register(PanelServiceProvider);
  osjs.register(DialogServiceProvider);
  osjs.register(GUIServiceProvider);

  osjs.boot();
};

window.addEventListener('DOMContentLoaded', () => init());
