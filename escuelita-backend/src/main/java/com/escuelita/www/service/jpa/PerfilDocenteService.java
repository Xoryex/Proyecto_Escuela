package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.PerfilDocente;
import com.escuelita.www.repository.PerfilDocenteRepository;
import com.escuelita.www.service.IPerfilDocenteService;
import com.escuelita.www.util.TenantContext;

@Service
public class PerfilDocenteService implements IPerfilDocenteService {
    @Autowired
    private PerfilDocenteRepository repoPerfilDocente;

    private Long extraerSedeId(PerfilDocente perfil) {
        if (perfil != null && perfil.getIdUsuario() != null && perfil.getIdUsuario().getIdSede() != null) {
            return perfil.getIdUsuario().getIdSede().getIdSede();
        }
        return null;
    }

    private void validarPermisoSede(PerfilDocente perfil, String accion) {
        if (TenantContext.isSuperAdmin()) return;
        Long userSede = TenantContext.getSedeId();
        Long recSede = extraerSedeId(perfil);
        if (userSede == null || recSede == null || !userSede.equals(recSede)) {
            throw new SecurityException("No tienes permiso para " + accion + " perfiles docentes de otra sede");
        }
    }

    public List<PerfilDocente> buscarTodos() {
        List<PerfilDocente> todos = repoPerfilDocente.findAll();
        if (TenantContext.isSuperAdmin()) return todos;
        Long sedeId = TenantContext.getSedeId();
        return todos.stream()
                .filter(p -> sedeId != null && sedeId.equals(extraerSedeId(p)))
                .collect(Collectors.toList());
    }

    @Override
    public PerfilDocente guardar(PerfilDocente perfilDocente) {
        validarPermisoSede(perfilDocente, "crear");
        return repoPerfilDocente.save(perfilDocente);
    }

    @Override
    public PerfilDocente modificar(PerfilDocente perfilDocente) {
        validarPermisoSede(perfilDocente, "modificar");
        return repoPerfilDocente.save(perfilDocente);
    }

    public Optional<PerfilDocente> buscarId(Long id) {
        Optional<PerfilDocente> opt = repoPerfilDocente.findById(id);
        if (TenantContext.isSuperAdmin() || opt.isEmpty()) return opt;
        Long sedeId = TenantContext.getSedeId();
        return (sedeId != null && sedeId.equals(extraerSedeId(opt.get()))) ? opt : Optional.empty();
    }

    public void eliminar(Long id) {
        repoPerfilDocente.findById(id).ifPresent(p -> validarPermisoSede(p, "eliminar"));
        repoPerfilDocente.deleteById(id);
    }
}