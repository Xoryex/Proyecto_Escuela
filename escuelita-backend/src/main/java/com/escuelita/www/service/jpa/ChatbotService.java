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

    private final ObjectMapper objectMapper = new ObjectMapper();

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
                String[] tablasPermitidas = {"matriculas", "evaluaciones", "calificaciones", "asistencias"};
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

            String query = "SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE " +
                    "FROM INFORMATION_SCHEMA.COLUMNS " +
                    "WHERE TABLE_SCHEMA = ? " +
                    "ORDER BY TABLE_NAME, ORDINAL_POSITION";

            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, dbName);

                try (ResultSet rs = stmt.executeQuery()) {
                    String currentTable = "";
                    while (rs.next()) {
                        String tableName = rs.getString("TABLE_NAME");
                        String columnName = rs.getString("COLUMN_NAME");
                        String dataType = rs.getString("DATA_TYPE");

                        if (!tableName.equals(currentTable)) {
                            currentTable = tableName;
                            schemaDesc.append("\nTabla: ").append(tableName).append("\nColumnas: ");
                        } else {
                            schemaDesc.append(", ");
                        }
                        schemaDesc.append(columnName).append(" (").append(dataType).append(")");
                    }
                }
            }
        }

        return schemaDesc.toString();
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

        // 2. Definir system prompt para la generación de la consulta SQL
        String sqlSystemPrompt = "Eres un asistente experto en bases de datos MySQL. Tu única tarea es generar una consulta SQL válida (SELECT, INSERT, UPDATE o DELETE) basada en la estructura de la base de datos provista.\n"
                +
                "Reglas obligatorias:\n" +
                "1. Tienes permitido realizar consultas de lectura (SELECT) en todas las tablas.\n" +
                "2. Tienes permitido realizar consultas de modificación de datos (INSERT, UPDATE, DELETE) ÚNICAMENTE sobre las tablas relacionadas a matrículas (`matriculas`) y notas/evaluaciones (`evaluaciones`, `calificaciones`, `asistencias`).\n" +
                "3. Para cualquier otra tabla (como `usuarios`, `sedes`, `planes`, `suscripciones`, `roles`, etc.), solo tienes permiso de lectura. NO generes INSERT, UPDATE o DELETE sobre ellas.\n" +
                "4. NO está permitido modificar la estructura de la base de datos (nada de DROP, ALTER, CREATE, TRUNCATE, etc.).\n" +
                "5. Devuelve únicamente el código SQL limpio. NO uses bloques de código de markdown (```sql ... ```), ni explicaciones ni texto introductorio. Solo el código SQL directamente listo para ejecutarse.\n" +
                "6. Responde con el SQL exacto para MySQL que responda a la pregunta o instrucción del usuario basándote en las tablas y campos indicados.";

        String userPromptSqlGen = "Estructura de la base de datos:\n" + esquema + "\n\n" +
                "Instrucción del usuario: " + pregunta + "\n\n" +
                "Genera la consulta SQL que responda a esta instrucción.";

        // Generar la consulta SQL
        String sqlGenerada = ollamaClient.generate(sqlSystemPrompt, userPromptSqlGen);

        // Limpiar bloques markdown si la IA los incluyó por error
        if (sqlGenerada.startsWith("```")) {
            sqlGenerada = sqlGenerada.replaceAll("^```(sql)?\\s*", "").replaceAll("\\s*```$", "");
        }
        sqlGenerada = sqlGenerada.trim();

        System.out.println("🤖 SQL Generada por Ollama: " + sqlGenerada);

        // 3. Validar consulta (seguridad)
        validarConsultaSql(sqlGenerada);

        // 4. Ejecutar consulta en la base de datos (lectura o modificación controlada)
        List<Map<String, Object>> resultados = ejecutarConsulta(sqlGenerada);

        // 5. Formatear la respuesta usando Ollama con los resultados obtenidos
        String formatSystemPrompt = "Eres un asistente amigable de una plataforma escolar. Tu tarea es responder a la pregunta o confirmar la acción realizada al usuario en español utilizando los resultados reales obtenidos de la base de datos.\n"
                +
                "Reglas:\n" +
                "1. Responde de manera clara y concisa.\n" +
                "2. Si la consulta SQL no devolvió registros, indícalo de manera amable (ej. 'No encontré registros para...').\n" +
                "3. Si fue una inserción, modificación o eliminación exitosa (ej. `operacion_exitosa=true`), confírmale amigablemente al usuario la acción realizada.\n" +
                "4. No muestres código SQL en tu respuesta final a menos que el usuario lo solicite.";

        String userPromptFormat = "Pregunta/Instrucción del usuario: " + pregunta + "\n" +
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
}
