# Respaldo de Rutas `/os/*` (Integración OS.js en desuso)

Esta carpeta conserva una copia exacta de los archivos del frontend antes de retirar las rutas heredadas de OS.js (`/os/admin/*`, `/os/escuela/*`, `/os/admin/login`, `/os/escuela/login` y las redirecciones a `http://localhost:8000` / `http://localhost:8001`):

- `App_con_rutas_os.tsx` (copia original de `escuelita-frontend/src/App.tsx`)
- `Login_con_os.tsx` (copia original de `escuelita-frontend/src/pages/Login.tsx`)
- `LoginEscuela_con_os.tsx` (copia original de `escuelita-frontend/src/pages/LoginEscuela.tsx`)

## Cómo restaurar en caso de necesitarlo
Copiar los bloques `/os/*` de `App_con_rutas_os.tsx` en `escuelita-frontend/src/App.tsx` y las redirecciones condicionales de `Login_con_os.tsx` / `LoginEscuela_con_os.tsx` (recomendando evitar enviar JWT por query string en producción).
