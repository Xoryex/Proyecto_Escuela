package com.escuelita.www.service.jpa;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.escuelita.www.entity.Matriculas;
import com.escuelita.www.entity.MovimientosAlumno;
import com.escuelita.www.repository.MatriculasRepository;
import com.escuelita.www.repository.MovimientosAlumnoRepository;
import com.escuelita.www.util.TenantContext;

@Service
public class MovimientosAlumnoService {
    
    @Autowired
    private MovimientosAlumnoRepository repoMovimientos;
    
    @Autowired
    private MatriculasRepository repoMatriculas;

    private Long extraerSedeId(MovimientosAlumno mov) {
        if (mov != null && mov.getIdMatricula() != null
                && mov.getIdMatricula().getIdSeccion() != null
                && mov.getIdMatricula().getIdSeccion().getIdSede() != null) {
            return mov.getIdMatricula().getIdSeccion().getIdSede().getIdSede();
        }
        return null;
    }

    private void validarPermisoSede(MovimientosAlumno mov, String accion) {
        if (TenantContext.isSuperAdmin()) return;
        Long userSede = TenantContext.getSedeId();
        Long recSede = extraerSedeId(mov);
        if (userSede == null || recSede == null || !userSede.equals(recSede)) {
            throw new SecurityException("No tienes permiso para " + accion + " movimientos de otra sede");
        }
    }

    private List<MovimientosAlumno> filtrarPorSede(List<MovimientosAlumno> lista) {
        if (TenantContext.isSuperAdmin()) return lista;
        Long sedeId = TenantContext.getSedeId();
        return lista.stream()
                .filter(m -> sedeId != null && sedeId.equals(extraerSedeId(m)))
                .collect(Collectors.toList());
    }
    
    /**
     * Buscar todos los movimientos
     */
    public List<MovimientosAlumno> buscarTodos() {
        return filtrarPorSede(repoMovimientos.findAll());
    }
    
    /**
     * Buscar movimiento por ID
     */
    public Optional<MovimientosAlumno> buscarPorId(Long id) {
        Optional<MovimientosAlumno> opt = repoMovimientos.findById(id);
        if (TenantContext.isSuperAdmin() || opt.isEmpty()) return opt;
        Long sedeId = TenantContext.getSedeId();
        return (sedeId != null && sedeId.equals(extraerSedeId(opt.get()))) ? opt : Optional.empty();
    }
    
    /**
     * Buscar movimientos por matrícula
     */
    public List<MovimientosAlumno> buscarPorMatricula(Long idMatricula) {
        return filtrarPorSede(repoMovimientos.findByIdMatricula_IdMatricula(idMatricula));
    }
    
    /**
     * Buscar movimientos por alumno
     */
    public List<MovimientosAlumno> buscarPorAlumno(Long idAlumno) {
        return filtrarPorSede(repoMovimientos.findMovimientosByAlumno(idAlumno));
    }
    
    /**
     * Buscar movimientos pendientes de aprobación
     */
    public List<MovimientosAlumno> buscarPendientes() {
        return filtrarPorSede(repoMovimientos.findMovimientosPendientes());
    }
    
    /**
     * Buscar movimientos por tipo
     */
    public List<MovimientosAlumno> buscarPorTipo(String tipoMovimiento) {
        return filtrarPorSede(repoMovimientos.findByTipoMovimiento(tipoMovimiento));
    }
    
    /**
     * Crear nuevo movimiento (retiro, traslado, etc)
     */
    @Transactional
    public MovimientosAlumno crear(MovimientosAlumno movimiento) {
        validarPermisoSede(movimiento, "crear");
        if (movimiento.getFechaSolicitud() == null) {
            movimiento.setFechaSolicitud(LocalDateTime.now());
        }
        if (movimiento.getEstadoSolicitud() == null) {
            movimiento.setEstadoSolicitud("Pendiente");
        }
        return repoMovimientos.save(movimiento);
    }
    
    /**
     * Aprobar movimiento
     */
    @Transactional
    public MovimientosAlumno aprobar(Long idMovimiento) {
        MovimientosAlumno movimiento = repoMovimientos.findById(idMovimiento)
                .orElseThrow(() -> new IllegalArgumentException("Movimiento no encontrado"));
        validarPermisoSede(movimiento, "aprobar");
        
        if (!"Pendiente".equals(movimiento.getEstadoSolicitud())) {
            throw new IllegalArgumentException("El movimiento ya fue procesado");
        }
        
        movimiento.setEstadoSolicitud("Aprobada");
        movimiento.setFechaAprobacion(LocalDateTime.now());
        
        Matriculas matricula = movimiento.getIdMatricula();
        if (matricula != null) {
            if ("Retiro".equals(movimiento.getTipoMovimiento()) || 
                "Traslado_Saliente".equals(movimiento.getTipoMovimiento())) {
                matricula.setEstadoMatricula("Finalizada");
                repoMatriculas.save(matricula);
            }
        }
        
        return repoMovimientos.save(movimiento);
    }
    
    /**
     * Rechazar movimiento
     */
    @Transactional
    public MovimientosAlumno rechazar(Long idMovimiento) {
        MovimientosAlumno movimiento = repoMovimientos.findById(idMovimiento)
                .orElseThrow(() -> new IllegalArgumentException("Movimiento no encontrado"));
        validarPermisoSede(movimiento, "rechazar");
        
        if (!"Pendiente".equals(movimiento.getEstadoSolicitud())) {
            throw new IllegalArgumentException("El movimiento ya fue procesado");
        }
        
        movimiento.setEstadoSolicitud("Rechazada");
        movimiento.setFechaAprobacion(LocalDateTime.now());
        
        return repoMovimientos.save(movimiento);
    }
    
    /**
     * Actualizar movimiento
     */
    public MovimientosAlumno actualizar(MovimientosAlumno movimiento) {
        validarPermisoSede(movimiento, "actualizar");
        return repoMovimientos.save(movimiento);
    }
    
    /**
     * Eliminar movimiento (soft delete)
     */
    public void eliminar(Long id) {
        repoMovimientos.findById(id).ifPresent(m -> validarPermisoSede(m, "eliminar"));
        repoMovimientos.deleteById(id);
    }
}
