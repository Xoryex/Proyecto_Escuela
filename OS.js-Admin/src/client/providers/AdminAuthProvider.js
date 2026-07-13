const API_BASE = 'http://localhost:8080';

function adminAuthAdapter(core) {
  var cachedUser = null;

  return {
    init() {
      var params = new URLSearchParams(window.location.search);
      var tokenFromUrl = params.get('token');
      var userFromUrl = params.get('user');

      if (tokenFromUrl && userFromUrl) {
        try {
          var user = JSON.parse(decodeURIComponent(userFromUrl));
          localStorage.setItem('admin_token', tokenFromUrl);
          localStorage.setItem('admin_user', JSON.stringify(user));
          cachedUser = user;
        } catch (e) {}
      } else {
        var token = localStorage.getItem('admin_token');
        var userStr = localStorage.getItem('admin_user');
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
        return Promise.resolve(cachedUser);
      }

      return fetch(API_BASE + '/auth/admin/login', {
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
        localStorage.setItem('admin_token', data.token);
        localStorage.setItem('admin_user', JSON.stringify(data.usuario));
        return data.usuario;
      });
    },

    logout() {
      localStorage.removeItem('admin_token');
      localStorage.removeItem('admin_user');
      window.location.href = 'http://localhost:5173/os/admin/login';
      return Promise.resolve(true);
    },

    register() {
      return Promise.resolve(true);
    }
  };
}

export {adminAuthAdapter};
