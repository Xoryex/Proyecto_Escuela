package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.ConceptosPago;
import com.escuelita.www.repository.ConceptosPagoRepository;
import com.escuelita.www.repository.SedesRepository;
import com.escuelita.www.service.IConceptosPagoService;
import com.escuelita.www.util.TenantContext;

@Service
public class ConceptosPagoService implements IConceptosPagoService {
    @Autowired
    private ConceptosPagoRepository repoConceptosPago;

    @Autowired
    private SedesRepository repoSedes;

    private boolean perteneceATenant(ConceptosPago concepto) {
        if (TenantContext.isSuperAdmin()) return true;
        Long userSede = TenantContext.getSedeId();
        if (userSede == null || concepto == null) return false;
        if (concepto.getIdGrado() != null && concepto.getIdGrado().getIdSede() != null) {
            return userSede.equals(concepto.getIdGrado().getIdSede().getIdSede());
        }
        if (concepto.getIdInstitucion() != null) {
            return repoSedes.findById(userSede)
                    .map(s -> s.getIdInstitucion() != null
                            && s.getIdInstitucion().getIdInstitucion().equals(concepto.getIdInstitucion().getIdInstitucion()))
                    .orElse(false);
        }
        return false;
    }

    public List<ConceptosPago> buscarTodos() {
        List<ConceptosPago> todos = repoConceptosPago.findAll();
        if (TenantContext.isSuperAdmin()) return todos;
        return todos.stream().filter(this::perteneceATenant).collect(Collectors.toList());
    }

    @Override
    public ConceptosPago guardar(ConceptosPago conceptospago) {
        if (!perteneceATenant(conceptospago)) {
            throw new SecurityException("No tienes permiso para crear conceptos de pago en otra sede/institución");
        }
        return repoConceptosPago.save(conceptospago);
    }

    @Override
    public ConceptosPago modificar(ConceptosPago conceptospago) {
        if (!perteneceATenant(conceptospago)) {
            throw new SecurityException("No tienes permiso para modificar conceptos de pago de otra sede/institución");
        }
        return repoConceptosPago.save(conceptospago);
    }

    public Optional<ConceptosPago> buscarId(Long id) {
        Optional<ConceptosPago> opt = repoConceptosPago.findById(id);
        if (TenantContext.isSuperAdmin() || opt.isEmpty()) return opt;
        return perteneceATenant(opt.get()) ? opt : Optional.empty();
    }

    public void eliminar(Long id) {
        repoConceptosPago.findById(id).ifPresent(c -> {
            if (!perteneceATenant(c)) {
                throw new SecurityException("No tienes permiso para eliminar conceptos de pago de otra sede/institución");
            }
        });
        repoConceptosPago.deleteById(id);
    }
}
