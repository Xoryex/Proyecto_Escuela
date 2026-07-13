/*!
 * OS.js - JavaScript Cloud/Web Desktop Platform
 *
 * Copyright (c) 2011-2020, Anders Evenrud <andersevenrud@gmail.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author  Anders Evenrud <andersevenrud@gmail.com>
 * @licence Simplified BSD License
 */

//
// This is the client bootstrapping script.
// This is where you can register service providers or set up
// your libraries etc.
//
// https://manual.os-js.org/guide/provider/
// https://manual.os-js.org/install/
// https://manual.os-js.org/resource/official/
//

import {
  Core,
  CoreServiceProvider,
  DesktopServiceProvider,
  VFSServiceProvider,
  NotificationServiceProvider,
  SettingsServiceProvider,
  AuthServiceProvider
} from '@osjs/client';

import { PanelServiceProvider } from '@osjs/panels';
import { GUIServiceProvider } from '@osjs/gui';
import { DialogServiceProvider } from '@osjs/dialogs';
import config from './config.js';
import './index.scss';

import { escuelaAuthAdapter } from './providers/EscuelaAuthProvider.js';

const init = () => {
  var params = new URLSearchParams(window.location.search);
  var tokenFromUrl = params.get('token');

  if (tokenFromUrl) {
    var userFromUrl = params.get('user');
    if (userFromUrl) {
      try {
        localStorage.setItem('escuela_token', tokenFromUrl);
        localStorage.setItem('escuela_user', decodeURIComponent(userFromUrl));
      } catch (e) { }
    }
    window.history.replaceState({}, '', window.location.pathname);
  }

  var token = localStorage.getItem('escuela_token');
  if (!token) {
    window.location.href = 'http://localhost:5173/os/escuela/login';
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
  osjs.register(SettingsServiceProvider, { before: true });
  osjs.register(AuthServiceProvider, { before: true, args: { adapter: escuelaAuthAdapter } });
  osjs.register(PanelServiceProvider);
  osjs.register(DialogServiceProvider);
  osjs.register(GUIServiceProvider);

  osjs.boot();
};

window.addEventListener('DOMContentLoaded', () => init());
