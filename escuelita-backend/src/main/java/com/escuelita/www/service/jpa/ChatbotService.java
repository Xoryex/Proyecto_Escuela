package com.escuelita.www.service.jpa;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.escuelita.www.util.OllamaClient;
import com.escuelita.www.util.TenantContext;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.annotation.PostConstruct;
import javax.sql.DataSource;
import java.sql.Statement;

@Service
public class ChatbotService {

    @Value("${spring.datasource.readonly.url}")
    private String dbUrl;

    @Value("${spring.datasource.readonly.username}")
    private String dbUsername;

    @Value("${spring.datasource.readonly.password}")
    private String dbPassword;

    @Autowired
    private OllamaClient ollamaClient;

    private final ObjectMapper objectMapper = new ObjectMapper().findAndRegisterModules();

    @Autowired
    private DataSource primaryDataSource;

    private String dbSchemaCached = "";

    /**
     * Inicializa y almacena en caché el esquema de la base de datos al levantar el proyecto.
     */
    @PostConstruct
    public void initSchema() {
        // 1. Crear y configurar el usuario de solo lectura para la IA
        crearUsuarioSoloLectura();

        // 2. Precargar esquema de base de datos
        try {
            this.dbSchemaCached = getDatabaseSchemaDescription();
            System.out.println("🤖 [Chatbot] Esquema de la base de datos cargado en caché al levantar el proyecto.");
        } catch (Exception e) {
            System.err.println("⚠️ [Chatbot] No se pudo precargar el esquema de la base de datos: " + e.getMessage());
        }
    }

    /**
     * Crea y otorga permisos de SELECT al usuario de solo lectura de forma dinámica.
     */
    private void crearUsuarioSoloLectura() {
        try (Connection conn = primaryDataSource.getConnection()) {
            String dbName = conn.getCatalog();
            System.out.println("🔧 [Chatbot] Configurando usuario para la base de datos: " + dbName);

            try (Statement stmt = conn.createStatement()) {
                // Crear usuario para localhost y otorgar permisos de SELECT globales
                stmt.execute("CREATE USER IF NOT EXISTS 'escuela_ia_ro'@'localhost' IDENTIFIED BY 'PassIaSecure123!'");
                stmt.execute("GRANT SELECT ON `" + dbName + "`.* TO 'escuela_ia_ro'@'localhost'");
                
                // Crear usuario para 127.0.0.1 y otorgar permisos de SELECT globales
                stmt.execute("CREATE USER IF NOT EXISTS 'escuela_ia_ro'@'127.0.0.1' IDENTIFIED BY 'PassIaSecure123!'");
                stmt.execute("GRANT SELECT ON `" + dbName + "`.* TO 'escuela_ia_ro'@'127.0.0.1'");

                // Otorgar privilegios de modificación de datos (INSERT, UPDATE, DELETE) en tablas permitidas
                String[] tablasPermitidas = {
                    "matriculas", "evaluaciones", "calificaciones", "asistencias",
                    "alumnos", "apoderados", "alumno_apoderado", "deudas_alumno", "documentos_alumno"
                };
                for (String tabla : tablasPermitidas) {
                    stmt.execute("GRANT INSERT, UPDATE, DELETE ON `" + dbName + "`.`" + tabla + "` TO 'escuela_ia_ro'@'localhost'");
                    stmt.execute("GRANT INSERT, UPDATE, DELETE ON `" + dbName + "`.`" + tabla + "` TO 'escuela_ia_ro'@'127.0.0.1'");
                }
                
                // Aplicar privilegios
                stmt.execute("FLUSH PRIVILEGES");
                System.out.println("✅ [Chatbot] Usuario 'escuela_ia_ro' configurado exitosamente con privilegios para matrículas y notas.");
            }
        } catch (Exception e) {
            System.err.println("⚠️ [Chatbot] No se pudo configurar el usuario de solo lectura automáticamente: " + e.getMessage());
        }
    }

    /**
     * Obtiene una conexión JDBC utilizando el usuario de solo lectura.
     */
    private Connection getReadOnlyConnection() throws SQLException {
        String url = dbUrl;
        if (url != null && url.contains("localhost")) {
            url = url.replace("localhost", "127.0.0.1");
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // Ignorar si el driver ya está cargado
        }
        return DriverManager.getConnection(url, dbUsername, dbPassword);
    }

