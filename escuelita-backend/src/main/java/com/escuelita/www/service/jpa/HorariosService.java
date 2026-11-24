package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.Horarios;
import com.escuelita.www.repository.HorariosRepository;
import com.escuelita.www.service.IHorariosService;
import com.escuelita.www.util.TenantContext;

@Service
public class HorariosService implements IHorariosService {
    @Autowired
    private HorariosRepository repoHorarios;
    
    public List<Horarios> buscarTodos() {
        if (TenantContext.isSuperAdmin()) {
            return repoHorarios.findAll();
        }
        return repoHorarios.findBySedeId(TenantContext.getSedeId());
    }
    
    private void validarCrucesHorario(Horarios candidato) {
        if (candidato.getDiaSemana() == null || candidato.getHoraInicio() == null || candidato.getHoraFin() == null) {
            throw new IllegalArgumentException("El día de la semana, hora de inicio y hora de fin son obligatorios");
        }
        if (!candidato.getHoraInicio().isBefore(candidato.getHoraFin())) {
            throw new IllegalArgumentException("La hora de inicio debe ser menor a la hora de fin");
        }

        Long sedeId = candidato.getIdAula() != null && candidato.getIdAula().getIdSede() != null
                ? candidato.getIdAula().getIdSede().getIdSede()
                : TenantContext.getSedeId();
        List<Horarios> existentes = sedeId != null ? repoHorarios.findBySedeId(sedeId) : repoHorarios.findAll();

        Long candId = candidato.getIdHorario();
        Long candAula = candidato.getIdAula() != null ? candidato.getIdAula().getIdAula() : null;
        Long candDocente = candidato.getIdAsignacion() != null && candidato.getIdAsignacion().getIdDocente() != null
                ? candidato.getIdAsignacion().getIdDocente().getIdDocente() : null;
        Long candSeccion = candidato.getIdAsignacion() != null && candidato.getIdAsignacion().getIdSeccion() != null
                ? candidato.getIdAsignacion().getIdSeccion().getIdSeccion() : null;

        for (Horarios h : existentes) {
            if (candId != null && candId.equals(h.getIdHorario())) {
                continue;
            }
            if (h.getDiaSemana() == null || !h.getDiaSemana().equalsIgnoreCase(candidato.getDiaSemana())) {
                continue;
            }
            if (h.getHoraInicio() == null || h.getHoraFin() == null) {
                continue;
            }
            boolean solapa = candidato.getHoraInicio().isBefore(h.getHoraFin())
                    && candidato.getHoraFin().isAfter(h.getHoraInicio());
            if (!solapa) {
                continue;
            }

            if (candAula != null && h.getIdAula() != null && candAula.equals(h.getIdAula().getIdAula())) {
                throw new IllegalArgumentException("Cruce de horario: el aula ya está ocupada en ese día y franja horaria");
            }
            Long hDocente = h.getIdAsignacion() != null && h.getIdAsignacion().getIdDocente() != null
                    ? h.getIdAsignacion().getIdDocente().getIdDocente() : null;
            if (candDocente != null && candDocente.equals(hDocente)) {
                throw new IllegalArgumentException("Cruce de horario: el docente ya tiene una clase programada en esa franja");
            }
            Long hSeccion = h.getIdAsignacion() != null && h.getIdAsignacion().getIdSeccion() != null
                    ? h.getIdAsignacion().getIdSeccion().getIdSeccion() : null;
            if (candSeccion != null && candSeccion.equals(hSeccion)) {
                throw new IllegalArgumentException("Cruce de horario: la sección ya tiene un curso asignado en esa franja");
            }
        }
    }

    @Override
    public Horarios guardar(Horarios horarios) {
        if (!TenantContext.isSuperAdmin()) {
            Long sedeId = horarios.getIdAula() != null && 
                         horarios.getIdAula().getIdSede() != null
                         ? horarios.getIdAula().getIdSede().getIdSede() 
                         : null;
            
            if (sedeId == null || !sedeId.equals(TenantContext.getSedeId())) {
                throw new SecurityException("No tienes permiso para crear horarios en esta sede");
            }
        }
        validarCrucesHorario(horarios);
        return repoHorarios.save(horarios);
    }
    
    @Override
    public Horarios modificar(Horarios horarios) {
        if (!TenantContext.isSuperAdmin()) {
            Long sedeId = horarios.getIdAula() != null && 
                         horarios.getIdAula().getIdSede() != null
                         ? horarios.getIdAula().getIdSede().getIdSede() 
                         : null;
            
            if (sedeId == null || !sedeId.equals(TenantContext.getSedeId())) {
                throw new SecurityException("No tienes permiso para modificar horarios de esta sede");
            }
        }
        validarCrucesHorario(horarios);
        return repoHorarios.save(horarios);
    }
    
    public Optional<Horarios> buscarId(Long id) {
        Optional<Horarios> horario = repoHorarios.findById(id);
        
        if (TenantContext.isSuperAdmin()) {
            return horario;
        }
        
        if (horario.isPresent()) {
            Long sedeId = horario.get().getIdAula() != null && 
                         horario.get().getIdAula().getIdSede() != null
                         ? horario.get().getIdAula().getIdSede().getIdSede() 
                         : null;
            
            if (sedeId != null && sedeId.equals(TenantContext.getSedeId())) {
                return horario;
            }
        }
        return Optional.empty();
    }
    
    public void eliminar(Long id) {
        Optional<Horarios> horario = repoHorarios.findById(id);
        if (horario.isPresent() && !TenantContext.isSuperAdmin()) {
            Long sedeId = horario.get().getIdAula() != null && 
                         horario.get().getIdAula().getIdSede() != null
                         ? horario.get().getIdAula().getIdSede().getIdSede() 
                         : null;
            
            if (sedeId == null || !sedeId.equals(TenantContext.getSedeId())) {
                throw new RuntimeException("No tienes permiso para eliminar horarios de esta sede");
            }
        }
        repoHorarios.deleteById(id);
    }
}