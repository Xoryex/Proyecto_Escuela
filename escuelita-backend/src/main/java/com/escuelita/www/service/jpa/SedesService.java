package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.Sedes;
import com.escuelita.www.repository.SedesRepository;
import com.escuelita.www.service.ISedesService;
import com.escuelita.www.util.SedeAccessHelper;
import com.escuelita.www.util.TenantContext;

@Service
public class SedesService implements ISedesService {
    @Autowired 
    private SedesRepository repoSedes;
    
    public List<Sedes> buscarTodos(){
        Long sedeId = TenantContext.getSedeId();
        if (sedeId == null || TenantContext.isSuperAdmin()) {
            return repoSedes.findAll();
        }
        return repoSedes.findById(sedeId).map(List::of).orElse(List.of());
    }
    @Override
    public Sedes guardar(Sedes sedes){
        SedeAccessHelper.validateSedeAccess(
            () -> sedes.getIdSede()
        );
        sedes.setNombreSede(sedes.getNombreSede().toUpperCase().trim());
        if (sedes.getIdInstitucion() != null) {
            Long instId = sedes.getIdInstitucion().getIdInstitucion();
            repoSedes.findByNombreSedeAndIdInstitucionIdInstitucion(sedes.getNombreSede(), instId)
                .ifPresent(s -> { throw new IllegalArgumentException("Ya existe la sede '" + sedes.getNombreSede() + "' en esta institución"); });
        }
        return repoSedes.save(sedes);
    }
    @Override
    public Sedes modificar(Sedes sedes){
        SedeAccessHelper.validateSedeAccess(
            () -> sedes.getIdSede()
        );
        sedes.setNombreSede(sedes.getNombreSede().toUpperCase().trim());
        if (sedes.getIdInstitucion() != null && sedes.getIdSede() != null) {
            Long instId = sedes.getIdInstitucion().getIdInstitucion();
            repoSedes.findByNombreSedeAndIdInstitucionIdInstitucion(sedes.getNombreSede(), instId)
                .filter(s -> !s.getIdSede().equals(sedes.getIdSede()))
                .ifPresent(s -> { throw new IllegalArgumentException("Ya existe la sede '" + sedes.getNombreSede() + "' en esta institución"); });
        }
        return repoSedes.save(sedes);
    }
    public Optional<Sedes> buscarId(Long id){
        Optional<Sedes> sede = repoSedes.findById(id);
        return SedeAccessHelper.filterBySede(
            sede,
            () -> sede.isPresent() && sede.get().getIdSede() != null 
                ? sede.get().getIdSede() 
                : null
        );
    }
    public void eliminar(Long id){
        Optional<Sedes> sede = repoSedes.findById(id);
        if (sede.isPresent()) {
            SedeAccessHelper.validateSedeAccess(
                () -> sede.get().getIdSede() != null ? sede.get().getIdSede() : null
            );
        }
        repoSedes.deleteById(id);
    }
}