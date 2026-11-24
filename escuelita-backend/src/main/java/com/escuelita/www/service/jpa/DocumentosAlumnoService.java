package com.escuelita.www.service.jpa;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuelita.www.entity.DocumentosAlumno;
import com.escuelita.www.repository.DocumentosAlumnoRepository;
import com.escuelita.www.service.IDocumentosAlumnoService;
import com.escuelita.www.util.TenantContext;

@Service
public class DocumentosAlumnoService implements IDocumentosAlumnoService {
    @Autowired
    private DocumentosAlumnoRepository repoDocumentosAlumno;

    private Long extraerSedeId(DocumentosAlumno doc) {
        if (doc != null && doc.getIdAlumno() != null && doc.getIdAlumno().getIdSede() != null) {
            return doc.getIdAlumno().getIdSede().getIdSede();
        }
        return null;
    }

    private void validarPermisoSede(DocumentosAlumno doc, String accion) {
        if (TenantContext.isSuperAdmin()) return;
        Long userSede = TenantContext.getSedeId();
        Long recSede = extraerSedeId(doc);
        if (userSede == null || recSede == null || !userSede.equals(recSede)) {
            throw new SecurityException("No tienes permiso para " + accion + " documentos de alumnos de otra sede");
        }
    }

    public List<DocumentosAlumno> buscarTodos() {
        List<DocumentosAlumno> todos = repoDocumentosAlumno.findAll();
        if (TenantContext.isSuperAdmin()) return todos;
        Long sedeId = TenantContext.getSedeId();
        return todos.stream()
                .filter(d -> sedeId != null && sedeId.equals(extraerSedeId(d)))
                .collect(Collectors.toList());
    }

    @Override
    public DocumentosAlumno guardar(DocumentosAlumno documentosAlumno) {
        validarPermisoSede(documentosAlumno, "crear");
        return repoDocumentosAlumno.save(documentosAlumno);
    }

    @Override
    public DocumentosAlumno modificar(DocumentosAlumno documentosAlumno) {
        validarPermisoSede(documentosAlumno, "modificar");
        return repoDocumentosAlumno.save(documentosAlumno);
    }

    public Optional<DocumentosAlumno> buscarId(Long id) {
        Optional<DocumentosAlumno> opt = repoDocumentosAlumno.findById(id);
        if (TenantContext.isSuperAdmin() || opt.isEmpty()) return opt;
        Long sedeId = TenantContext.getSedeId();
        return (sedeId != null && sedeId.equals(extraerSedeId(opt.get()))) ? opt : Optional.empty();
    }

    public void eliminar(Long id) {
        repoDocumentosAlumno.findById(id).ifPresent(d -> validarPermisoSede(d, "eliminar"));
        repoDocumentosAlumno.deleteById(id);
    }
}