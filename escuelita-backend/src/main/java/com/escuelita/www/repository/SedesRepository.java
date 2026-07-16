package com.escuelita.www.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.escuelita.www.entity.Institucion;
import com.escuelita.www.entity.Sedes;

public interface SedesRepository extends JpaRepository<Sedes, Long> {
    
    List<Sedes> findByIdInstitucion(Institucion institucion);
    
    @Query("SELECT s FROM Sedes s WHERE s.idInstitucion.idInstitucion = :idInstitucion AND s.estado = 1")
    List<Sedes> findSedesActivasByInstitucionId(@Param("idInstitucion") Long idInstitucion);
    
    @Query("SELECT COUNT(s) FROM Sedes s WHERE s.idInstitucion.idInstitucion = :idInstitucion AND s.estado = 1")
    Long countSedesActivasByInstitucionId(@Param("idInstitucion") Long idInstitucion);

    Optional<Sedes> findByNombreSedeAndIdInstitucionIdInstitucion(String nombreSede, Long idInstitucion);
}