    /**
     * Extrae el esquema de la base de datos (tablas y columnas) para el contexto
     * del prompt.
     */
    public String getDatabaseSchemaDescription() throws Exception {
        StringBuilder schemaDesc = new StringBuilder();

        try (Connection conn = getReadOnlyConnection()) {
            String dbName = conn.getCatalog();

            // 1. Obtener relaciones de clave foránea
            Map<String, List<String>> foreignKeys = new HashMap<>();
            String fkQuery = "SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME " +
                             "FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE " +
                             "WHERE TABLE_SCHEMA = ? AND REFERENCED_TABLE_NAME IS NOT NULL";
            try (PreparedStatement stmt = conn.prepareStatement(fkQuery)) {
                stmt.setString(1, dbName);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        String tableName = rs.getString("TABLE_NAME");
                        String columnName = rs.getString("COLUMN_NAME");
                        String refTable = rs.getString("REFERENCED_TABLE_NAME");
                        String refColumn = rs.getString("REFERENCED_COLUMN_NAME");

                        foreignKeys.computeIfAbsent(tableName, k -> new ArrayList<>())
                                   .add(columnName + " -> " + refTable + "(" + refColumn + ")");
                    }
                }
            }

            // 2. Obtener columnas y tipos de datos (incluyendo tipos completos como enum)
            String colQuery = "SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, COLUMN_TYPE " +
                    "FROM INFORMATION_SCHEMA.COLUMNS " +
                    "WHERE TABLE_SCHEMA = ? " +
                    "ORDER BY TABLE_NAME, ORDINAL_POSITION";

