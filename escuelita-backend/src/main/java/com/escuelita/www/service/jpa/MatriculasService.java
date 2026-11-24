package com.escuelita.www.service.jpa;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.escuelita.www.entity.Matriculas;
import com.escuelita.www.repository.MatriculasRepository;
import com.escuelita.www.service.IMatriculasService;
import com.escuelita.www.util.TenantContext;

import jakarta.persistence.EntityManager;

@Service
public class MatriculasService implements IMatriculasService{
    @Autowired
    private MatriculasRepository repoMatriculas;
    
    @Autowired
    private EntityManager entityManager;
    
    public List<Matriculas> buscarTodos(){
        // Super Admin ve todas las matrículas
        if (TenantContext.isSuperAdmin()) {
            return repoMatriculas.findAll();
        }
        // Usuario de sede solo ve matrículas de su sede
        return repoMatriculas.findBySedeId(TenantContext.getSedeId());
    }
    
    @Override
    public Matriculas guardar(Matriculas matriculas){
        // Validar que la sección pertenece a la sede del usuario
        if (!TenantContext.isSuperAdmin()) {
            Long sedeId = matriculas.getIdSeccion() != null && 
                         matriculas.getIdSeccion().getIdSede() != null
                         ? matriculas.getIdSeccion().getIdSede().getIdSede() 
                         : null;
            
            if (sedeId == null || !sedeId.equals(TenantContext.getSedeId())) {
                throw new RuntimeException("No tienes permiso para crear matrículas en esta sede");
            }
        }
        
        // Validar que no exista matrícula duplicada para el mismo alumno y año escolar
        if (matriculas.getIdAlumno() != null && matriculas.getIdAnio() != null) {
            Long duplicadas = ((Number) entityManager.createNativeQuery(
                "SELECT COUNT(*) FROM matriculas WHERE id_alumno = :idAlumno AND id_anio = :idAnio AND estado = 1 AND estado_matricula <> 'Cancelada'")
                .setParameter("idAlumno", matriculas.getIdAlumno().getIdAlumno())
                .setParameter("idAnio", matriculas.getIdAnio().getIdAnioEscolar())
                .getSingleResult()).longValue();
            if (duplicadas > 0) {
                throw new IllegalArgumentException("El alumno ya cuenta con una matrícula activa en este año escolar.");
            }
        }

        // Validar capacidad ANTES de crear la matrícula (solo para alumnos sin vacante garantizada)
        if (!Boolean.TRUE.equals(matriculas.getVacanteGarantizada())) {
            Long idSeccion = matriculas.getIdSeccion() != null ? matriculas.getIdSeccion().getIdSeccion() : null;
            Long idAnio = matriculas.getIdAnio() != null ? matriculas.getIdAnio().getIdAnioEscolar() : null;
            
            if (idSeccion != null && idAnio != null) {
                int vacantesDisponibles = consultarVacantesDisponibles(idSeccion, idAnio);
                
                if (vacantesDisponibles <= 0) {
                    throw new IllegalArgumentException("No hay vacantes disponibles en esta sección. No se puede crear la matrícula.");
                }
            }
        }
        
        return repoMatriculas.save(matriculas);
    }
    
    @Override
    public Matriculas modificar(Matriculas matriculas){
        // Validar que la sección pertenece a la sede del usuario
        if (!TenantContext.isSuperAdmin()) {
            Long sedeId = matriculas.getIdSeccion() != null && 
                         matriculas.getIdSeccion().getIdSede() != null
                         ? matriculas.getIdSeccion().getIdSede().getIdSede() 
                         : null;
            
            if (sedeId == null || !sedeId.equals(TenantContext.getSedeId())) {
                throw new RuntimeException("No tienes permiso para modificar matrículas de esta sede");
            }
        }
        
        // Validar capacidad si se está cambiando de sección (solo para alumnos sin vacante garantizada)
        Optional<Matriculas> matriculaAnterior = repoMatriculas.findById(matriculas.getIdMatricula());
        if (matriculaAnterior.isPresent() && 
            matriculas.getVacanteGarantizada() != null && 
            !matriculas.getVacanteGarantizada()) {
            
            Long nuevaSeccion = matriculas.getIdSeccion() != null ? matriculas.getIdSeccion().getIdSeccion() : null;
            Long seccionAnterior = matriculaAnterior.get().getIdSeccion() != null ? 
                                   matriculaAnterior.get().getIdSeccion().getIdSeccion() : null;
            
            // Si cambió de sección, validar vacantes en la nueva
            if (nuevaSeccion != null && !nuevaSeccion.equals(seccionAnterior)) {
                Long idAnio = matriculas.getIdAnio() != null ? matriculas.getIdAnio().getIdAnioEscolar() : null;
                
                if (idAnio != null) {
                    int vacantesDisponibles = consultarVacantesDisponibles(nuevaSeccion, idAnio);
                    
                    if (vacantesDisponibles <= 0) {
                        throw new RuntimeException("No hay vacantes disponibles en la nueva sección.");
                    }
                }
            }
        }
        
        return repoMatriculas.save(matriculas);
    }
    
