# Lógica Archivada del Chatbot IA (Ollama / Qwen 2.5)

Este directorio resguarda toda la lógica del módulo **Asistente IA / Chatbot** que fue descartado de la versión activa del sistema **SIAE / ESCUELITA**, para poder reactivarlo fácilmente en el futuro si se requiere.

## Contenido archivado

### Backend (`chatbot_archivado/backend/`)
- `controller/ChatbotController.java` → restaurar en `escuelita-backend/src/main/java/com/escuelita/www/controller/ChatbotController.java`
- `service/jpa/ChatbotService.java` → restaurar en `escuelita-backend/src/main/java/com/escuelita/www/service/jpa/ChatbotService.java`
- `util/OllamaClient.java` → restaurar en `escuelita-backend/src/main/java/com/escuelita/www/util/OllamaClient.java`

### Frontend (`chatbot_archivado/frontend/chatbot/`)
- Restaurar la carpeta completa `chatbot/` en `escuelita-frontend/src/features/portal/chatbot/`

---

## Snippets de configuración para restaurar en el futuro

### 1. Backend — `escuelita-backend/src/main/java/com/escuelita/www/security/SecurityConfig.java`
Agregar `"/api/chatbot/**"` al `requestMatchers(...)` (o protegerlo con autenticación JWT).

### 2. Backend — `escuelita-backend/src/main/resources/application.properties`
```properties
# Configuracion de Ollama (IA)
ollama.api.url=${OLLAMA_API_URL}
ollama.model=${OLLAMA_MODEL}

# Configuracion Datasource de Solo Lectura para IA
spring.datasource.readonly.url=${DB_URL}
spring.datasource.readonly.username=${DB_READONLY_USERNAME:escuela_ia_ro}
spring.datasource.readonly.password=${DB_READONLY_PASSWORD:PassIaSecure123!}
```

### 3. Backend — `.env` / `.env.example`
```env
# Usuario de base de datos de solo lectura para la IA Chatbot
DB_READONLY_USERNAME=escuela_ia_ro
DB_READONLY_PASSWORD=PassIaSecure123!

# Configuración de Ollama (IA)
OLLAMA_API_URL=http://localhost:11434
OLLAMA_MODEL=qwen2.5:7b
```

### 4. Backend — `escuelita-backend/src/main/resources/data.sql`
```sql
-- En INSERT INTO modulos:
(9, 'ASISTENTE IA', 'Asistente de inteligencia artificial para consultas', 'Bot', 8, '/chatbot', 1);

-- En INSERT INTO rol_modulo:
(58, 1, 9, 1);
```

### 5. Frontend — `escuelita-frontend/src/config/api.config.ts`
```ts
// ===== CHATBOT / IA =====
CHATBOT: '/api/chatbot/preguntar',
```

### 6. Frontend — `escuelita-frontend/src/App.tsx`
```tsx
import ChatbotRoutes from './features/portal/chatbot/routes/ChatbotRoutes';
// Dentro de /escuela y /os/escuela:
<Route path="chatbot/*" element={<ChatbotRoutes />} />
```

### 7. Frontend — `escuelita-frontend/src/components/layout/Sidebar.tsx`
Importar `Bot` de `lucide-react` y agregar en `menuModulesConfig`:
```tsx
'ASISTENTE IA': {
    icon: Bot,
    subItems: {
        'Consultar IA': { path: '/escuela/chatbot', icon: Bot },
    }
},
```