            try (PreparedStatement stmt = conn.prepareStatement(colQuery)) {
                stmt.setString(1, dbName);

                try (ResultSet rs = stmt.executeQuery()) {
                    String currentTable = "";
                    while (rs.next()) {
                        String tableName = rs.getString("TABLE_NAME");
                        String columnName = rs.getString("COLUMN_NAME");
                        String dataType = rs.getString("DATA_TYPE");
                        String columnType = rs.getString("COLUMN_TYPE");

                        if (!tableName.equals(currentTable)) {
                            if (!currentTable.isEmpty()) {
                                appendForeignKeys(schemaDesc, currentTable, foreignKeys);
                            }
                            currentTable = tableName;
                            schemaDesc.append("\nTabla: ").append(tableName).append("\nColumnas: ");
                        } else {
                            schemaDesc.append(", ");
                        }

                        // Si es tipo enum, usamos COLUMN_TYPE para que contenga los valores permitidos (ej. enum('ACTIVO','INACTIVO'))
                        String finalType = dataType.equalsIgnoreCase("enum") ? columnType : dataType;
                        schemaDesc.append(columnName).append(" (").append(finalType).append(")");
                    }
                    if (!currentTable.isEmpty()) {
                        appendForeignKeys(schemaDesc, currentTable, foreignKeys);
                    }
                }
            }
        }

        return schemaDesc.toString();
    }

    private void appendForeignKeys(StringBuilder schemaDesc, String tableName, Map<String, List<String>> foreignKeys) {
        List<String> fks = foreignKeys.get(tableName);
        if (fks != null && !fks.isEmpty()) {
            schemaDesc.append("\nRelaciones: ").append(String.join(", ", fks));
        }
        schemaDesc.append("\n");
    }

    /**
     * Procesa la pregunta del usuario en lenguaje natural:
     * 1. Extrae el esquema.
     * 2. Envía a Ollama para generar la consulta SQL SELECT.
     * 3. Valida que la consulta sea segura y de tipo SELECT.
     * 4. Ejecuta la consulta en la BD con permisos de solo lectura.
     * 5. Envía los resultados a Ollama para formatear la respuesta final.
     */
    public String procesarPregunta(String pregunta) throws Exception {
        // 1. Obtener el esquema de la base de datos (usar caché si existe, de lo contrario cargar en caliente)
        String esquema = this.dbSchemaCached;
        if (esquema == null || esquema.trim().isEmpty()) {
            esquema = getDatabaseSchemaDescription();
            this.dbSchemaCached = esquema;
        }

        // Obtener contexto del usuario actual
        Long sedeId = TenantContext.getSedeId();
        Long userId = TenantContext.getUserId();
        String userType = TenantContext.getUserType();
        boolean isSuperAdmin = TenantContext.isSuperAdmin();

        String nombreUsuario = obtenerNombreCompletoUsuario(userId, isSuperAdmin);
        String primerNombre = "";
        if (nombreUsuario != null && !nombreUsuario.trim().isEmpty()) {
            String[] partsName = nombreUsuario.trim().split("\\s+");
            if (partsName.length >= 2) {
                primerNombre = partsName[0] + " " + partsName[1];
            } else if (partsName.length == 1) {
                primerNombre = partsName[0];
            }
        }

        StringBuilder contextDesc = new StringBuilder();
        contextDesc.append("Contexto de sesión del usuario que consulta:\n");
        if (nombreUsuario != null && !nombreUsuario.trim().isEmpty()) {
            contextDesc.append("- Nombre completo del usuario actual: ").append(nombreUsuario).append("\n");
            contextDesc.append("- Primeros nombres del usuario actual: ").append(primerNombre).append("\n");
        }
        if (isSuperAdmin) {
            contextDesc.append("- Rol del usuario: SUPER_ADMIN (tiene acceso a todas las sedes, no filtres por sede por defecto a menos que se especifique una en la pregunta).\n");
        } else {
            contextDesc.append("- Rol del usuario: ").append(userType != null ? userType : "ESCUELA").append("\n");
            if (sedeId != null) {
                contextDesc.append("- ID de la Sede asignada (id_sede): ").append(sedeId).append(" (Si la pregunta dice 'mi sede', 'mi escuela', 'esta sede', etc., debes usar exactamente el valor literal ").append(sedeId).append(" en tu consulta SQL).\n");
            }
        }
        if (userId != null) {
            contextDesc.append("- ID del Usuario actual (id_usuario): ").append(userId).append(" (Si la pregunta dice 'mi usuario', 'mis datos', etc., debes usar exactamente el valor literal ").append(userId).append(").\n");
        }

        // Detectar si es un saludo básico en Java para omitir procesamiento SQL y acelerar la respuesta
        String prepPregunta = pregunta.trim().toLowerCase().replaceAll("[¡!¿?.,]", "");
        boolean esSoloSaludo = prepPregunta.equals("hola") 
                || prepPregunta.equals("hola como estas")
                || prepPregunta.equals("hola cómo estás")
                || prepPregunta.equals("buenos dias")
                || prepPregunta.equals("buenos días")
                || prepPregunta.equals("buenas tardes")
                || prepPregunta.equals("buenas noches")
                || prepPregunta.equals("saludos")
                || prepPregunta.equals("hey")
                || prepPregunta.equals("buen dia")
                || prepPregunta.equals("buen día");

        String sqlGenerada = "";
        List<Map<String, Object>> resultados = new ArrayList<>();

        if (!esSoloSaludo) {
            String sqlSystemPrompt = "Eres un asistente experto en bases de datos MySQL. Tu única tarea es generar una consulta SQL válida (SELECT, INSERT, UPDATE o DELETE) basada en la estructura de la base de datos y el contexto del usuario provistos.\n"
                    + "Reglas obligatorias:\n"
                    + "1. Tienes permitido realizar consultas de lectura (SELECT) en todas las tablas.\n"
                    + "2. Tienes permitido realizar consultas de modificación de datos (INSERT, UPDATE, DELETE) ÚNICAMENTE sobre las tablas: `alumnos`, `apoderados`, `alumno_apoderado`, `documentos_alumno`, `deudas_alumno`, `matriculas`, `evaluaciones`, `calificaciones`, `asistencias`.\n"
                    + "3. Para cualquier otra tabla, solo tienes permiso de lectura. NO generes INSERT, UPDATE o DELETE sobre ellas.\n"
                    + "4. NO está permitido modificar la estructura de la base de datos (DROP, ALTER, CREATE, TRUNCATE, etc.).\n"
                    + "5. Devuelve ÚNICAMENTE el código SQL limpio. PROHIBIDO usar bloques markdown (```sql```), comentarios (--), explicaciones o texto adicional. Solo el SQL listo para ejecutarse.\n"
                    + "6. IMPORTANTE - REGLAS PARA INSERTS:\n"
                    + "   a) NUNCA incluyas columnas de clave primaria AUTO_INCREMENT (ej: id_alumno, id_apoderado, id_matricula, id_evaluacion, etc.) — la base de datos las genera sola.\n"
                    + "   b) SIEMPRE incluye `id_sede` en inserts de tablas que la tengan, usando el valor literal del contexto de sesión (no pongas marcadores).\n"
                    + "   c) SIEMPRE incluye `estado` con valor 1 (activo) si no fue especificado explícitamente por el usuario.\n"
                    + "   d) OMITE columnas opcionales que el usuario NO mencionó (ej: foto_url, observaciones, foto, descripcion, token_reset, etc.). No las incluyas ni con NULL.\n"
                    + "   e) PARSEO DE DATOS DEL USUARIO: El usuario puede enviar datos en el formato '[valor] - [nombre_campo]'. El valor está ANTES del guión y el campo está DESPUÉS. Ejemplo: '76801720 - numero_documento' significa que la columna `numero_documento` recibe el valor `76801720`. Nunca confundas valor con campo.\n"
                    + "   f) VERIFICACIÓN CRÍTICA ANTES DE RESPONDER: Cuenta las columnas en INSERT INTO tabla(col1,col2,...) y cuenta los valores en VALUES(val1,val2,...). DEBEN ser exactamente el mismo número. Si no coinciden, corrige antes de responder.\n"
                    + "7. IMPORTANTE: Para JOINs usa solo columnas especificadas en 'Relaciones'. No asumas columnas que no estén listadas.\n"
                    + "8. IMPORTANTE: NUNCA uses marcadores de posición como '<valor>' o '[campo]'. Usa siempre los valores reales del contexto de sesión.";

            String userPromptSqlGen = "Estructura de la base de datos:\n" + esquema + "\n\n" +
                    contextDesc.toString() + "\n" +
                    "Instrucción del usuario: " + pregunta + "\n\n" +
                    "Genera la consulta SQL que responda a esta instrucción.";

            // Intentar parsear INSERT directo desde el formato "valor - campo" del usuario
            String sqlDirecto = construirInsertDesdeFormato(pregunta, sedeId);
            if (sqlDirecto != null) {
                sqlGenerada = sqlDirecto;
                System.out.println("🔧 SQL construida directamente (parser Java): " + sqlGenerada);
            } else {
                // Generar la consulta SQL via Ollama
                sqlGenerada = ollamaClient.generate(sqlSystemPrompt, userPromptSqlGen);

                // Limpiar: extraer SOLO el SQL, ignorando texto introductorio y bloques markdown
                sqlGenerada = limpiarYExtraerSql(sqlGenerada);

                System.out.println("🤖 SQL Generada por Ollama: " + sqlGenerada);
            }

            if (sqlGenerada.toUpperCase().startsWith("INFO_REQUISITOS:")) {
                // Consulta informativa de requisitos: no ejecutar SQL
            } else {
                try {
                    // 3. Validar consulta (seguridad)
                    validarConsultaSql(sqlGenerada);

                    // 4. Ejecutar consulta en la base de datos (lectura o modificación controlada)
                    resultados = ejecutarConsulta(sqlGenerada);
                } catch (IllegalArgumentException e) {
                    // Error de seguridad/validación: pasar mensaje al formateador
                    System.err.println("🚨 [Chatbot] Consulta rechazada por seguridad: " + e.getMessage());
                    Map<String, Object> errorResult = new java.util.HashMap<>();
                    errorResult.put("error_seguridad", e.getMessage());
                    resultados.add(errorResult);
                } catch (Exception e) {
                    // Error de ejecución SQL: pasar detalle al formateador en lugar de lanzar 500
                    System.err.println("❌ [Chatbot] Error SQL: " + e.getMessage());
                    Map<String, Object> errorResult = new java.util.HashMap<>();
                    errorResult.put("error_sql", e.getMessage());
                    errorResult.put("sql_intentado", sqlGenerada);
                    resultados.add(errorResult);
                }
            }
        }

        // 5. Formatear la respuesta usando Ollama con los resultados obtenidos
        String formatSystemPrompt = "Eres un asistente amigable de una plataforma escolar. Tu tarea es responder a la pregunta o confirmar la acción realizada al usuario en español utilizando los resultados reales obtenidos de la base de datos o el contexto provisto.\n"
                +
                "Reglas:\n" +
                "1. Responde de manera clara y concisa.\n" +
                "2. Si la consulta SQL no devolvió registros (y no es un saludo), indícalo de manera amable (ej. 'No encontré registros para...').\n" +
                "3. Si fue una inserción, modificación o eliminación exitosa (ej. `operacion_exitosa=true`), confírmale amigablemente al usuario la acción realizada.\n" +
                "4. No muestres código SQL en tu respuesta final a menos que el usuario lo solicite.\n" +
                "5. IMPORTANTE: En tu respuesta final al usuario, NUNCA muestres o menciones IDs internos de la base de datos (como id_usuario, id_sede, id_alumno, id_admin, etc.), a menos que el usuario los pida explícitamente. Traduce o presenta la información de manera amigable.\n" +
                "6. IMPORTANTE: Si la pregunta del usuario es únicamente un saludo (como 'hola', 'saludos', etc.) y no se ejecutó ninguna consulta SQL, responde EXACTAMENTE en el siguiente formato:\n" +
                "   '¡Hola [Nombre]! ¿Cómo estás? ¿Cuál es tu pregunta?'\n" +
                "   Reemplazando [Nombre] únicamente por el primer y segundo nombre del usuario (sin apellidos, ej. 'Nayelli Yuley') indicados en 'Primeros nombres del usuario actual'. No agregues ningún otro texto, ni detalles sobre sus apellidos ni estados de datos.\n" +
                "7. IMPORTANTE: Si los resultados contienen un campo `error_sql`, significa que la consulta SQL falló. Explícale amigablemente al usuario que hubo un problema al procesar su solicitud y pídele que verifique los datos proporcionados (como el tipo de documento o la sede). NO muestres el SQL ni el error técnico.\n" +
                "8. IMPORTANTE: Si el usuario solicitó información sobre qué campos se necesitan para registrar en una tabla (es_consulta_requisitos=true), lista los campos OBLIGATORIOS y opcionales en español amigable y pídele que te los proporcione para hacer el registro.";

        String userPromptFormat = "Contexto del usuario:\n" + contextDesc.toString() + "\n" +
                "Pregunta/Instrucción del usuario: " + pregunta + "\n" +
                "Consulta SQL ejecutada: " + sqlGenerada + "\n" +
                "Resultados de la base de datos (formato JSON): " + objectMapper.writeValueAsString(resultados) + "\n\n"
                +
                "Redacta la respuesta final en base a esta información.";

        return ollamaClient.generate(formatSystemPrompt, userPromptFormat);
    }

    /**
     * Realiza validaciones estrictas sobre la cadena SQL generada para evitar
     * código malicioso.
     */
    private void validarConsultaSql(String sql) {
        String upper = sql.toUpperCase().trim();

        boolean esLectura = upper.startsWith("SELECT") || upper.startsWith("WITH");
        boolean esEscrituraPermitida = upper.startsWith("INSERT") || upper.startsWith("UPDATE") || upper.startsWith("DELETE");

        if (!esLectura && !esEscrituraPermitida) {
            throw new IllegalArgumentException("Acceso denegado: El tipo de consulta SQL no está permitido.");
        }

        // Si es una modificación de datos, validar que no intente escribir en tablas sensibles
        if (esEscrituraPermitida) {
            String[] tablasRestringidasParaEscritura = {
                "usuarios", "super_admins", "sedes", "institucion", "planes", "suscripciones", "roles", "modulos", "metodos_pago"
            };

            for (String tabla : tablasRestringidasParaEscritura) {
                if (upper.matches(".*\\b" + tabla.toUpperCase() + "\\b.*")) {
                    throw new IllegalArgumentException("Acceso denegado: No tienes autorización para modificar la tabla '" + tabla + "'.");
                }
            }
        }

        // Lista de palabras clave prohibidas de administración
        String[] palabrasProhibidas = {
            "DROP", "ALTER", "TRUNCATE", "REPLACE", "CREATE", "GRANT", "REVOKE", "SHUTDOWN"
        };

        for (String palabra : palabrasProhibidas) {
            // Verificar coincidencia como palabra completa
            if (upper.matches(".*\\b" + palabra + "\\b.*")) {
                throw new IllegalArgumentException(
                        "Acceso denegado: Comando no permitido detectado (" + palabra + ").");
            }
        }
    }

    /**
     * Ejecuta la consulta SQL SELECT y retorna los resultados como una lista de
     * mapas.
     */
    private List<Map<String, Object>> ejecutarConsulta(String sql) throws SQLException {
        List<Map<String, Object>> filas = new ArrayList<>();

        try (Connection conn = getReadOnlyConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setQueryTimeout(10);

            String upper = sql.toUpperCase().trim();
            boolean esSelect = upper.startsWith("SELECT") || upper.startsWith("WITH");

            if (esSelect) {
                try (ResultSet rs = stmt.executeQuery()) {
                    ResultSetMetaData metaData = rs.getMetaData();
                    int columnCount = metaData.getColumnCount();

                    int rowCount = 0;
                    while (rs.next() && rowCount < 50) {
                        Map<String, Object> fila = new HashMap<>();
                        for (int i = 1; i <= columnCount; i++) {
                            String columnName = metaData.getColumnLabel(i);
                            Object value = rs.getObject(i);
                            fila.put(columnName, value);
                        }
                        filas.add(fila);
                        rowCount++;
                    }
                }
            } else {
                // Ejecutar consulta de modificación (INSERT, UPDATE, DELETE)
                int affectedRows = stmt.executeUpdate();
                Map<String, Object> res = new HashMap<>();
                res.put("operacion_exitosa", true);
                res.put("filas_afectadas", affectedRows);
                filas.add(res);
            }
        }

        return filas;
    }

    /**
     * Obtiene el nombre completo del usuario a partir de su ID y rol.
     */
    private String obtenerNombreCompletoUsuario(Long userId, boolean isSuperAdmin) {
        if (userId == null) {
            return null;
        }
        String sql = isSuperAdmin 
            ? "SELECT nombres, apellidos FROM super_admins WHERE id_admin = ?" 
            : "SELECT nombres, apellidos FROM usuarios WHERE id_usuario = ?";
            
        try (Connection conn = primaryDataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String nombres = rs.getString("nombres");
                    String apellidos = rs.getString("apellidos");
                    return (nombres != null ? nombres.trim() : "") + " " + (apellidos != null ? apellidos.trim() : "");
                }
            }
        } catch (Exception e) {
            System.err.println("⚠️ [Chatbot] No se pudo obtener el nombre completo del usuario: " + e.getMessage());
        }
        return null;
    }

    /**
     * Limpia y extrae únicamente la sentencia SQL de la respuesta de Ollama,
     * descartando texto introductorio/explicativo y bloques markdown.
     */
    private String limpiarYExtraerSql(String response) {
        if (response == null) return "";
        String clean = response.trim();

        // 1. Si hay un bloque ```sql ... ``` o ``` ... ```, extraer su contenido
        int startIdx = clean.indexOf("```sql");
        if (startIdx == -1) startIdx = clean.indexOf("```");

        if (startIdx != -1) {
            int lineEnd = clean.indexOf("\n", startIdx);
            if (lineEnd != -1) {
                int endIdx = clean.indexOf("```", lineEnd);
                String extracted = (endIdx != -1)
                    ? clean.substring(lineEnd, endIdx).trim()
                    : clean.substring(lineEnd).trim();
                // Si hay múltiples sentencias separadas por ;, tomar solo la primera
                int firstSemicolon = extracted.indexOf(";");
                if (firstSemicolon != -1 && !extracted.trim().toUpperCase().startsWith("SELECT")) {
                    extracted = extracted.substring(0, firstSemicolon + 1).trim();
                }
                return extracted;
            }
        }

        // 2. Sin bloque markdown: buscar la primera palabra clave SQL en el texto
        String upper = clean.toUpperCase();
        int firstSqlKeyword = -1;
        for (String kw : new String[]{"SELECT ", "INSERT INTO ", "UPDATE ", "DELETE FROM ", "WITH ", "INFO_REQUISITOS:"}) {
            int idx = upper.indexOf(kw);
            if (idx != -1 && (firstSqlKeyword == -1 || idx < firstSqlKeyword)) {
                firstSqlKeyword = idx;
            }
        }

        if (firstSqlKeyword != -1) {
            String sqlPart = clean.substring(firstSqlKeyword).trim();
            // Cortar en el primer párrafo doble (texto explicativo posterior)
            int doubleNewline = sqlPart.indexOf("\n\n");
            if (doubleNewline != -1) {
                sqlPart = sqlPart.substring(0, doubleNewline).trim();
            }
            return sqlPart;
        }

        return clean;
    }

    /**
     * Intenta construir un INSERT SQL directamente desde el mensaje del usuario
     * cuando los datos vienen en el formato "[valor] - [nombre_campo]".
     * Retorna el SQL si logra parsearlo, o null si Ollama debe manejarlo.
     */
    private String construirInsertDesdeFormato(String pregunta, Long sedeId) {
        String pl = pregunta.toLowerCase();
        boolean esInsert = pl.contains("inserta") || pl.contains("insert") ||
                           pl.contains("registra") || pl.contains("agrega") ||
                           pl.contains("añade") || pl.contains("ingresa") || pl.contains("nuevo alumno");
        if (!esInsert) return null;

        String tabla = null;
        java.util.LinkedHashMap<String, String> aliasMap = new java.util.LinkedHashMap<>();

        if (pl.contains("alumno")) {
            tabla = "alumnos";
            aliasMap.put("fecha de nacimiento", "fecha_nacimiento");
            aliasMap.put("fecha nacimiento", "fecha_nacimiento");
            aliasMap.put("fecha_nacimiento", "fecha_nacimiento");
            aliasMap.put("fecha nac", "fecha_nacimiento");
            aliasMap.put("numero de documento", "numero_documento");
            aliasMap.put("numero documento", "numero_documento");
            aliasMap.put("numero_documento", "numero_documento");
            aliasMap.put("nro documento", "numero_documento");
            aliasMap.put("número documento", "numero_documento");
            aliasMap.put("telefono contacto", "telefono_contacto");
            aliasMap.put("telefono_contacto", "telefono_contacto");
            aliasMap.put("id tipo doc", "id_tipo_doc");
            aliasMap.put("tipo de documento", "id_tipo_doc");
            aliasMap.put("tipo documento", "id_tipo_doc");
            aliasMap.put("id_tipo_doc", "id_tipo_doc");
            aliasMap.put("tipo doc", "id_tipo_doc");
            aliasMap.put("apellidos", "apellidos");
            aliasMap.put("apellido", "apellidos");
            aliasMap.put("nombres", "nombres");
            aliasMap.put("nombre", "nombres");
            aliasMap.put("telefono", "telefono_contacto");
            aliasMap.put("dirección", "direccion");
            aliasMap.put("direccion", "direccion");
            aliasMap.put("género", "genero");
            aliasMap.put("genero", "genero");
        } else if (pl.contains("apoderado")) {
            tabla = "apoderados";
            aliasMap.put("tipo de documento", "id_tipo_doc");
            aliasMap.put("tipo documento", "id_tipo_doc");
            aliasMap.put("id tipo doc", "id_tipo_doc");
            aliasMap.put("id_tipo_doc", "id_tipo_doc");
            aliasMap.put("numero de documento", "numero_documento");
            aliasMap.put("numero documento", "numero_documento");
            aliasMap.put("numero_documento", "numero_documento");
            aliasMap.put("apellidos", "apellidos");
            aliasMap.put("apellido", "apellidos");
            aliasMap.put("nombres", "nombres");
            aliasMap.put("nombre", "nombres");
            aliasMap.put("telefono", "telefono");
            aliasMap.put("correo", "correo");
            aliasMap.put("email", "correo");
            aliasMap.put("dirección", "direccion");
            aliasMap.put("direccion", "direccion");
            aliasMap.put("parentesco", "parentesco");
            aliasMap.put("género", "genero");
            aliasMap.put("genero", "genero");
        } else if (pl.contains("matrícula") || pl.contains("matricula")) {
            tabla = "matriculas";
            aliasMap.put("id alumno", "id_alumno");
            aliasMap.put("id_alumno", "id_alumno");
            aliasMap.put("año lectivo", "anio_lectivo");
            aliasMap.put("anio lectivo", "anio_lectivo");
            aliasMap.put("anio_lectivo", "anio_lectivo");
            aliasMap.put("id grado", "id_grado");
            aliasMap.put("grado", "id_grado");
            aliasMap.put("id seccion", "id_seccion");
            aliasMap.put("sección", "id_seccion");
            aliasMap.put("seccion", "id_seccion");
            aliasMap.put("id nivel", "id_nivel");
            aliasMap.put("nivel", "id_nivel");
            aliasMap.put("turno", "turno");
            aliasMap.put("fecha de matricula", "fecha_matricula");
            aliasMap.put("fecha matricula", "fecha_matricula");
            aliasMap.put("fecha_matricula", "fecha_matricula");
        }

        if (tabla == null) return null;

        // Extraer parte de datos tras el primer ":"
        String dataPart = pregunta;
        int colon = pregunta.indexOf(":");
        if (colon != -1) dataPart = pregunta.substring(colon + 1).trim();

        // Parsear segmentos separados por " - "
        String[] segments = dataPart.split("\\s+-\\s+");
        if (segments.length < 2) return null;

        // Ordenar aliases por longitud desc para greedy matching
        java.util.List<java.util.Map.Entry<String, String>> sortedAliases = new java.util.ArrayList<>(aliasMap.entrySet());
        sortedAliases.sort((a, b) -> Integer.compare(b.getKey().length(), a.getKey().length()));

        java.util.LinkedHashMap<String, String> parsedData = new java.util.LinkedHashMap<>();
        String pendingValue = segments[0].trim();

        for (int i = 1; i < segments.length; i++) {
            String seg = segments[i].trim();
            String matchedCol = null;
            String nextValue = "";

            for (java.util.Map.Entry<String, String> entry : sortedAliases) {
                String alias = entry.getKey();
                if (seg.toLowerCase().startsWith(alias.toLowerCase())) {
                    matchedCol = entry.getValue();
                    nextValue = seg.substring(alias.length()).trim();
                    break;
                }
            }

            if (matchedCol == null) return null; // campo no reconocido → dejar a Ollama

            if (!pendingValue.isEmpty()) {
                parsedData.put(matchedCol, pendingValue);
            }
            pendingValue = nextValue;
        }

        if (parsedData.isEmpty()) return null;

        // Inyectar campos automáticos
        if (!parsedData.containsKey("estado")) {
            parsedData.put("estado", "1");
        }
        if (sedeId != null && !parsedData.containsKey("id_sede") && !tabla.equals("apoderados")) {
            parsedData.put("id_sede", sedeId.toString());
        }

        // Construir SQL
        StringBuilder cols = new StringBuilder();
        StringBuilder vals = new StringBuilder();
        boolean first = true;
        for (java.util.Map.Entry<String, String> entry : parsedData.entrySet()) {
            if (!first) { cols.append(", "); vals.append(", "); }
            first = false;
            cols.append(entry.getKey());
            vals.append(quoteSqlValue(entry.getValue()));
        }

        return "INSERT INTO " + tabla + " (" + cols + ") VALUES (" + vals + ")";
    }

    /**
     * Aplica comillas SQL a un valor según su tipo inferido.
     */
    private String quoteSqlValue(String value) {
        if (value == null || value.equalsIgnoreCase("null")) return "NULL";
        if (value.matches("^-?\\d+$")) return value;
        if (value.matches("^-?\\d+\\.\\d+$")) return value;
        if (value.matches("^\\d{4}-\\d{2}-\\d{2}$")) return "'" + value + "'";
        return "'" + value.replace("'", "\\'") + "'";
    }
}