    public Optional<Matriculas> buscarId(Long id){
        Optional<Matriculas> matricula = repoMatriculas.findById(id);
        
        // Super Admin puede ver cualquier matrícula
        if (TenantContext.isSuperAdmin()) {
            return matricula;
        }
        
        // Usuario de sede solo puede ver matrículas de su sede
        if (matricula.isPresent()) {
            Long sedeId = matricula.get().getIdSeccion() != null && 
                         matricula.get().getIdSeccion().getIdSede() != null
                         ? matricula.get().getIdSeccion().getIdSede().getIdSede() 
                         : null;
            
            if (sedeId != null && sedeId.equals(TenantContext.getSedeId())) {
                return matricula;
            }
        }
        return Optional.empty();
    }
    
    public void eliminar(Long id){
        Optional<Matriculas> matricula = repoMatriculas.findById(id);
        if (matricula.isPresent() && !TenantContext.isSuperAdmin()) {
            Long sedeId = matricula.get().getIdSeccion() != null && 
                         matricula.get().getIdSeccion().getIdSede() != null
                         ? matricula.get().getIdSeccion().getIdSede().getIdSede() 
                         : null;
            
            if (sedeId == null || !sedeId.equals(TenantContext.getSedeId())) {
                throw new RuntimeException("No tienes permiso para eliminar matrículas de esta sede");
            }
        }
        repoMatriculas.deleteById(id);
    }
    
    @Override
    @Transactional
    public String confirmarPagoMatricula(Long idMatricula) {
        Matriculas matricula = repoMatriculas.findById(idMatricula)
            .orElseThrow(() -> new IllegalArgumentException("Matrícula no encontrada"));

        if (!TenantContext.isSuperAdmin()) {
            Long sedeId = matricula.getIdSeccion() != null && matricula.getIdSeccion().getIdSede() != null
                ? matricula.getIdSeccion().getIdSede().getIdSede()
                : null;
            if (sedeId == null || !sedeId.equals(TenantContext.getSedeId())) {
                throw new SecurityException("No tienes permiso para confirmar matrículas de otra sede");
            }
        }

        if ("Activa".equalsIgnoreCase(matricula.getEstadoMatricula())) {
            return "La matrícula ya se encuentra activa y pagada";
        }

        if (!Boolean.TRUE.equals(matricula.getVacanteGarantizada())
                && matricula.getIdSeccion() != null && matricula.getIdAnio() != null) {
            int vacantesDisponibles = consultarVacantesDisponibles(
                matricula.getIdSeccion().getIdSeccion(),
                matricula.getIdAnio().getIdAnioEscolar()
            );
            if (vacantesDisponibles <= 0) {
                throw new IllegalArgumentException("No hay vacantes disponibles en la sección para confirmar esta matrícula");
            }
        }

        matricula.setEstadoMatricula("Activa");
        matricula.setFechaPagoMatricula(LocalDateTime.now());
        matricula.setVacanteGarantizada(true);
        repoMatriculas.save(matricula);
        return "Pago de matrícula confirmado exitosamente";
    }
    
    @Override
    public int consultarVacantesDisponibles(Long idSeccion, Long idAnio) {
        try {
            // Obtener vacantes (capacidad) de la sección usando la columna real 'vacantes'
            List<?> res = entityManager.createNativeQuery(
                "SELECT vacantes FROM secciones WHERE id_seccion = :idSeccion AND estado = 1")
                .setParameter("idSeccion", idSeccion)
                .getResultList();

            if (res.isEmpty() || res.get(0) == null) {
                throw new IllegalArgumentException("Sección no encontrada o sin cupo configurado");
            }
            int capacidadMaxima = ((Number) res.get(0)).intValue();
            
            // Contar matrículas activas en esa sección para ese año escolar
            Long matriculasActivas = ((Number) entityManager.createNativeQuery(
                "SELECT COUNT(*) FROM matriculas WHERE id_seccion = :idSeccion " +
                "AND id_anio = :idAnio " +
                "AND estado_matricula = 'Activa' " +
                "AND estado = 1")
                .setParameter("idSeccion", idSeccion)
                .setParameter("idAnio", idAnio)
                .getSingleResult()).longValue();
            
            int vacantesDisponibles = capacidadMaxima - matriculasActivas.intValue();
            return Math.max(0, vacantesDisponibles);
            
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Error al consultar vacantes: " + e.getMessage());
        }
    }
}