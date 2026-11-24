package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.PagosCaja;
import com.escuelita.www.repository.PagosCajaRepository;
import com.escuelita.www.service.IPagosCajaService;
import com.escuelita.www.util.TenantContext;

@Service
public class PagosCajaService implements IPagosCajaService {
    @Autowired
    private PagosCajaRepository repoPagosCaja;

    private Long extraerSedeId(PagosCaja pago) {
        if (pago != null && pago.getIdUsuario() != null && pago.getIdUsuario().getIdSede() != null) {
            return pago.getIdUsuario().getIdSede().getIdSede();
        }
        return null;
    }

    private void validarPermisoSede(PagosCaja pago, String accion) {
        if (TenantContext.isSuperAdmin()) return;
        Long userSede = TenantContext.getSedeId();
        Long recSede = extraerSedeId(pago);
        if (userSede == null || recSede == null || !userSede.equals(recSede)) {
            throw new SecurityException("No tienes permiso para " + accion + " pagos de otra sede");
        }
    }

    public List<PagosCaja> buscarTodos() {
        List<PagosCaja> todos = repoPagosCaja.findAll();
        if (TenantContext.isSuperAdmin()) return todos;
        Long sedeId = TenantContext.getSedeId();
        return todos.stream()
                .filter(p -> sedeId != null && sedeId.equals(extraerSedeId(p)))
                .collect(Collectors.toList());
    }

    @Override
    public PagosCaja guardar(PagosCaja pagosCaja) {
        validarPermisoSede(pagosCaja, "crear");
        return repoPagosCaja.save(pagosCaja);
    }

    @Override
    public PagosCaja modificar(PagosCaja pagosCaja) {
        validarPermisoSede(pagosCaja, "modificar");
        return repoPagosCaja.save(pagosCaja);
    }

    public Optional<PagosCaja> buscarId(Long id) {
        Optional<PagosCaja> opt = repoPagosCaja.findById(id);
        if (TenantContext.isSuperAdmin() || opt.isEmpty()) return opt;
        Long sedeId = TenantContext.getSedeId();
        return (sedeId != null && sedeId.equals(extraerSedeId(opt.get()))) ? opt : Optional.empty();
    }

    public void eliminar(Long id) {
        repoPagosCaja.findById(id).ifPresent(p -> validarPermisoSede(p, "eliminar"));
        repoPagosCaja.deleteById(id);
    }
}