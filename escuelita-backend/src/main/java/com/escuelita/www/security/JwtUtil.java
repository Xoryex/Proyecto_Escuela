package com.escuelita.www.security;

import java.util.Date;

import io.jsonwebtoken.security.Keys;

import java.nio.charset.StandardCharsets;

import javax.crypto.SecretKey;

import org.springframework.stereotype.Component;

import io.jsonwebtoken.Jwts;

@Component
public class JwtUtil {
    private final SecretKey key = Keys.hmacShaKeyFor(
            "Xy7$pQ2#mK9!aB5@zT8*wN4&eR1^vU6%cO3(kL0)jI7-hG8_fF9+dD0=sS1[aA2]"
                    .getBytes(StandardCharsets.UTF_8));
    private final long EXPIRATION_TIME = 100L * 365 * 24 * 60 * 60 * 1000;

    public String generarToken(String clienteId) {
        return Jwts.builder()
                .subject(clienteId)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis()
                        + EXPIRATION_TIME))
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
