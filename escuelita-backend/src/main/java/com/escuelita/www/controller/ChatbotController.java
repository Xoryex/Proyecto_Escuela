package com.escuelita.www.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.escuelita.www.service.jpa.ChatbotService;

import jakarta.annotation.PostConstruct;

@RestController
@RequestMapping("/api/chatbot")
@CrossOrigin(origins = "*")
public class ChatbotController {

    @Autowired
    private ChatbotService chatbotService;

    /**
     * Endpoint para realizar preguntas a la IA en lenguaje natural sobre la base de
     * datos.
     */
    @PostMapping("/preguntar")
    public ResponseEntity<Map<String, String>> preguntar(@RequestBody Map<String, String> request) {
        Map<String, String> response = new HashMap<>();
        String pregunta = request.get("pregunta");

        if (pregunta == null || pregunta.trim().isEmpty()) {
            response.put("error", "La pregunta no puede estar vacía.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }

        try {
            String respuesta = chatbotService.procesarPregunta(pregunta);
            response.put("respuesta", respuesta);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            // Manejar excepciones de denegación de acceso/seguridad
            response.put("error", "Seguridad: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("error", "Error interno al procesar la consulta: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
