package com.escuelita.www.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.escuelita.www.entity.RolModulo;

@Repository
public interface ModuloAccesoRepository extends JpaRepository<RolModulo, Long> {
    
    /**
     * Busca todos los módulos asignados a un rol específico
     * @param idRol ID del rol
     * @return Lista de RolModulo asociados al rol
     */
    @Query("SELECT rm FROM RolModulo rm WHERE rm.idRol.idRol = :idRol AND rm.estado = 1")
    List<RolModulo> findByIdRolAndEstado(@Param("idRol") Long idRol);
    
    /**
     * Valida directamente en BD si el usuario activo tiene acceso al módulo solicitado
     * a través de su rol en rol_modulo (o si posee un rol administrador).
     * Reemplaza al procedimiento almacenado inexistente validar_acceso_modulo_usuario.
     *
     * @param idUsuario ID del usuario
     * @param idModulo ID del módulo (1-8)
     * @return 1 si tiene acceso, 0 si no
     */
    @Query(value = """
            SELECT CASE WHEN EXISTS (
                SELECT 1
                FROM usuarios u
                INNER JOIN roles r ON r.id_rol = u.id_rol AND r.estado = 1
                LEFT JOIN rol_modulo rm ON rm.id_rol = r.id_rol
                    AND rm.id_modulo = :idModulo
                    AND rm.estado = 1
                WHERE u.id_usuario = :idUsuario
                  AND u.estado = 1
                  AND (
                      rm.id_rol_modulo IS NOT NULL
                      OR UPPER(r.nombre) LIKE '%ADMIN%'
                  )
            ) THEN 1 ELSE 0 END
            """, nativeQuery = true)
    Integer validarAccesoModulo(
        @Param("idUsuario") Long idUsuario,
        @Param("idModulo") Long idModulo
    );
}
