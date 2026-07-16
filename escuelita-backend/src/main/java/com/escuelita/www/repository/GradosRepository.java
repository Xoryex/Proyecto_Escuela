package com.escuelita.www.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.escuelita.www.entity.Grados;

public interface GradosRepository extends JpaRepository<Grados, Long> {
    
    List<Grados> findByIdSedeIdSede(Long idSede);

    Optional<Grados> findByNombreGradoAndIdSedeIdSede(String nombreGrado, Long idSede);
}