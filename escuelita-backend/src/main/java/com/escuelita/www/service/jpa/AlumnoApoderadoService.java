package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.AlumnoApoderado;
import com.escuelita.www.repository.AlumnoApoderadoRepository;
import com.escuelita.www.service.IAlumnoApoderadoService;
import com.escuelita.www.util.TenantContext;

@Service
public class AlumnoApoderadoService implements IAlumnoApoderadoService {
    @Autowired
    private AlumnoApoderadoRepository repoAlumnoApoderado;

    private Long extraerSedeId(AlumnoApoderado rel) {
        if (rel != null && rel.getIdAlumno() != null && rel.getIdAlumno().getIdSede() != null) {
            return rel.getIdAlumno().getIdSede().getIdSede();
        }
        return null;
    }

    private void validarPermisoSede(AlumnoApoderado rel, String accion) {
        if (TenantContext.isSuperAdmin()) return;
        Long userSede = TenantContext.getSedeId();
        Long recSede = extraerSedeId(rel);
        if (userSede == null || recSede == null || !userSede.equals(recSede)) {
            throw new SecurityException("No tienes permiso para " + accion + " vínculos de alumnos de otra sede");
        }
    }

    public List<AlumnoApoderado> buscarTodos() {
        List<AlumnoApoderado> todos = repoAlumnoApoderado.findAll();
        if (TenantContext.isSuperAdmin()) return todos;
        Long sedeId = TenantContext.getSedeId();
        return todos.stream()
                .filter(a -> sedeId != null && sedeId.equals(extraerSedeId(a)))
                .collect(Collectors.toList());
    }

    @Override
    public AlumnoApoderado guardar(AlumnoApoderado alumnoApoderado) {
        validarPermisoSede(alumnoApoderado, "crear");
        return repoAlumnoApoderado.save(alumnoApoderado);
    }

    @Override
    public AlumnoApoderado modificar(AlumnoApoderado alumnoApoderado) {
        validarPermisoSede(alumnoApoderado, "modificar");
        return repoAlumnoApoderado.save(alumnoApoderado);
    }

    public Optional<AlumnoApoderado> buscarId(Long id) {
        Optional<AlumnoApoderado> opt = repoAlumnoApoderado.findById(id);
        if (TenantContext.isSuperAdmin() || opt.isEmpty()) return opt;
        Long sedeId = TenantContext.getSedeId();
        return (sedeId != null && sedeId.equals(extraerSedeId(opt.get()))) ? opt : Optional.empty();
    }

    public void eliminar(Long id) {
        repoAlumnoApoderado.findById(id).ifPresent(a -> validarPermisoSede(a, "eliminar"));
        repoAlumnoApoderado.deleteById(id);
    }
}