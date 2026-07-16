package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.Grados;
import com.escuelita.www.repository.GradosRepository;
import com.escuelita.www.service.IGradosService;
import com.escuelita.www.util.SedeAccessHelper;
import com.escuelita.www.util.TenantContext;

@Service
public class GradosService implements IGradosService{
    @Autowired
    private GradosRepository repoGrados;
    
    public List<Grados> buscarTodos(){
        return SedeAccessHelper.findAllWithSedeFilter(
            repoGrados, 
            () -> repoGrados.findByIdSedeIdSede(TenantContext.getSedeId())
        );
    }
    
    @Override
    public Grados guardar(Grados grados){
        SedeAccessHelper.validateSedeAccess(
            () -> grados.getIdSede() != null ? grados.getIdSede().getIdSede() : null
        );
        grados.setNombreGrado(grados.getNombreGrado().toUpperCase().trim());
        Long sedeId = grados.getIdSede() != null ? grados.getIdSede().getIdSede() : null;
        if (sedeId != null) {
            repoGrados.findByNombreGradoAndIdSedeIdSede(grados.getNombreGrado(), sedeId)
                .ifPresent(g -> { throw new IllegalArgumentException("Ya existe el grado '" + grados.getNombreGrado() + "' en esta sede"); });
        }
        return repoGrados.save(grados);
    }
    
    @Override
    public Grados modificar(Grados grados){
        SedeAccessHelper.validateSedeAccess(
            () -> grados.getIdSede() != null ? grados.getIdSede().getIdSede() : null
        );
        grados.setNombreGrado(grados.getNombreGrado().toUpperCase().trim());
        Long sedeId = grados.getIdSede() != null ? grados.getIdSede().getIdSede() : null;
        if (sedeId != null && grados.getIdGrado() != null) {
            repoGrados.findByNombreGradoAndIdSedeIdSede(grados.getNombreGrado(), sedeId)
                .filter(g -> !g.getIdGrado().equals(grados.getIdGrado()))
                .ifPresent(g -> { throw new IllegalArgumentException("Ya existe el grado '" + grados.getNombreGrado() + "' en esta sede"); });
        }
        return repoGrados.save(grados);
    }
    
    public Optional<Grados> buscarId(Long id){
        Optional<Grados> grado = repoGrados.findById(id);
        return SedeAccessHelper.filterBySede(
            grado,
            () -> grado.isPresent() && grado.get().getIdSede() != null 
                ? grado.get().getIdSede().getIdSede() 
                : null
        );
    }
    
    public void eliminar(Long id){
        Optional<Grados> grado = repoGrados.findById(id);
        if (grado.isPresent()) {
            SedeAccessHelper.validateSedeAccess(
                () -> grado.get().getIdSede() != null ? grado.get().getIdSede().getIdSede() : null
            );
        }
        repoGrados.deleteById(id);
    }
}