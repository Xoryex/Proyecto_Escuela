package com.escuelita.www.util;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Cliente HTTP para interactuar con la API local de Ollama.
 */
@Component
public class OllamaClient {

    @Value("${ollama.api.url}")
    private String apiUrl;// esto hace que se conecte con la url de ollama

    @Value("${ollama.model}")
    private String model;// esto hace que se conecte con el modelo de ollama

    private final HttpClient httpClient;// esto hace que el proyecto se conecte con ollama
    private final ObjectMapper objectMapper;// esto hace que el objeto se pueda convertir a json y viceversa

    public OllamaClient() {
        // esto hace que el proyecto se conecte con ollama
        this.httpClient = HttpClient.newBuilder()
                // establece el tiempo maximo de espera para establecer la conexion con ollama
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        // esto hace que el objeto se pueda convertir a json y viceversa
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Envía un prompt a Ollama y retorna la respuesta de texto generada.
     */
    public String generate(String systemPrompt, String userPrompt) throws Exception {
        // esto hace que la url se complete si no tiene slash al final
        String fullUrl = apiUrl.trim();
        if (!fullUrl.endsWith("/")) {
            fullUrl += "/";
        }
        fullUrl += "api/chat";

        // Preparar el cuerpo del request para /api/chat
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", model);
        requestBody.put("stream", false);

        List<Map<String, String>> messages = new ArrayList<>();
        if (systemPrompt != null && !systemPrompt.isEmpty()) {
            Map<String, String> systemMsg = new HashMap<>();
            systemMsg.put("role", "system");
            systemMsg.put("content", systemPrompt);
            messages.add(systemMsg);
        }

        Map<String, String> userMsg = new HashMap<>();
        userMsg.put("role", "user");
        userMsg.put("content", userPrompt);
        messages.add(userMsg);

        requestBody.put("messages", messages);

        String jsonRequest = objectMapper.writeValueAsString(requestBody);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(fullUrl))
                .header("Content-Type", "application/json")
                .timeout(Duration.ofSeconds(90)) // La generación de consultas complejas puede tardar un poco
                .POST(HttpRequest.BodyPublishers.ofString(jsonRequest))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new RuntimeException("Error al comunicarse con Ollama. Código HTTP: " + response.statusCode()
                    + ", Respuesta: " + response.body());
        }

        // Parsear respuesta para /api/chat
        Map<?, ?> responseMap = objectMapper.readValue(response.body(), Map.class);
        Map<?, ?> messageMap = (Map<?, ?>) responseMap.get("message");
        if (messageMap == null) {
            throw new RuntimeException("La respuesta de Ollama no contiene el objeto 'message'. Cuerpo: " + response.body());
        }
        return (String) messageMap.get("content");
    }
}
