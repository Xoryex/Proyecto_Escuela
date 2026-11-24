package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.DeudasAlumno;
import com.escuelita.www.repository.DeudasAlumnoRepository;
import com.escuelita.www.service.IDeudasAlumnoService;
import com.escuelita.www.util.TenantContext;

@Service
public class DeudasAlumnoService implements IDeudasAlumnoService {
    @Autowired
    private DeudasAlumnoRepository repoDeudasAlumno;

    private Long extraerSedeId(DeudasAlumno deuda) {
        if (deuda != null && deuda.getIdMatricula() != null
                && deuda.getIdMatricula().getIdSeccion() != null
                && deuda.getIdMatricula().getIdSeccion().getIdSede() != null) {
            return deuda.getIdMatricula().getIdSeccion().getIdSede().getIdSede();
        }
        return null;
    }

    private void validarPermisoSede(DeudasAlumno deuda, String accion) {
        if (TenantContext.isSuperAdmin()) return;
        Long userSede = TenantContext.getSedeId();
        Long recSede = extraerSedeId(deuda);
        if (userSede == null || recSede == null || !userSede.equals(recSede)) {
            throw new SecurityException("No tienes permiso para " + accion + " deudas de otra sede");
        }
    }

    public List<DeudasAlumno> buscarTodos() {
        List<DeudasAlumno> todas = repoDeudasAlumno.findAll();
        if (TenantContext.isSuperAdmin()) return todas;
        Long sedeId = TenantContext.getSedeId();
        return todas.stream()
                .filter(d -> sedeId != null && sedeId.equals(extraerSedeId(d)))
                .collect(Collectors.toList());
    }

    @Override
    public DeudasAlumno guardar(DeudasAlumno deuda) {
        validarPermisoSede(deuda, "crear");
        return repoDeudasAlumno.save(deuda);
    }

    @Override
    public DeudasAlumno modificar(DeudasAlumno deuda) {
        validarPermisoSede(deuda, "modificar");
        return repoDeudasAlumno.save(deuda);
    }

    public Optional<DeudasAlumno> buscarId(Long id) {
        Optional<DeudasAlumno> opt = repoDeudasAlumno.findById(id);
        if (TenantContext.isSuperAdmin() || opt.isEmpty()) return opt;
        Long sedeId = TenantContext.getSedeId();
        return (sedeId != null && sedeId.equals(extraerSedeId(opt.get()))) ? opt : Optional.empty();
    }

    public void eliminar(Long id) {
        repoDeudasAlumno.findById(id).ifPresent(d -> validarPermisoSede(d, "eliminar"));
        repoDeudasAlumno.deleteById(id);
    }
}