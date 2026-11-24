package com.escuelita.www.security;

import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtUtil {
    private final SecretKey key;
    private final long expirationTimeMs;

    public JwtUtil(
            @Value("${jwt.secret:Siae2026JwtSecretKey9f8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0a9b8c}") String secret,
            @Value("${jwt.expiration.ms:604800000}") long expirationTimeMs) {
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            throw new IllegalArgumentException(
                    "JWT_SECRET debe tener al menos 32 caracteres (actual: " + keyBytes.length + " bytes). "
                    + "Evita usar '#' sin comillas en .env porque trunca el valor como comentario.");
        }
        this.key = Keys.hmacShaKeyFor(keyBytes);
        this.expirationTimeMs = expirationTimeMs;
    }

    public String generarToken(String clienteId) {
        return Jwts.builder()
                .subject(clienteId)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expirationTimeMs))
                .signWith(key)
                .compact();
    }

    public boolean validarToken(String token) {
        try {
            Jwts.parser().verifyWith(key).build()
                    .parseSignedClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public String extraerClienteId(String token) {
        return Jwts.parser().verifyWith(key).build()
                .parseSignedClaims(token).getPayload().getSubject();
    }
}
