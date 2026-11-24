package com.escuelita.www.security;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.escuelita.www.service.jpa.ModuloAccesoService;
import com.escuelita.www.util.TenantContext;

import jakarta.servlet.http.HttpServletRequest;

@Aspect
@Component
public class ModuloAccesoAspect {

    @Autowired
    private ModuloAccesoService serviceAcceso;
    @Autowired
    private HttpServletRequest request;

    /**
     * Extrae el ID del usuario del JWT token (claims)
     * 
     * @return ID del usuario o null si no está disponible
     */
    private Long obtenerIdUsuarioDelToken() {
        // Fuente de verdad única: TenantContext poblado por JwtFilter tras verificar firma JWT
        if (TenantContext.hasUserId()) {
            return TenantContext.getUserId();
        }
        return null;
    }

    /**
     * Intercepta llamadas a métodos anotados con @RequireModulo
     * Valida que el usuario tenga acceso al módulo especificado
     * 
     * NOTA: Los SUPER ADMINS tienen acceso a TODO sin validación
     */
    @Around("@annotation(requireModulo)")
    public Object validarAcceso(ProceedingJoinPoint joinPoint, RequireModulo requireModulo)
            throws Throwable {

        String nombreMetodo = joinPoint.getSignature().getName();
        long idModulo = requireModulo.value();

        // ✅ SUPER ADMINS: Acceso completo sin validación
        if (TenantContext.isSuperAdmin()) {
            return joinPoint.proceed();
        }

        // 🔒 USUARIOS DE ESCUELA: Validar permisos de módulo obligatoriamente
        Long idUsuario = obtenerIdUsuarioDelToken();

        if (idUsuario == null) {
            System.err.println("❌ Acceso denegado en " + nombreMetodo + ": no existe ID de usuario verificado en JWT");
            throw new SecurityException("Usuario no autenticado o sesión inválida");
        }

        try {
            if (!serviceAcceso.tieneAccesoModulo(idUsuario, idModulo)) {
                System.err.println("🚫 Usuario " + idUsuario + " NO tiene acceso a módulo " + idModulo);
                throw new SecurityException("No tienes acceso al módulo solicitado");
            }
            return joinPoint.proceed();
        } catch (SecurityException e) {
            throw e;
        } catch (Exception e) {
            System.err.println("❌ Error al validar acceso: " + e.getMessage());
            throw new SecurityException("Error al validar acceso: " + e.getMessage());
        }
    }
}
