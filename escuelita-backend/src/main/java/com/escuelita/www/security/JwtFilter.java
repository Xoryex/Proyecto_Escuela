package com.escuelita.www.security;

import java.io.IOException;
import java.util.Collections;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.escuelita.www.entity.Registros;
import com.escuelita.www.repository.RegistrosRepository;
import com.escuelita.www.util.TenantContext;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtFilter extends OncePerRequestFilter {
    @Autowired
    private RegistrosRepository registrosRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
            FilterChain chain) throws IOException, ServletException {
        try {
            String header = request.getHeader("Authorization");

            if (header != null && header.startsWith("Bearer ")) {
                String token = header.substring(7);

                if (jwtUtil.validarToken(token)) {
                    String clienteId = jwtUtil.extraerClienteId(token);

                    if (clienteId.startsWith("SUPER_ADMIN_") || clienteId.startsWith("ADMIN_")) {
                        TenantContext.setUserType("SUPER_ADMIN");
                        String prefix = clienteId.startsWith("SUPER_ADMIN_") ? "SUPER_ADMIN_" : "ADMIN_";
                        try {
                            TenantContext.setUserId(Long.parseLong(clienteId.substring(prefix.length())));
                        } catch (NumberFormatException ignored) {
                            // Subject no numérico
                        }
                    } else if (clienteId.contains("_SEDE_")) {
                        // Formato: "ESCUELA_123_SEDE_45"
                        try {
                            String[] parts = clienteId.split("_SEDE_");
                            if (parts.length == 2) {
                                Long sedeId = Long.parseLong(parts[1]);
                                TenantContext.setSedeId(sedeId);
                                TenantContext.setUserType("ESCUELA");
                                String escuelaPart = parts[0];
                                if (escuelaPart.startsWith("ESCUELA_")) {
                                    Long userId = Long.parseLong(escuelaPart.substring("ESCUELA_".length()));
                                    TenantContext.setUserId(userId);
                                }
                            }
                        } catch (NumberFormatException e) {
                            System.err.println("⚠️  Error al extraer sede/usuario del token: " + clienteId);
                        }
                    } else {
                        Optional<Registros> registroMatch = registrosRepository
                                .findAll().stream()
                                .filter(r -> clienteId.equals(r.getCliente_id()))
                                .findFirst();

                        if (registroMatch.isPresent()) {
                            TenantContext.setUserType("SUPER_ADMIN");
                        }
                    }

                    UsernamePasswordAuthenticationToken auth =
                            new UsernamePasswordAuthenticationToken(clienteId, null, Collections.emptyList());
                    SecurityContextHolder.getContext().setAuthentication(auth);
                } else {
                    Optional<Registros> match = registrosRepository
                            .findAll().stream()
                            .filter(r -> token.equals(r.getAccess_token()))
                            .findFirst();

                    if (match.isPresent()) {
                        String clienteId = match.get().getCliente_id();
                        TenantContext.setUserType("SUPER_ADMIN");
                        UsernamePasswordAuthenticationToken auth =
                                new UsernamePasswordAuthenticationToken(clienteId, null, Collections.emptyList());
                        SecurityContextHolder.getContext().setAuthentication(auth);
                    }
                }
            }

            chain.doFilter(request, response);
        } finally {
            TenantContext.clear();
        }
    }
}
