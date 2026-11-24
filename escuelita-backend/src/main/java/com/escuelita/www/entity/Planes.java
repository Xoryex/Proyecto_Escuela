//CORRECTO

package com.escuelita.www.entity;

import java.math.BigDecimal;

import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import jakarta.persistence.*;

@Entity
@Table(name = "planes")
@SQLDelete(sql = "UPDATE planes SET estado=0 WHERE id_plan=?")
@SQLRestriction("estado = 1")
@JsonPropertyOrder({
    "idPlan", "nombrePlan", "descripcion", "precioMensual", "precioAnual", "limiteAlumnos", "limiteSedes", "estado"
})
public class Planes {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_plan")
    private Long idPlan;

    @Column(name = "nombre_plan")
    private String nombrePlan;
    private String descripcion;
    @Column(name = "precio_mensual", precision = 10, scale = 2)
    private BigDecimal precioMensual;
    @Column(name = "precio_anual", precision = 10, scale = 2)
    private BigDecimal precioAnual;
    @Column(name = "limite_alumnos")
    private Integer limiteAlumnos;
    @Column(name = "limite_sedes")
    private Integer limiteSedes;

    private Integer estado = 1;

    //Constructor vacio
    public Planes() {
    }
    public Planes(Long id) {
        this.idPlan = id;
    }

    //Getters y Setters / ToString
    public Long getIdPlan() {
        return idPlan;
    }
    public void setIdPlan(Long idPlan) {
        this.idPlan = idPlan;
    }
    public String getNombrePlan() {
        return nombrePlan;
    }
    public void setNombrePlan(String nombrePlan) {
        this.nombrePlan = nombrePlan;
    }
    public String getDescripcion() {
        return descripcion;
    }
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    public BigDecimal getPrecioMensual() {
        return precioMensual;
    }
    public void setPrecioMensual(BigDecimal precioMensual) {
        this.precioMensual = precioMensual;
    }
    public BigDecimal getPrecioAnual() {
        return precioAnual;
    }
    public void setPrecioAnual(BigDecimal precioAnual) {
        this.precioAnual = precioAnual;
    }
    public Integer getLimiteAlumnos() {
        return limiteAlumnos;
    }
    public void setLimiteAlumnos(Integer limiteAlumnos) {
        this.limiteAlumnos = limiteAlumnos;
    }
    public Integer getLimiteSedes() {
        return limiteSedes;
    }
    public void setLimiteSedes(Integer limiteSedes) {
        this.limiteSedes = limiteSedes;
    }
    public Integer getEstado() {
        return estado;
    }
    public void setEstado(Integer estado) {
        this.estado = estado;
    }
    @Override
    public String toString() {
        return "Planes [idPlan=" + idPlan + ", nombrePlan=" + nombrePlan + ", descripcion=" + descripcion
                + ", precioMensual=" + precioMensual + ", precioAnual=" + precioAnual + ", limiteAlumnos="
                + limiteAlumnos + ", limiteSedes=" + limiteSedes + ", estado=" + estado + "]";
    }
}