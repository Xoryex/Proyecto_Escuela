package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.PagoDetalle;
import com.escuelita.www.repository.PagoDetalleRepository;
import com.escuelita.www.service.IPagoDetalleService;
import com.escuelita.www.util.TenantContext;

@Service
public class PagoDetalleService implements IPagoDetalleService {
    @Autowired
    private PagoDetalleRepository repoPagoDetalle;

    private Long extraerSedeId(PagoDetalle det) {
        if (det == null) return null;
        if (det.getIdDeuda() != null && det.getIdDeuda().getIdMatricula() != null
                && det.getIdDeuda().getIdMatricula().getIdSeccion() != null
                && det.getIdDeuda().getIdMatricula().getIdSeccion().getIdSede() != null) {
            return det.getIdDeuda().getIdMatricula().getIdSeccion().getIdSede().getIdSede();
        }
        if (det.getIdPago() != null && det.getIdPago().getIdUsuario() != null
                && det.getIdPago().getIdUsuario().getIdSede() != null) {
            return det.getIdPago().getIdUsuario().getIdSede().getIdSede();
        }
        return null;
    }

    private void validarPermisoSede(PagoDetalle det, String accion) {
        if (TenantContext.isSuperAdmin()) return;
        Long userSede = TenantContext.getSedeId();
        Long recSede = extraerSedeId(det);
        if (userSede == null || recSede == null || !userSede.equals(recSede)) {
            throw new SecurityException("No tienes permiso para " + accion + " detalles de pago de otra sede");
        }
    }

    public List<PagoDetalle> buscarTodos() {
        List<PagoDetalle> todos = repoPagoDetalle.findAll();
        if (TenantContext.isSuperAdmin()) return todos;
        Long sedeId = TenantContext.getSedeId();
        return todos.stream()
                .filter(d -> sedeId != null && sedeId.equals(extraerSedeId(d)))
                .collect(Collectors.toList());
    }

    @Override
    public PagoDetalle guardar(PagoDetalle pagoDetalle) {
        validarPermisoSede(pagoDetalle, "crear");
        return repoPagoDetalle.save(pagoDetalle);
    }

    @Override
    public PagoDetalle modificar(PagoDetalle pagoDetalle) {
        validarPermisoSede(pagoDetalle, "modificar");
        return repoPagoDetalle.save(pagoDetalle);
    }

    public Optional<PagoDetalle> buscarId(Long id) {
        Optional<PagoDetalle> opt = repoPagoDetalle.findById(id);
        if (TenantContext.isSuperAdmin() || opt.isEmpty()) return opt;
        Long sedeId = TenantContext.getSedeId();
        return (sedeId != null && sedeId.equals(extraerSedeId(opt.get()))) ? opt : Optional.empty();
    }

    public void eliminar(Long id) {
        repoPagoDetalle.findById(id).ifPresent(d -> validarPermisoSede(d, "eliminar"));
        repoPagoDetalle.deleteById(id);
    }
}