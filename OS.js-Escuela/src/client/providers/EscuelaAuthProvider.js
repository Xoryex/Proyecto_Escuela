const API_BASE = 'http://localhost:8080';

function escuelaAuthAdapter(core) {
  var cachedUser = null;

  return {
    init() {
      var params = new URLSearchParams(window.location.search);
      var tokenFromUrl = params.get('token');
      var userFromUrl = params.get('user');

      if (tokenFromUrl && userFromUrl) {
        try {
          var user = JSON.parse(decodeURIComponent(userFromUrl));
          localStorage.setItem('escuela_token', tokenFromUrl);
          localStorage.setItem('escuela_user', JSON.stringify(user));
          cachedUser = user;
        } catch (e) {}
      } else {
        var token = localStorage.getItem('escuela_token');
        var userStr = localStorage.getItem('escuela_user');
        if (token && userStr) {
          try {
            cachedUser = JSON.parse(userStr);
          } catch (e) {}
        }
      }

      return Promise.resolve(true);
    },

    login(values) {
      if (cachedUser) {
        return fetch('/login', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({username: cachedUser.username || cachedUser.usuario, password: 'osjs-auto'})
        }).then(function() {
          return cachedUser;
        }).catch(function() {
          return cachedUser;
        });
      }

      return fetch(API_BASE + '/auth/escuela/login', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
          usuario: values.username,
          contrasena: values.password
        })
      }).then(function(r) {
        if (!r.ok) return r.text().then(function(t) { throw new Error(t || 'Credenciales inválidas') });
        return r.json();
      }).then(function(data) {
        localStorage.setItem('escuela_token', data.token);
        localStorage.setItem('escuela_user', JSON.stringify(data.usuario));
        return data.usuario;
      });
    },

    logout() {
      localStorage.removeItem('escuela_token');
      localStorage.removeItem('escuela_user');
      window.location.href = 'http://localhost:5173/os/escuela/login';
      return Promise.resolve(true);
    },

    register() {
      return Promise.resolve(true);
    }
  };
}

export {escuelaAuthAdapter};
