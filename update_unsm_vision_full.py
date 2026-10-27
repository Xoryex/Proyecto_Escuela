# -*- coding: utf-8 -*-
"""
Script maestro para generar el Documento de Visión y Glosario UNSM completo,
incluyendo después del glosario:
1. Casos de Uso del Sistema (Modelado general y por módulos con diagramas UML).
2. Especificaciones detalladas de los Casos de Uso (fichas completas de CU-E01 al CU-E07 y casos clave).
3. Validaciones del sistema y reglas de negocio (matriz de validación y casos de prueba).
"""

import os
import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import parse_xml, OxmlElement
from docx.oxml.ns import nsdecls, qn

DOCS_DIR = r"c:\xampp\htdocs\Proyecto_Escuela\Mis_documentos"

def generate_complete_document():
    doc = docx.Document()

    # --- Configuración de Página y Márgenes ---
    for section in doc.sections:
        section.top_margin = Inches(1.0)
        section.bottom_margin = Inches(1.0)
        section.left_margin = Inches(1.0)
        section.right_margin = Inches(1.0)
        section.different_first_page_header_footer = False

        # Encabezado idéntico a Formato_Documento_de_Vision_UNSM.pdf
        header = section.header
        hp1 = header.paragraphs[0]
        hp1.text = ""
        r_h1 = hp1.add_run("UNIVERSIDAD NACIONAL DE SAN MARTÍN  |  INGENIERÍA DE REQUERIMIENTOS\n")
        r_h1.font.name = "Calibri"
        r_h1.font.size = Pt(8.5)
        r_h1.font.bold = True
        r_h1.font.color.rgb = RGBColor(71, 85, 105)

        r_h2 = hp1.add_run("Ingeniería de Requerimientos | Semana 8 | UNSM 2026-II")
        r_h2.font.name = "Calibri"
        r_h2.font.size = Pt(8.0)
        r_h2.font.color.rgb = RGBColor(100, 116, 139)
        hp1.alignment = WD_ALIGN_PARAGRAPH.LEFT
        hp1.paragraph_format.space_after = Pt(8)

        # Pie de página
        footer = section.footer
        fp = footer.paragraphs[0]
        fp.alignment = WD_ALIGN_PARAGRAPH.RIGHT
        fr = fp.add_run("Documento de Visión, Glosario y Casos de Uso — Sistema SIAE")
        fr.font.name = "Calibri"
        fr.font.size = Pt(8.0)
        fr.font.color.rgb = RGBColor(148, 163, 184)

    # Colores corporativos
    NAVY = RGBColor(27, 54, 93)       # #1B365D
    ROYAL = RGBColor(37, 99, 235)     # #2563EB
    DARK = RGBColor(30, 41, 59)       # #1E293B
    MUTED = RGBColor(100, 116, 139)   # #64748B

    def set_cell_bg(cell, fill_hex):
        shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
        cell._tc.get_or_add_tcPr().append(shd)

    def set_cell_padding(cell, top=70, bottom=70, left=90, right=90):
        tcPr = cell._tc.get_or_add_tcPr()
        tcMar = OxmlElement('w:tcMar')
        for m_name, m_val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
            node = OxmlElement(f'w:{m_name}')
            node.set(qn('w:w'), str(m_val))
            node.set(qn('w:type'), 'dxa')
            tcMar.append(node)
        tcPr.append(tcMar)

    def set_tbl_borders(table, color="CBD5E1", sz="4"):
        tblPr = table._tbl.tblPr
        borders = parse_xml(f'''
            <w:tblBorders {nsdecls("w")}>
                <w:top w:val="single" w:sz="{sz}" w:space="0" w:color="{color}"/>
                <w:bottom w:val="single" w:sz="{sz}" w:space="0" w:color="{color}"/>
                <w:left w:val="single" w:sz="{sz}" w:space="0" w:color="{color}"/>
                <w:right w:val="single" w:sz="{sz}" w:space="0" w:color="{color}"/>
                <w:insideH w:val="single" w:sz="{sz}" w:space="0" w:color="{color}"/>
                <w:insideV w:val="single" w:sz="{sz}" w:space="0" w:color="{color}"/>
            </w:tblBorders>
        ''')
        tblPr.append(borders)

    def add_sec_heading(num_str, title_str):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(14)
        p.paragraph_format.space_after = Pt(4)
        p.paragraph_format.keep_with_next = True
        r = p.add_run(f"{num_str}. {title_str}")
        r.font.name = "Calibri"
        r.font.size = Pt(14)
        r.font.bold = True
        r.font.color.rgb = NAVY
        return p

    def add_sub_heading(num_str, title_str):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(10)
        p.paragraph_format.space_after = Pt(3)
        p.paragraph_format.keep_with_next = True
        r = p.add_run(f"{num_str} {title_str}")
        r.font.name = "Calibri"
        r.font.size = Pt(11.5)
        r.font.bold = True
        r.font.color.rgb = ROYAL
        return p

    def add_guide_question(q_text):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(2)
        p.paragraph_format.space_after = Pt(3)
        p.paragraph_format.keep_with_next = True
        rb = p.add_run("Pregunta guía: ")
        rb.font.name = "Calibri"
        rb.font.size = Pt(9.5)
        rb.font.bold = True
        rb.font.color.rgb = DARK
        rt = p.add_run(q_text)
        rt.font.name = "Calibri"
        rt.font.size = Pt(9.5)
        rt.font.italic = True
        rt.font.color.rgb = DARK
        return p

    def add_explanation(text):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(1)
        p.paragraph_format.space_after = Pt(3)
        p.paragraph_format.line_spacing = 1.15
        r = p.add_run(text)
        r.font.name = "Calibri"
        r.font.size = Pt(9.5)
        r.font.color.rgb = MUTED
        return p

    def add_body_p(text, bold_prefix=None, space_after=4, italic=False):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(1)
        p.paragraph_format.space_after = Pt(space_after)
        p.paragraph_format.line_spacing = 1.15
        p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        if bold_prefix:
            rb = p.add_run(bold_prefix)
            rb.font.name = "Calibri"
            rb.font.size = Pt(9.5)
            rb.font.bold = True
            rb.font.color.rgb = DARK
        rt = p.add_run(text)
        rt.font.name = "Calibri"
        rt.font.size = Pt(9.5)
        rt.font.italic = italic
        rt.font.color.rgb = DARK
        return p

    def add_bullet_item(text, bold_prefix=None):
        p = doc.add_paragraph(style='List Bullet')
        p.paragraph_format.space_before = Pt(1)
        p.paragraph_format.space_after = Pt(3)
        p.paragraph_format.line_spacing = 1.15
        p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        if bold_prefix:
            rb = p.add_run(bold_prefix)
            rb.font.name = "Calibri"
            rb.font.size = Pt(9.5)
            rb.font.bold = True
            rb.font.color.rgb = DARK
        rt = p.add_run(text)
        rt.font.name = "Calibri"
        rt.font.size = Pt(9.5)
        rt.font.color.rgb = DARK
        return p

    # =========================================================================
    # TÍTULO PRINCIPAL
    # =========================================================================
    p_title = doc.add_paragraph()
    p_title.paragraph_format.space_before = Pt(6)
    p_title.paragraph_format.space_after = Pt(10)
    p_title.paragraph_format.keep_with_next = True
    r_t = p_title.add_run("FORMATO GUÍA PARA ELABORAR EL\nDOCUMENTO DE VISIÓN Y GLOSARIO")
    r_t.font.name = "Calibri"
    r_t.font.size = Pt(18)
    r_t.font.bold = True
    r_t.font.color.rgb = NAVY

    # =========================================================================
    # 1. DATOS GENERALES
    # =========================================================================
    add_sec_heading("1", "Datos generales")

    t_datos = doc.add_table(rows=6, cols=2)
    t_datos.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_tbl_borders(t_datos, color="94A3B8")
    col_w = [Inches(2.3), Inches(4.2)]

    datos_content = [
        ("Nombre del proyecto / sistema", "Sistema Integral de Administración Escolar (SIAE) / \"ESCUELITA\""),
        ("Integrantes", 
         "Arista Fernández Brayam\n"
         "Berrú Lozano Cristina\n"
         "Contreras Bernilla Judith Marianella\n"
         "Muñoz Mozombite Martin\n"
         "Yajahuanca Fernandez Luis Alberto"),
        ("Curso", "Ingeniería de Requerimientos"),
        ("Semana", "8"),
        ("Fecha", "26/10/2026"),
        ("Docente", "Ing. MBA. Annie Mabel Chong Bartra")
    ]

    for idx, (label, val) in enumerate(datos_content):
        row = t_datos.rows[idx]
        c0, c1 = row.cells[0], row.cells[1]
        c0.width = col_w[0]
        c1.width = col_w[1]
        set_cell_padding(c0, top=70, bottom=70, left=90, right=90)
        set_cell_padding(c1, top=70, bottom=70, left=90, right=90)

        p0 = c0.paragraphs[0]
        r0 = p0.add_run(label)
        r0.font.name = "Calibri"
        r0.font.size = Pt(9.5)
        r0.font.bold = True
        r0.font.color.rgb = DARK

        p1 = c1.paragraphs[0]
        r1 = p1.add_run(val)
        r1.font.name = "Calibri"
        r1.font.size = Pt(9.5)
        r1.font.color.rgb = DARK

    # =========================================================================
    # 2. MISIÓN Y VISIÓN
    # =========================================================================
    add_sec_heading("2", "Misión y Visión del proyecto y de la institución")
    add_explanation("Establece la razón de ser, el compromiso operativo y la proyección estratégica a futuro de la organización y del software.")

    add_sub_heading("2.1", "Misión Institucional — I.E. Saber Wasi")
    add_body_p(
        "\"Somos una institución educativa de nivel primaria comprometida con brindar a nuestras niñas y niños una formación "
        "académica de excelencia, inclusiva, humanista y sustentada en valores éticos sólidos. Fomentamos el desarrollo armónico de "
        "competencias cognitivas, creativas, socioemocionales y ciudadanas, proporcionando un entorno pedagógico seguro, cálido y "
        "estimulante, enriquecido por herramientas tecnológicas modernas e infraestructura de vanguardia, con el firme propósito de formar "
        "estudiantes autónomos, críticos y preparados para contribuir activamente a la transformación de su comunidad y el país.\"",
        italic=True, space_after=6
    )

    add_sub_heading("2.2", "Misión del Sistema de Información — SIAE")
    add_body_p(
        "\"Desarrollar, desplegar y mantener una plataforma web integral, robusta y escalable que automatice, centralice y optimice "
        "la gestión académica, administrativa y financiera de instituciones educativas de nivel primaria, erradicando la fragmentación y "
        "duplicidad de información propia de los métodos manuales. El sistema garantiza la trazabilidad rigurosa de matrículas, asistencias, "
        "calificaciones y cobranzas en caja, dotando a directivos, docentes y personal administrativo de herramientas ágiles y confiables para la "
        "toma de decisiones, y brindando a los apoderados un canal digital transparente, seguro y en tiempo real para el seguimiento de sus hijos.\"",
        italic=True, space_after=6
    )

    add_sub_heading("2.3", "Visión Institucional — I.E. Saber Wasi")
    add_body_p(
        "\"Para el año 2030, ser reconocidos como una institución educativa líder y referente de excelencia pedagógica y formativa "
        "a nivel regional y nacional en la educación básica regular (nivel primaria). Nos distinguiremos por nuestros altos estándares "
        "académicos, la sólida formación en valores de nuestros egresados, un modelo educativo innovador apoyado en la transformación digital "
        "integral y una gestión institucional eficiente, transparente y orientada al bienestar de toda la comunidad educativa.\"",
        italic=True, space_after=6
    )

    add_sub_heading("2.4", "Visión del Sistema de Información — SIAE")
    add_body_p(
        "\"Consolidar al Sistema Integral de Administración Escolar (SIAE) como la plataforma tecnológica SaaS (Software as a Service) "
        "de referencia en el ecosistema educativo peruano para la administración de centros escolares de primaria. El sistema destacará "
        "por su arquitectura modular de alto rendimiento, su riguroso modelo de seguridad basado en roles (RBAC) y criptografía adaptativa, su "
        "capacidad analítica con soporte de inteligencia artificial y su interoperabilidad fluida con entidades externas (RENIEC y formatos "
        "oficiales del MINEDU), permitiendo a las instituciones operar con cero papel, máxima eficiencia operativa y total satisfacción de las familias usuarias.\"",
        italic=True, space_after=8
    )

    # =========================================================================
    # 3. PROPÓSITO DEL PROYECTO
    # =========================================================================
    add_sec_heading("3", "Propósito del proyecto")
    add_explanation("Explica brevemente por qué se propone el proyecto y qué valor general se espera generar.")
    add_guide_question("¿Por qué se hace este proyecto?")
    add_body_p(
        "El proyecto SIAE (Sistema Integral de Administración Escolar) se propone como una plataforma web integral "
        "para digitalizar y automatizar la gestión académica, administrativa y financiera de instituciones educativas de nivel primaria, "
        "con foco inicial en la I.E. Saber Wasi. Su valor principal radica en centralizar todos los procesos escolares —matrícula, "
        "asistencia, calificaciones, tesorería, gestión docente y control de suscripciones— en un único ecosistema digital, "
        "eliminando la duplicidad de datos, reduciendo la carga operativa del personal y garantizando la trazabilidad completa "
        "de las operaciones institucionales."
    )

    # =========================================================================
    # 4. PROBLEMA Y OPORTUNIDAD
    # =========================================================================
    add_sec_heading("4", "Problema y oportunidad")
    add_explanation("Describe la situación actual, el problema que se desea resolver y, cuando corresponda, la oportunidad de mejora.")
    add_guide_question("¿Qué sucede actualmente? ¿A quién afecta? ¿Qué oportunidad de mejora existe?")
    add_body_p(
        "Actualmente, las instituciones educativas de nivel primaria como la I.E. Saber Wasi gestionan sus procesos académicos y "
        "administrativos de forma manual o con herramientas desarticuladas (hojas de cálculo, cuadernos físicos, documentos impresos). "
        "Esta situación genera duplicidad de información, pérdida de registros, demoras en la emisión de reportes académicos y errores "
        "frecuentes en el control de pagos y asistencias. Los apoderados carecen de un canal de consulta directa sobre el estado académico y "
        "financiero de sus hijos, lo que incrementa la carga operativa del personal administrativo."
    )
    add_body_p(
        "La oportunidad de mejora consiste en implementar un sistema web centralizado que integre todos los módulos institucionales, "
        "reduzca los tiempos de gestión en más del 60 %, garantice la integridad de los datos y ofrezca acceso en tiempo real a la "
        "información para todos los actores del ecosistema educativo."
    )

    # =========================================================================
    # 5. OBJETIVOS
    # =========================================================================
    add_sec_heading("5", "Objetivos")
    add_explanation("Indica qué se espera lograr con el proyecto. Redacta objetivos concretos y relacionados con el problema identificado.")
    add_guide_question("¿Qué queremos conseguir con la solución?")

    add_body_p(
        "Desarrollar e implementar un sistema web integral de gestión académica, administrativa y financiera que automatice los "
        "procesos operativos de instituciones educativas de nivel primaria, mejorando la eficiencia, la trazabilidad de la información "
        "y la experiencia de todos los usuarios involucrados.",
        bold_prefix="Objetivo general:\n"
    )

    add_body_p(
        "Diseñar e implementar los módulos de Seguridad (MSC), Infraestructura Académica (MIA) y Gestión Docente (MGD), que permitan "
        "configurar la estructura organizacional, gestionar usuarios con control de acceso basado en roles (RBAC) y automatizar la asignación "
        "de carga docente con validación de cruces horarios.",
        bold_prefix="Objetivo específico 1:\n"
    )

    add_body_p(
        "Construir los módulos de Matrícula (MMT) y Control y Evaluación (MCE), que permitan registrar alumnos, apoderados y matrículas, "
        "controlar asistencias diarias, registrar calificaciones con cálculo automático de promedios ponderados y generar reportes académicos consolidados.",
        bold_prefix="Objetivo específico 2:\n"
    )

    add_body_p(
        "Implementar el módulo de Tesorería y Finanzas (MTF) y el sistema de suscripciones SaaS, que gestionen conceptos de pago, deudas, "
        "cobros en caja con múltiples métodos de pago, y provean a los apoderados una interfaz de consulta de estados de cuenta y descarga de recibos electrónicos.",
        bold_prefix="Objetivo específico 3:\n"
    )

    # =========================================================================
    # 6. REQUERIMIENTOS: FUNCIONALES (RF-01 al RF-37) Y NO FUNCIONALES (RNF-01 al RNF-05)
    # =========================================================================
    add_sec_heading("6", "Requerimientos:")

    doc_src = docx.Document(os.path.join(DOCS_DIR, "Nuevo_doc.docx"))
    col_w_req = [Inches(1.8), Inches(4.7)]

    # RF-01 al RF-37
    for t_idx in range(1, 38):
        src_table = doc_src.tables[t_idx]
        new_tbl = doc.add_table(rows=len(src_table.rows), cols=2)
        new_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
        set_tbl_borders(new_tbl, color="CBD5E1")

        for r_idx, r in enumerate(src_table.rows):
            row = new_tbl.rows[r_idx]
            for c_idx in range(2):
                c = row.cells[c_idx]
                c.width = col_w_req[c_idx]
                set_cell_padding(c, top=55, bottom=55, left=75, right=75)
                text_val = r.cells[c_idx].text.strip()
                p = c.paragraphs[0]
                p.paragraph_format.space_before = Pt(1)
                p.paragraph_format.space_after = Pt(1)
                p.paragraph_format.line_spacing = 1.15
                run = p.add_run(text_val)
                run.font.name = "Calibri"
                run.font.size = Pt(9.0)
                if c_idx == 0 or (r_idx == 0 and c_idx == 1):
                    run.font.bold = True
                    run.font.color.rgb = NAVY if (r_idx == 0) else DARK
                else:
                    run.font.color.rgb = DARK

        doc.add_paragraph().paragraph_format.space_after = Pt(2)

    # RNF-01 al RNF-05
    rnf_list = [
        ("RNF-01", "Autenticación, control RBAC y cifrado de contraseñas", "Todos los usuarios",
         "Proteger la privacidad de los datos escolares y restringir acciones según el rol asignado.",
         "El sistema deberá cifrar todas las contraseñas con el algoritmo adaptativo BCrypt ($2a$) y validar las sesiones mediante tokens JWT firmados con algoritmo HS256.",
         "Las contraseñas deben tener longitud mínima de 8 caracteres. La sesión expira automáticamente tras inactividad.",
         "Las contraseñas se almacenan con hash en la base de datos MySQL; ningún usuario sin token válido puede consumir los endpoints protegidos."),
        
        ("RNF-02", "Disponibilidad operativa y continuidad del servicio", "Dirección y personal administrativo",
         "Garantizar que la plataforma esté accesible durante el horario escolar y periodos de matrícula.",
         "El sistema deberá garantizar una disponibilidad operativa (uptime) mínima del 99.8 % durante el horario escolar y días hábiles lectivos.",
         "Se realizarán copias de seguridad automáticas diarias de la base de datos MySQL a las 23:00 hrs.",
         "La plataforma responde a las peticiones sin interrupciones no programadas superiores a 15 minutos acumulados en el mes."),
        
        ("RNF-03", "Rendimiento y tiempos de respuesta ágiles", "Docentes y personal de caja",
         "Registrar notas, asistencias y cobros en ventanilla con máxima fluidez y rapidez operativa.",
         "El sistema deberá procesar y responder al 95 % de las peticiones transaccionales en un tiempo inferior a 2.0 segundos bajo condiciones normales de red.",
         "El cálculo automático de promedios ponderados y validación de vacantes debe ejecutarse en menos de 1 segundo.",
         "Las pruebas de rendimiento demuestran que la búsqueda de alumnos y carga de listas de clase se realizan en menos de 2 segundos."),
        
        ("RNF-04", "Soporte de concurrencia y carga de usuarios", "Personal de la institución y apoderados",
         "Soportar el acceso simultáneo de múltiples docentes y padres durante periodos de entrega de libretas o matrículas.",
         "El sistema deberá soportar al menos 50 sesiones activas simultáneas sin degradación perceptible en los tiempos de respuesta del servidor.",
         "Conexión gestionada mediante pool de conexiones HikariCP optimizado en el backend Spring Boot.",
         "Pruebas de estrés simulan 50 peticiones simultáneas manteniendo tiempos de respuesta dentro del umbral permitido."),
        
        ("RNF-05", "Adaptabilidad responsiva de interfaz de usuario", "Docentes y apoderados",
         "Consultar notas, asistencias y recibos desde computadoras de escritorio, laptops, tablets o smartphones.",
         "Las interfaces del sistema deberán adaptar sus pantallas de manera responsiva a anchos desde 360px (smartphones) hasta 1920px (escritorio).",
         "La vista de consulta de apoderados y el registro de asistencia docente deben ser 100 % operables sin desplazamiento horizontal forzado.",
         "Renderizado correcto y funcional verificado en navegadores Chrome, Edge y Firefox en resoluciones móviles y de escritorio.")
    ]

    for (rnf_id, rnf_name, rnf_actor, rnf_need, rnf_req, rnf_rule, rnf_crit) in rnf_list:
        new_tbl = doc.add_table(rows=7, cols=2)
        new_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
        set_tbl_borders(new_tbl, color="CBD5E1")

        rows_data = [
            ("1. ID del requisito", rnf_id),
            ("2. Nombre del requisito", rnf_name),
            ("3. Stakeholder / Actor", rnf_actor),
            ("4. Necesidad identificada", rnf_need),
            ("5. Requisito no funcional", rnf_req),
            ("6. Regla o condición", rnf_rule),
            ("7. Criterio de aceptación", rnf_crit)
        ]

        for r_idx, (k, v) in enumerate(rows_data):
            row = new_tbl.rows[r_idx]
            c0, c1 = row.cells[0], row.cells[1]
            c0.width = col_w_req[0]
            c1.width = col_w_req[1]
            set_cell_padding(c0, top=55, bottom=55, left=75, right=75)
            set_cell_padding(c1, top=55, bottom=55, left=75, right=75)

            p0 = c0.paragraphs[0]
            r0 = p0.add_run(k)
            r0.font.name = "Calibri"
            r0.font.size = Pt(9.0)
            r0.font.bold = True
            r0.font.color.rgb = DARK

            p1 = c1.paragraphs[0]
            r1 = p1.add_run(v)
            r1.font.name = "Calibri"
            r1.font.size = Pt(9.0)
            if r_idx == 0:
                r1.font.bold = True
                r1.font.color.rgb = NAVY
            else:
                r1.font.color.rgb = DARK

        doc.add_paragraph().paragraph_format.space_after = Pt(2)

    # =========================================================================
    # 7. STAKEHOLDERS / INTERESADOS
    # =========================================================================
    add_sec_heading("7", "Stakeholders / Interesados")
    add_explanation("Identifica las personas, grupos u organizaciones que tienen interés en el proyecto, que pueden verse afectadas o que participan en él.")

    t_sh = doc.add_table(rows=7, cols=4)
    t_sh.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_tbl_borders(t_sh, color="94A3B8")
    sh_widths = [Inches(1.6), Inches(1.5), Inches(2.2), Inches(1.2)]

    sh_data = [
        ("Stakeholder", "Rol / relación con el sistema", "Interés o necesidad", "Nivel de participación"),
        ("Dirección de la I.E. Saber Wasi", "Cliente / Patrocinador del proyecto", "Digitalizar y centralizar los procesos administrativos y académicos de la institución; auditar la gestión general.", "Alto – Aprobación y validación"),
        ("Administrador de sede", "Usuario operativo principal del sistema", "Gestionar matrículas, estructura académica, usuarios y reportes de su sede escolar sin demoras.", "Alto – Uso diario del sistema"),
        ("Docentes", "Usuario registrador de datos académicos", "Registrar asistencias, calificaciones y evaluaciones de sus secciones asignadas sin cálculos manuales.", "Medio-Alto – Uso frecuente lectivo"),
        ("Personal de Tesorería", "Usuario de gestión financiera", "Registrar cobros, controlar deudas, emitir recibos electrónicos y conciliar arqueos de caja.", "Medio – Uso diario financiero"),
        ("Apoderados / Padres de familia", "Beneficiario final (consulta)", "Consultar el estado académico, notas, asistencias y deudas de sus hijos en tiempo real vía web.", "Medio – Consulta periódica"),
        ("Proveedor de Identidad RENIEC", "Sistema externo / Integración", "Proveer validación fehaciente de identidad por DNI para evitar suplantaciones o errores en el padrón.", "Bajo – Consumo automatizado API")
    ]

    for r_idx, row_vals in enumerate(sh_data):
        row = t_sh.rows[r_idx]
        is_hdr = (r_idx == 0)
        for c_idx, val in enumerate(row_vals):
            cell = row.cells[c_idx]
            cell.width = sh_widths[c_idx]
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            set_cell_padding(cell, top=65, bottom=65, left=75, right=75)
            if is_hdr:
                set_cell_bg(cell, "1B365D")
            elif r_idx % 2 == 1:
                set_cell_bg(cell, "F8FAFC")
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_before = Pt(1)
            p.paragraph_format.space_after = Pt(1)
            r = p.add_run(val)
            r.font.name = "Calibri"
            r.font.size = Pt(8.5) if not is_hdr else Pt(9.0)
            if is_hdr:
                r.font.bold = True
                r.font.color.rgb = RGBColor(255, 255, 255)
            else:
                r.font.color.rgb = DARK

    # =========================================================================
    # 8. ALCANCE DEL PROYECTO
    # =========================================================================
    add_sec_heading("8", "Alcance del proyecto")
    add_explanation("Delimita qué forma parte del proyecto y qué elementos quedan fuera del alcance en esta etapa.")
    add_guide_question("¿Qué se construirá y qué quedará fuera?")

    add_sub_heading("8.1", "¿Qué entra en el alcance? (Incluido)")
    add_bullet_item(" Autenticación JWT, gestión de usuarios, roles y permisos CRUD por módulo con cifrado BCrypt.", "Módulo de Seguridad y Configuración:")
    add_bullet_item(" Registro de institución, sedes, años escolares, periodos académicos, grados, secciones y control de aforo físico.", "Módulo de Infraestructura Académica:")
    add_bullet_item(" Perfil docente, catálogo de cursos, asignación de carga académica y configuración de horarios con validación automática de cruces.", "Módulo de Gestión Docente:")
    add_bullet_item(" Padrón de alumnos y apoderados, ficha multisección de salud, verificación de vacantes y formalización de matrícula.", "Módulo de Matrícula:")
    add_bullet_item(" Asistencias diarias, planificación de evaluaciones, captura de calificaciones, promedios ponderados automáticos y boletas en PDF.", "Módulo de Control y Evaluación:")
    add_bullet_item(" Conceptos de pago, deudas, control de caja (apertura/arqueo/cierre), métodos de pago (efectivo, Yape, transferencia) y recibos electrónicos.", "Módulo de Tesorería y Finanzas:")
    add_bullet_item(" Planes, ciclos de facturación institucional y pagos de suscripción escolar.", "Sistema de suscripciones SaaS:")
    add_bullet_item(" Consulta y autocompletado de datos de identidad por DNI vía servicio web REST.", "Integración con servicio RENIEC:")
    add_bullet_item(" Asistente conversacional inteligente para consultas académicas en lenguaje natural directivas.", "Agente Inteligente IA:")

    add_sub_heading("8.2", "¿Qué queda fuera del alcance? (Excluido)")
    add_bullet_item(" No se contempla la liquidación de sueldos, compensaciones laborales, CTS ni beneficios del personal.", "Gestión de planillas y recursos humanos:")
    add_bullet_item(" No incluye libros contables oficiales, balances tributarios SUNAT ni estados financieros mercantiles.", "Contabilidad general corporativa:")
    add_bullet_item(" El software no se conecta de forma directa a los servidores centrales del MINEDU; se limita a la exportación de reportes compatibles.", "Interoperabilidad directa con SIAGIE:")
    add_bullet_item(" La solución se proporciona mediante portal web completamente responsivo para navegadores móviles y desktop.", "Aplicación móvil nativa:")
    add_bullet_item(" Quedan fuera del sistema el control de rutas escolares, menús de comedor escolar y quiosco interno.", "Gestión de transporte escolar y comedor:")

    # =========================================================================
    # 9. CARACTERÍSTICAS GENERALES DEL SISTEMA
    # =========================================================================
    add_sec_heading("9", "Características generales del sistema")
    add_explanation("Presenta las principales capacidades que tendrá la solución, sin describir todavía el detalle paso a paso de cada caso de uso.")

    t_feat = doc.add_table(rows=7, cols=3)
    t_feat.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_tbl_borders(t_feat, color="94A3B8")
    feat_widths = [Inches(0.6), Inches(2.2), Inches(3.7)]

    feat_data = [
        ("N.º", "Característica general", "Descripción breve"),
        ("1", "Gestión de acceso y seguridad", "Permitirá autenticar usuarios, gestionar roles y controlar permisos CRUD por módulo mediante tokens JWT y cifrado BCrypt."),
        ("2", "Administración de estructura académica", "Permitirá configurar instituciones, sedes, años escolares, periodos, grados, secciones y aulas para organizar la operación escolar."),
        ("3", "Gestión docente y horarios", "Permitirá registrar perfiles docentes, asignar carga académica por curso/sección y generar horarios con validación automática de cruces."),
        ("4", "Matrícula y expediente del alumno", "Permitirá registrar alumnos y apoderados, gestionar fichas con datos de salud, cargar documentación requerida y formalizar matrículas con control de vacantes."),
        ("5", "Control académico y evaluación", "Permitirá registrar asistencias diarias, crear evaluaciones, capturar calificaciones y calcular promedios ponderados por periodo con libretas PDF."),
        ("6", "Tesorería y gestión financiera", "Permitirá configurar conceptos de pago, controlar deudas, procesar cobros en caja, emitir recibos electrónicos y ofrecer portal de consulta para apoderados.")
    ]

    for r_idx, row_vals in enumerate(feat_data):
        row = t_feat.rows[r_idx]
        is_hdr = (r_idx == 0)
        for c_idx, val in enumerate(row_vals):
            cell = row.cells[c_idx]
            cell.width = feat_widths[c_idx]
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            set_cell_padding(cell, top=65, bottom=65, left=75, right=75)
            if is_hdr:
                set_cell_bg(cell, "1B365D")
            elif r_idx % 2 == 1:
                set_cell_bg(cell, "F8FAFC")
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_before = Pt(1)
            p.paragraph_format.space_after = Pt(1)
            r = p.add_run(val)
            r.font.name = "Calibri"
            r.font.size = Pt(8.5) if not is_hdr else Pt(9.0)
            if is_hdr:
                r.font.bold = True
                r.font.color.rgb = RGBColor(255, 255, 255)
            else:
                r.font.color.rgb = DARK

    # =========================================================================
    # 10. CRITERIOS DE ÉXITO
    # =========================================================================
    add_sec_heading("10", "Criterios de éxito")
    add_explanation("Define cómo se reconocerá que el proyecto alcanzó los resultados esperados. Cuando sea posible, formula criterios observables o medibles.")

    t_succ = doc.add_table(rows=7, cols=3)
    t_succ.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_tbl_borders(t_succ, color="94A3B8")
    succ_widths = [Inches(0.6), Inches(2.7), Inches(3.2)]

    succ_data = [
        ("N.º", "Criterio de éxito", "¿Cómo se comprobará?"),
        ("1", "El 100 % de los usuarios pueden autenticarse y acceder únicamente a los módulos de su rol asignado.", "Prueba de acceso con distintos roles verificando restricciones de permisos y denegación de endpoints no autorizados."),
        ("2", "Las matrículas se registran en menos de 3 minutos con validación automática de vacantes.", "Cronometraje del proceso de matrícula completo y verificación del control de aforo por sección."),
        ("3", "Los promedios académicos se calculan automáticamente sin intervención manual del docente.", "Registro de calificaciones y verificación de promedios ponderados y libretas PDF generadas por el sistema."),
        ("4", "Los apoderados pueden consultar el estado de cuenta y descargar recibos en formato PDF en tiempo real.", "Acceso a la interfaz de consulta familiar y descarga exitosa de al menos un recibo electrónico."),
        ("5", "El registro del alumno se autocompleta con datos de RENIEC en menos de 2 segundos.", "Prueba de consulta de DNI en formulario de alumno y verificación de nombres y apellidos cargados automáticamente."),
        ("6", "El sistema responde con fluidez y mantiene alta disponibilidad operativa.", "Pruebas de carga con 50 sesiones simultáneas (tiempos de respuesta ≤ 2 s) y disponibilidad del 99.8 % en horario escolar.")
    ]

    for r_idx, row_vals in enumerate(succ_data):
        row = t_succ.rows[r_idx]
        is_hdr = (r_idx == 0)
        for c_idx, val in enumerate(row_vals):
            cell = row.cells[c_idx]
            cell.width = succ_widths[c_idx]
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            set_cell_padding(cell, top=65, bottom=65, left=75, right=75)
            if is_hdr:
                set_cell_bg(cell, "1B365D")
            elif r_idx % 2 == 1:
                set_cell_bg(cell, "F8FAFC")
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_before = Pt(1)
            p.paragraph_format.space_after = Pt(1)
            r = p.add_run(val)
            r.font.name = "Calibri"
            r.font.size = Pt(8.5) if not is_hdr else Pt(9.0)
            if is_hdr:
                r.font.bold = True
                r.font.color.rgb = RGBColor(255, 255, 255)
            else:
                r.font.color.rgb = DARK

    # =========================================================================
    # 11. RESUMEN DE LA VISIÓN
    # =========================================================================
    add_sec_heading("11", "Resumen de la visión")
    add_explanation("En un párrafo, resume qué se quiere construir, por qué se necesita, para quién y cuál es el alcance general.")
    add_body_p(
        "SIAE es un sistema web integral diseñado para digitalizar y automatizar la gestión académica, administrativa y financiera "
        "de instituciones educativas de nivel primaria, con foco inicial en la I.E. Saber Wasi. Se necesita porque los procesos actuales —basados "
        "en registros manuales y herramientas desarticuladas— generan duplicidad de datos, demoras operativas y falta de trazabilidad. "
        "El sistema está dirigido a cinco perfiles de usuario: SuperAdmin, Administrador de sede, Docentes, Personal de Tesorería y Apoderados (consulta). "
        "Su alcance abarca seis módulos funcionales (Seguridad, Infraestructura Académica, Gestión Docente, Matrícula, Control y Evaluación, y Tesorería) "
        "más un sistema SaaS de suscripciones, integración con servicio RENIEC para validación de DNI y soporte de consultas analíticas mediante IA. "
        "Quedan excluidos la gestión de planillas, la contabilidad general corporativa y la interoperabilidad directa en tiempo real con SIAGIE."
    )

    # =========================================================================
    # 12. REVISIÓN DE COHERENCIA
    # =========================================================================
    add_sec_heading("12", "Revisión de coherencia")
    checks = [
        "El problema está claramente descrito.",
        "El propósito y los objetivos están relacionados con el problema.",
        "Los stakeholders son pertinentes.",
        "Se diferencia lo incluido de lo excluido.",
        "Las características están descritas a nivel general.",
        "Los criterios de éxito permiten comprobar el logro.",
        "El documento no entra todavía en el detalle de los flujos de cada Caso de Uso.",
        "La terminología utilizada será consistente con el Documento de Glosario."
    ]
    for chk in checks:
        p_c = doc.add_paragraph()
        p_c.paragraph_format.space_before = Pt(1)
        p_c.paragraph_format.space_after = Pt(2)
        r_box = p_c.add_run("☐  ")
        r_box.font.name = "Calibri"
        r_box.font.size = Pt(10)
        r_box.font.bold = True
        r_box.font.color.rgb = ROYAL
        r_txt = p_c.add_run(chk)
        r_txt.font.name = "Calibri"
        r_txt.font.size = Pt(9.5)
        r_txt.font.color.rgb = DARK

    # =========================================================================
    # 13. RELACIÓN CON LOS DOCUMENTOS DEL PROYECTO
    # =========================================================================
    add_sec_heading("13", "Relación con los documentos del proyecto")

    t_rel = doc.add_table(rows=4, cols=2)
    t_rel.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_tbl_borders(t_rel, color="94A3B8")
    rel_widths = [Inches(2.2), Inches(4.3)]

    rel_data = [
        ("Documento de Visión", "Explica el panorama general: problema, propósito, alcance y valor esperado."),
        ("Documento de Glosario", "Define los términos que deben entenderse de manera común."),
        ("Casos de Uso", "Detallan comportamientos y secuencias del sistema."),
        ("Validación", "Posteriormente permite revisar si los requerimientos son comprensibles y verificables.")
    ]

    for r_idx, (d1, d2) in enumerate(rel_data):
        row = t_rel.rows[r_idx]
        c0, c1 = row.cells[0], row.cells[1]
        c0.width = rel_widths[0]
        c1.width = rel_widths[1]
        set_cell_padding(c0, top=60, bottom=60, left=80, right=80)
        set_cell_padding(c1, top=60, bottom=60, left=80, right=80)
        p0 = c0.paragraphs[0]
        r0 = p0.add_run(d1)
        r0.font.name = "Calibri"
        r0.font.size = Pt(9.0)
        r0.font.bold = True
        r0.font.color.rgb = NAVY

        p1 = c1.paragraphs[0]
        r1 = p1.add_run(d2)
        r1.font.name = "Calibri"
        r1.font.size = Pt(9.0)
        r1.font.color.rgb = DARK

    # =========================================================================
    # 14. GLOSARIO DEL PROYECTO – PLANTILLA DE TRABAJO
    # =========================================================================
    add_sec_heading("14", "Glosario del proyecto – plantilla de trabajo")

    t_gloss = doc.add_table(rows=27, cols=6)
    t_gloss.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_tbl_borders(t_gloss, color="94A3B8")
    gloss_widths = [Inches(0.5), Inches(1.2), Inches(2.2), Inches(0.9), Inches(0.9), Inches(1.1)]

    gloss_items = [
        ("N.º", "Término", "Definición", "Tipo", "Sinónimos / relacionados", "Observaciones"),
        ("1", "SIAE", "Sistema Integral de Administración Escolar; plataforma web para la gestión académica, administrativa y financiera de instituciones educativas de nivel primaria.", "Acrónimo", "ESCUELITA", "Nombre formal del proyecto"),
        ("2", "JWT", "JSON Web Token; estándar abierto (RFC 7519) para la transmisión segura de información entre partes como un objeto JSON firmado digitalmente.", "Tecnología", "Token de acceso", "Usado con algoritmo HS256 y librería JJWT 0.12.6"),
        ("3", "BCrypt", "Algoritmo de hashing adaptativo para el cifrado seguro de contraseñas, basado en el cifrado Blowfish.", "Tecnología", "Hash de contraseña", "Migración automática desde texto plano"),
        ("4", "RBAC", "Control de Acceso Basado en Roles; modelo de seguridad que restringe el acceso al sistema según el rol asignado al usuario.", "Concepto", "Matriz de permisos", "Implementado mediante RolModulo"),
        ("5", "CRUD", "Acrónimo de las cuatro operaciones básicas: Crear, Leer, Actualizar y Eliminar registros en un sistema de información.", "Concepto", "Operaciones básicas", "Aplicado a todos los módulos del sistema"),
        ("6", "Malla Curricular", "Estructura que organiza las áreas, cursos y especialidades que se imparten por grado y periodo en la institución.", "Dominio", "Plan de estudios", "Vinculada a grado y periodo"),
        ("7", "Matrícula", "Acto formal de inscripción de un alumno en un año escolar, grado y sección específica, sujeto a disponibilidad de vacantes.", "Dominio", "Inscripción", "Requiere alumno y apoderado registrados"),
        ("8", "Apoderado", "Padre, madre o tutor legal responsable financiera y legalmente del alumno ante la institución educativa.", "Dominio", "Tutor, representante legal", "Vinculado al alumno mediante AlumnoApoderado"),
        ("9", "SaaS", "Software como Servicio; modelo de distribución donde la aplicación es alojada en la nube y accedida vía navegador web.", "Concepto", "Software en la nube", "Modelo de negocio del sistema de suscripciones"),
        ("10", "RENIEC", "Registro Nacional de Identificación y Estado Civil del Perú; entidad pública que gestiona el DNI y los datos de identidad ciudadana.", "Entidad externa", "Registro civil", "Integrado vía API REST para validación de DNI"),
        ("11", "SIAGIE", "Sistema de Información de Apoyo a la Gestión de la Institución Educativa; portal oficial del MINEDU para actas y consolidados.", "Entidad externa", "Portal MINEDU", "Destino de exportación de reportes oficiales"),
        ("12", "SRS", "Software Requirements Specification; especificación formal de requerimientos de software según el estándar IEEE Std 830.", "Ingeniería de software", "Documento de requisitos", "Línea base técnica para el análisis del sistema"),
        ("13", "RF", "Requerimiento Funcional; declaración de una función o servicio que el software debe proveer en respuesta a estímulos del usuario.", "Ingeniería de software", "Requisito funcional", "Identificados del RF-01 al RF-37"),
        ("14", "RNF", "Requerimiento No Funcional; restricción técnica o atributo de calidad (rendimiento, seguridad, disponibilidad) que el sistema debe cumplir.", "Ingeniería de software", "Atributo de calidad", "Incluye tiempo de respuesta < 2s y cifrado BCrypt"),
        ("15", "CU / UC", "Caso de Uso (Use Case); técnica de modelado UML que describe la interacción entre actores y el sistema para un objetivo concreto.", "Modelado UML", "Historia de uso", "Modelados formalmente desde CU-E01 a CU-E07"),
        ("16", "Chatbot IA", "Asistente inteligente conversacional integrado que traduce preguntas en lenguaje natural a consultas seguras sobre la base de datos.", "Tecnología / IA", "Asistente virtual", "Integrado vía API REST /api/chatbot/preguntar"),
        ("17", "Sede Escolar", "Ubicación geográfica e inmueble físico en el que opera la institución educativa, albergando aulas y oficinas.", "Dominio", "Filial, local", "Soporta Sede Central y Sedes Anexas"),
        ("18", "Año Escolar", "Configuración del calendario lectivo vigente, dividido administrativamente en bimestres o trimestres con fechas oficiales.", "Dominio", "Periodo académico", "Debe estar activo para apertura de matrículas"),
        ("19", "Ficha Multisección", "Legajo digital del estudiante que reúne antecedentes filiales, contactos de emergencia, ficha de salud, alergias y observaciones.", "Dominio", "Expediente digital", "Sustituye el archivo en papel"),
        ("20", "Concepto de Pago", "Catálogo oficial de aranceles institucionales (derecho de matrícula, pensiones mensuales, cuotas de actividades).", "Dominio", "Tarifa, arancel", "Configurable con monto base y vencimiento"),
        ("21", "Arqueo de Caja", "Procedimiento de control diario mediante el cual tesorería concilia los cobros en efectivo y virtuales contra el sistema.", "Dominio", "Cierre de caja", "Genera acta formal inmutable"),
        ("22", "Recibo Electrónico", "Documento probatorio con código correlativo único emitido en PDF tras el cobro de una deuda.", "Dominio", "Comprobante de pago", "Descargable por apoderados desde la web"),
        ("23", "Calificación Literal", "Escala cualitativa de evaluación del rendimiento estudiantil en primaria fijada por el MINEDU: AD, A, B y C.", "Dominio", "Nota cualitativa", "Promediada algorítmicamente por periodo"),
        ("24", "Promedio Ponderado", "Cálculo matemático automático que sintetiza las evaluaciones parciales aplicando pesos sin intervención manual docente.", "Dominio", "Nota bimestral", "Elimina errores de consolidación manual"),
        ("25", "Cruce de Horarios", "Conflicto operativo en el que un docente, aula o sección es asignado a dos materias simultáneamente en el mismo bloque horario.", "Dominio", "Colisión horaria", "Bloqueado algorítmicamente por el backend"),
        ("26", "Aforo Máximo", "Límite máximo de estudiantes que una sección o aula física puede albergar respetando normas pedagógicas.", "Dominio", "Capacidad de aula", "Controla vacantes e impide sobrematrícula")
    ]

    for r_idx, row_vals in enumerate(gloss_items):
        row = t_gloss.rows[r_idx]
        is_hdr = (r_idx == 0)
        for c_idx, val in enumerate(row_vals):
            cell = row.cells[c_idx]
            cell.width = gloss_widths[c_idx]
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            set_cell_padding(cell, top=60, bottom=60, left=70, right=70)
            if is_hdr:
                set_cell_bg(cell, "1B365D")
            elif r_idx % 2 == 1:
                set_cell_bg(cell, "F8FAFC")
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_before = Pt(1)
            p.paragraph_format.space_after = Pt(1)
            r = p.add_run(val)
            r.font.name = "Calibri"
            r.font.size = Pt(8.0) if not is_hdr else Pt(8.5)
            if is_hdr:
                r.font.bold = True
                r.font.color.rgb = RGBColor(255, 255, 255)
            else:
                r.font.color.rgb = DARK

    # =========================================================================
    # 15. DISEÑO DEL MODELO DE CASOS DE USO (DIAGRAMAS UML)
    # =========================================================================
    add_sec_heading("15", "Diseño del modelo de casos de uso (Diagramas UML)")
    add_body_p(
        "El modelo de casos de uso representa las funciones que el sistema ofrece a sus usuarios y la forma en que cada rol participa "
        "en ellas. Se construyó a partir de los casos de uso detallados en el documento de análisis y diseño. Para facilitar su lectura se "
        "presenta primero un diagrama general y luego un diagrama específico por cada módulo funcional de la institución educativa."
    )
    add_body_p(
        "Los actores primarios son cinco: SuperAdmin (gestión global de plataforma), Administrador (gestión operativa de la sede), "
        "Docente (registro académico y notas), Personal de Tesorería (gestión financiera y caja) y Apoderado (consulta familiar). "
        "Los actores secundarios son la Base de Datos MySQL (persistencia transaccional) y el Proveedor de Identidad RENIEC (validación de DNI)."
    )

    # 15.1 Diagrama General
    add_sub_heading("15.1", "Diagrama de casos de uso general")
    add_body_p(
        "La Figura 1 reúne los casos de uso nucleares organizados en torno a la gestión escolar integral: seguridad y configuración, "
        "matrícula, docencia, evaluación y finanzas. El diagrama muestra qué actor ejecuta cada caso y las relaciones «include» y «extend» "
        "entre ellos. Iniciar Sesión es el caso de uso base utilizado por todos los roles."
    )
    fig1_file = os.path.join(DOCS_DIR, "fig1_diagrama_general.png")
    if os.path.exists(fig1_file):
        p_img1 = doc.add_paragraph()
        p_img1.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img1.paragraph_format.space_before = Pt(4)
        p_img1.paragraph_format.space_after = Pt(2)
        p_img1.add_run().add_picture(fig1_file, width=Inches(6.2))
        p_cap1 = doc.add_paragraph()
        p_cap1.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap1.paragraph_format.space_after = Pt(8)
        rc1 = p_cap1.add_run("Figura 1. Diagrama de casos de uso general del sistema de gestión escolar.")
        rc1.font.name = "Calibri"
        rc1.font.size = Pt(8.5)
        rc1.font.italic = True
        rc1.font.color.rgb = MUTED

    # 15.2 Seguridad
    add_sub_heading("15.2", "Módulo de seguridad y configuración")
    add_body_p(
        "La Figura 2 contiene los casos UC-001 Iniciar Sesión (JWT / BCrypt), UC-002 Recuperar Contraseña, UC-003 Gestionar Usuarios y "
        "UC-004 Gestionar Roles y Permisos. Todos los roles inician sesión. La administración de cuentas de usuario, roles y la matriz de "
        "permisos CRUD por módulo queda a cargo exclusivo del Administrador y SuperAdmin. Los casos de uso consultan y persisten información "
        "en la Base de Datos MySQL con cifrado seguro."
    )
    fig2_file = os.path.join(DOCS_DIR, "fig2_seguridad.png")
    if os.path.exists(fig2_file):
        p_img2 = doc.add_paragraph()
        p_img2.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img2.add_run().add_picture(fig2_file, width=Inches(5.8))
        p_cap2 = doc.add_paragraph()
        p_cap2.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap2.paragraph_format.space_after = Pt(8)
        rc2 = p_cap2.add_run("Figura 2. Diagrama de casos de uso del módulo de seguridad y configuración.")
        rc2.font.name = "Calibri"
        rc2.font.size = Pt(8.5)
        rc2.font.italic = True
        rc2.font.color.rgb = MUTED

    # 15.3 Infraestructura
    add_sub_heading("15.3", "Módulo de infraestructura académica")
    add_body_p(
        "La Figura 3 contiene los casos UC-006 Configuración Institucional y Sedes, UC-007 Gestionar Años Escolares y Periodos, "
        "UC-008 Gestionar Pabellones, Aulas y Aforos, y UC-009 Aperturar Grados, Secciones y Vacantes. El SuperAdmin configura las sedes físicas "
        "y datos fiscales del colegio, mientras que el Administrador de sede gestiona el calendario lectivo y apertura las vacantes por aula."
    )
    fig3_file = os.path.join(DOCS_DIR, "fig3_infraestructura.png")
    if os.path.exists(fig3_file):
        p_img3 = doc.add_paragraph()
        p_img3.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img3.add_run().add_picture(fig3_file, width=Inches(5.8))
        p_cap3 = doc.add_paragraph()
        p_cap3.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap3.paragraph_format.space_after = Pt(8)
        rc3 = p_cap3.add_run("Figura 3. Diagrama de casos de uso del módulo de infraestructura académica.")
        rc3.font.name = "Calibri"
        rc3.font.size = Pt(8.5)
        rc3.font.italic = True
        rc3.font.color.rgb = MUTED

    # 15.4 Docencia
    add_sub_heading("15.4", "Módulo de gestión docente y horarios")
    add_body_p(
        "La Figura 4 contiene los casos UC-010 Gestionar Catálogo de Cursos, UC-011 Configurar Jornadas y Horarios, UC-012 Registrar "
        "Perfiles Docentes, UC-013 Asignar Carga Académica y UC-014 Validar Cruces de Horarios. El Administrador registra profesores y "
        "les asigna materias por sección; la asignación tiene una relación obligatoria «include» con UC-014 para validar algorítmicamente que no "
        "existan colisiones de horarios ni de aulas asignadas."
    )
    fig4_file = os.path.join(DOCS_DIR, "fig4_docencia.png")
    if os.path.exists(fig4_file):
        p_img4 = doc.add_paragraph()
        p_img4.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img4.add_run().add_picture(fig4_file, width=Inches(5.8))
        p_cap4 = doc.add_paragraph()
        p_cap4.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap4.paragraph_format.space_after = Pt(8)
        rc4 = p_cap4.add_run("Figura 4. Diagrama de casos de uso del módulo de gestión docente y horarios.")
        rc4.font.name = "Calibri"
        rc4.font.size = Pt(8.5)
        rc4.font.italic = True
        rc4.font.color.rgb = MUTED

    # 15.5 Matrícula
    add_sub_heading("15.5", "Módulo de matrícula y expediente estudiantil")
    add_body_p(
        "La Figura 5 contiene los casos CU-E01 Registrar Alumno, CU-E02 Consultar Identidad por DNI, CU-E03 Vincular Apoderado, "
        "CU-E04 Registrar Matrícula Formal y CU-E05 Verificar Vacantes Disponibles. Registrar Alumno tiene una relación «extend» con Consultar "
        "Identidad por DNI (consumiendo la API de RENIEC para autocompletar nombres). Registrar Matrícula tiene una relación «include» con "
        "Verificar Vacantes Disponibles, deteniendo el registro si la sección alcanzó su aforo máximo."
    )
    fig5_file = os.path.join(DOCS_DIR, "fig5_matricula.png")
    if os.path.exists(fig5_file):
        p_img5 = doc.add_paragraph()
        p_img5.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img5.add_run().add_picture(fig5_file, width=Inches(5.8))
        p_cap5 = doc.add_paragraph()
        p_cap5.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap5.paragraph_format.space_after = Pt(8)
        rc5 = p_cap5.add_run("Figura 5. Diagrama de casos de uso del módulo de matrícula.")
        rc5.font.name = "Calibri"
        rc5.font.size = Pt(8.5)
        rc5.font.italic = True
        rc5.font.color.rgb = MUTED

    # 15.6 Control y Evaluación
    add_sub_heading("15.6", "Módulo de control y evaluación académica")
    add_body_p(
        "La Figura 6 contiene los casos UC-020 Panel 'Mis Cursos', UC-021 Registrar Asistencia Diaria, UC-023 Registrar Calificaciones, "
        "UC-025 Calcular Promedios Ponderados y UC-026 Generar Boleta de Notas PDF. Los profesores toman asistencia y registran notas desde su "
        "panel; Registrar Calificaciones incluye automáticamente el cálculo de promedios ponderados bimestrales. El Administrador y los Apoderados "
        "pueden exportar y descargar las libretas oficiales en formato PDF."
    )
    fig6_file = os.path.join(DOCS_DIR, "fig6_evaluacion.png")
    if os.path.exists(fig6_file):
        p_img6 = doc.add_paragraph()
        p_img6.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img6.add_run().add_picture(fig6_file, width=Inches(5.8))
        p_cap6 = doc.add_paragraph()
        p_cap6.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap6.paragraph_format.space_after = Pt(8)
        rc6 = p_cap6.add_run("Figura 6. Diagrama de casos de uso del módulo de control y evaluación.")
        rc6.font.name = "Calibri"
        rc6.font.size = Pt(8.5)
        rc6.font.italic = True
        rc6.font.color.rgb = MUTED

    # 15.7 Tesorería
    add_sub_heading("15.7", "Módulo de tesorería y finanzas")
    add_body_p(
        "La Figura 7 contiene los casos CU-E06 Apertura y Cierre de Caja, CU-E07 Registrar Cobro de Aranceles, UC-031 Emitir Recibo "
        "Electrónico PDF, UC-033 Consultar Deudas y Estado de Cuenta, y UC-034 Portal de Consulta Apoderado. El personal de caja apertura la jornada, "
        "procesa pagos por aranceles escolares y el sistema emite automáticamente el recibo electrónico en PDF («include»). Los apoderados pueden "
        "consultar deudas y descargar sus recibos mediante la interfaz web familiar de solo lectura."
    )
    fig7_file = os.path.join(DOCS_DIR, "fig7_tesoreria.png")
    if os.path.exists(fig7_file):
        p_img7 = doc.add_paragraph()
        p_img7.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img7.add_run().add_picture(fig7_file, width=Inches(5.8))
        p_cap7 = doc.add_paragraph()
        p_cap7.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap7.paragraph_format.space_after = Pt(8)
        rc7 = p_cap7.add_run("Figura 7. Diagrama de casos de uso del módulo de tesorería y finanzas.")
        rc7.font.name = "Calibri"
        rc7.font.size = Pt(8.5)
        rc7.font.italic = True
        rc7.font.color.rgb = MUTED

    # =========================================================================
    # 16. ESPECIFICACIONES DETALLADAS DE CASOS DE USO
    # =========================================================================
    add_sec_heading("16", "Especificaciones detalladas de casos de uso")
    add_body_p(
        "A continuación se presentan las especificaciones formales y rigurosas de los casos de uso nucleares del sistema SIAE, "
        "siguiendo las directrices del curso y el estándar RUP/IEEE. Cada ficha técnica detalla actores, precondiciones, flujo principal, "
        "flujos alternativos y postcondiciones:"
    )

    uc_specs = [
        {
            "id": "CU-E01",
            "name": "Registrar alumno",
            "req": "RF-E01 / RF-13",
            "actors": "Primarios: Admin y Secretaría. Secundario: Proveedor de identidad RENIEC (solo cuando se ejecuta la extensión CU-E02).",
            "goal": "Registrar a un nuevo alumno con sus datos personales para que luego pueda ser vinculado con un apoderado y matriculado.",
            "pre": [
                "El usuario está autenticado y tiene permisos para registrar alumnos.",
                "El alumno no está registrado previamente en el sistema."
            ],
            "main_flow": [
                "1. El usuario selecciona la opción «Registrar alumno».",
                "2. El sistema muestra el formulario de registro.",
                "3. El usuario ingresa los datos de identidad del alumno (punto de extensión: ingreso de datos de identidad).",
                "4. El usuario completa los demás datos requeridos del alumno (fecha de nacimiento, contacto, ficha médica).",
                "5. El sistema valida que los campos obligatorios estén completos y que el DNI no esté registrado.",
                "6. El usuario revisa los datos y confirma el registro.",
                "7. El sistema guarda al alumno y muestra la confirmación."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Autocompletar por DNI:", "En el paso 3, el usuario solicita autocompletar los datos. El sistema ejecuta «Consultar identidad por DNI» (CU-E02) y carga los datos obtenidos en el formulario. El usuario los revisa y el flujo continúa en el paso 4. Si la consulta no es posible, el usuario ingresa los datos manualmente."),
                ("Flujo alternativo A2 — Datos inválidos o alumno ya registrado:", "En el paso 5, el sistema detecta campos obligatorios vacíos, datos con formato incorrecto o un DNI ya registrado. El sistema informa el problema y señala los campos afectados. El usuario corrige los datos y el flujo retoma el paso 5, o cancela la operación sin que se guarde ningún registro.")
            ],
            "post": [
                "El alumno queda registrado y activo en el sistema.",
                "El alumno está disponible para vincular un apoderado (CU-E03) y para ser matriculado (CU-E04)."
            ]
        },
        {
            "id": "CU-E02",
            "name": "Consultar identidad por DNI",
            "req": "RF-E01 / Servicio RENIEC",
            "actors": "Primarios: Admin y Secretaría (a través de Registrar alumno). Secundario: Proveedor de identidad RENIEC, que proporciona la información.",
            "goal": "Obtener los datos de identidad de una persona a partir de su DNI para autocompletar el formulario de registro.",
            "pre": [
                "El usuario está autenticado y se encuentra en el registro de un alumno (CU-E01).",
                "El usuario ha solicitado autocompletar los datos por DNI.",
                "El servicio del proveedor de identidad RENIEC está disponible."
            ],
            "main_flow": [
                "1. El usuario ingresa el número de DNI y solicita la consulta.",
                "2. El sistema valida que el DNI tenga un formato válido de 8 dígitos numéricos.",
                "3. El sistema envía la solicitud de consulta al servicio web del proveedor RENIEC.",
                "4. El proveedor de identidad responde con los nombres, apellidos y foto de la persona.",
                "5. El sistema muestra los datos obtenidos para su revisión.",
                "6. El usuario acepta los datos y el sistema los incorpora al formulario de registro."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — DNI inválido o no encontrado:", "En el paso 2 o en el paso 4, el DNI tiene un formato incorrecto o RENIEC no devuelve resultados. El sistema informa la situación. El usuario corrige el DNI y repite la consulta, o continúa con el ingreso manual de los datos."),
                ("Flujo alternativo A2 — Servicio de RENIEC no disponible:", "En el paso 3, el sistema no logra comunicarse con RENIEC o se agota el tiempo de espera. El sistema informa que no se pudo realizar la consulta y no autocompleta ningún dato. El usuario reintenta más tarde o completa el registro de forma manual.")
            ],
            "post": [
                "Los datos de identidad quedan cargados en el formulario de registro del alumno, pendientes de la confirmación del usuario en CU-E01.",
                "Si la consulta falla, el registro puede completarse mediante ingreso manual."
            ]
        },
        {
            "id": "CU-E03",
            "name": "Vincular apoderado",
            "req": "RF-E02 / RF-12",
            "actors": "Primarios: Admin y Secretaría.",
            "goal": "Asociar un apoderado a un alumno ya registrado.",
            "pre": [
                "El usuario está autenticado y tiene permisos para vincular apoderados.",
                "El alumno está registrado y activo en el sistema."
            ],
            "main_flow": [
                "1. El usuario busca y selecciona al alumno.",
                "2. El usuario elige la opción «Vincular apoderado».",
                "3. El usuario ingresa los datos del apoderado y su parentesco con el alumno.",
                "4. El sistema valida los datos ingresados y verifica que el vínculo no exista.",
                "5. El usuario confirma la vinculación.",
                "6. El sistema guarda el vínculo y muestra la confirmación."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Alumno no encontrado:", "En el paso 1, la búsqueda no devuelve ningún alumno. El sistema informa que el alumno no está registrado. El usuario corrige los criterios de búsqueda, registra al alumno mediante CU-E01 o cancela la operación."),
                ("Flujo alternativo A2 — Vínculo existente o datos inválidos:", "En el paso 4, el apoderado ya está vinculado al alumno o los datos no son válidos. El sistema informa el problema y no genera un vínculo duplicado. El usuario corrige los datos o cancela la operación.")
            ],
            "post": [
                "El apoderado queda vinculado al alumno y la relación puede consultarse en la información del alumno.",
                "No se generan vínculos duplicados."
            ]
        },
        {
            "id": "CU-E04",
            "name": "Registrar matrícula",
            "req": "RF-E03 / RF-14",
            "actors": "Primarios: Admin o Tesorería.",
            "goal": "Registrar al alumno en un grado y sección del año escolar.",
            "pre": [
                "El usuario está autenticado y tiene permisos.",
                "El alumno está activo.",
                "El año escolar, el grado y la sección están configurados."
            ],
            "main_flow": [
                "1. El usuario selecciona al alumno y el año escolar.",
                "2. El usuario elige el grado y la sección.",
                "3. El sistema ejecuta «Verificar vacantes» (CU-E05) y confirma que existe cupo.",
                "4. El usuario revisa los datos y confirma el registro.",
                "5. El sistema guarda la matrícula y muestra la confirmación."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Sin vacantes:", "En el paso 3, el sistema informa que no existe cupo en la sección. El usuario selecciona otra sección o cancela la operación. No se registra una matrícula en una sección sin cupo."),
                ("Flujo alternativo A2 — Alumno ya matriculado en el año escolar:", "En el paso 1, el sistema detecta que el alumno ya tiene una matrícula registrada para el año escolar seleccionado. El sistema informa la situación y no permite una matrícula duplicada. El usuario cancela la operación o selecciona otro alumno o año escolar.")
            ],
            "post": [
                "La matrícula queda registrada y disponible para consulta.",
                "No se registra ninguna matrícula en una sección sin cupo."
            ]
        },
        {
            "id": "CU-E05",
            "name": "Verificar vacantes",
            "req": "RF-E03 / RF-09",
            "actors": "Es un caso de uso incluido: lo ejecuta el sistema dentro de Registrar matrícula (CU-E04) y lo activan indirectamente Admin o Tesorería.",
            "goal": "Comprobar que la sección elegida tiene cupo disponible antes de registrar una matrícula.",
            "pre": [
                "El caso de uso Registrar matrícula (CU-E04) lo ha invocado.",
                "Se han seleccionado el año escolar, el grado y la sección.",
                "La sección tiene una capacidad configurada."
            ],
            "main_flow": [
                "1. El sistema recibe el año escolar, el grado y la sección seleccionados.",
                "2. El sistema consulta la capacidad configurada de la sección.",
                "3. El sistema obtiene la cantidad de matrículas ya registradas en esa sección.",
                "4. El sistema calcula las vacantes disponibles.",
                "5. El sistema confirma que existe cupo y devuelve el control a Registrar matrícula."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Sin vacantes:", "En el paso 4, las vacantes disponibles son cero. El sistema devuelve el resultado «sin cupo» a Registrar matrícula, que se detiene y continúa con su flujo alternativo A1."),
                ("Flujo alternativo A2 — Capacidad no configurada o datos inconsistentes:", "En el paso 2, la sección no tiene capacidad configurada o los datos no permiten calcular el cupo. El sistema informa que no puede verificar las vacantes y devuelve un resultado negativo, por lo que no se continúa con la matrícula.")
            ],
            "post": [
                "El sistema devuelve a Registrar matrícula el resultado de la verificación: con cupo o sin cupo.",
                "Este caso de uso solo consulta información y no modifica ningún dato."
            ]
        },
        {
            "id": "CU-E06",
            "name": "Registrar pago en caja",
            "req": "RF-E04 / RF-33",
            "actors": "Primario: Tesorería.",
            "goal": "Registrar el pago que un alumno realiza en caja.",
            "pre": [
                "El usuario está autenticado y tiene permisos de Tesorería.",
                "El alumno está registrado en el sistema.",
                "Existe un concepto de pago pendiente para el alumno."
            ],
            "main_flow": [
                "1. El usuario busca y selecciona al alumno.",
                "2. El sistema muestra los conceptos de pago pendientes del alumno.",
                "3. El usuario selecciona el concepto que se va a pagar e ingresa el monto recibido.",
                "4. El usuario indica la forma de pago (efectivo, Yape, transferencia).",
                "5. El sistema valida el monto y los datos del pago.",
                "6. El usuario confirma el registro del pago.",
                "7. El sistema guarda el pago, actualiza la deuda del alumno y emite el recibo electrónico en PDF."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Alumno sin conceptos pendientes:", "En el paso 2, el alumno no tiene conceptos de pago pendientes. El sistema informa que no hay pagos por registrar y el usuario finaliza la operación o busca a otro alumno."),
                ("Flujo alternativo A2 — Monto inválido:", "En el paso 5, el monto ingresado no es válido o no corresponde al concepto seleccionado. El sistema informa el error y no registra el pago. El usuario corrige el monto o cancela la operación.")
            ],
            "post": [
                "El pago queda registrado en el sistema.",
                "La deuda del alumno se actualiza y puede verse en CU-E07 Consultar deudas."
            ]
        },
        {
            "id": "CU-E07",
            "name": "Consultar deudas",
            "req": "RF-E05 / RF-35, RF-37",
            "actors": "Primario: Tesorería. Secundario: Apoderado (vía consulta web).",
            "goal": "Consultar las deudas pendientes de los alumnos.",
            "pre": [
                "El usuario está autenticado y tiene permisos de Tesorería.",
                "Existen alumnos registrados en el sistema."
            ],
            "main_flow": [
                "1. El usuario selecciona la opción «Consultar deudas».",
                "2. El usuario ingresa el criterio de búsqueda (por ejemplo, DNI o nombre del alumno).",
                "3. El sistema busca al alumno y sus conceptos de pago.",
                "4. El sistema muestra la lista de deudas con el concepto, el monto y el estado.",
                "5. El usuario revisa la información de las deudas."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Alumno no encontrado:", "En el paso 3, no existe un alumno que coincida con el criterio ingresado. El sistema informa que no se encontraron resultados. El usuario modifica el criterio de búsqueda o finaliza la consulta."),
                ("Flujo alternativo A2 — Alumno sin deudas:", "En el paso 4, el alumno no tiene deudas pendientes. El sistema informa que no registra deudas y el usuario finaliza la consulta o busca a otro alumno.")
            ],
            "post": [
                "El sistema muestra la información de deudas del alumno consultado.",
                "La consulta no modifica ningún dato."
            ]
        },
        {
            "id": "UC-001",
            "name": "Autenticar Usuario e Iniciar Sesión",
            "req": "RF-01 / RF-MSC-01",
            "actors": "Primarios: SuperAdmin, Admin, Docente, Tesorería. Secundarios: Base de Datos MySQL, JwtUtil (JJWT 0.12.6).",
            "goal": "Validar credenciales del usuario y emitir token JWT seguro para acceder a las funciones del rol asignado.",
            "pre": [
                "El usuario posee credenciales registradas.",
                "El usuario se encuentra activo (estado = 1) y la suscripción de la escuela está vigente."
            ],
            "main_flow": [
                "1. El usuario ingresa su nombre de usuario y contraseña en la pantalla de inicio de sesión.",
                "2. El sistema busca el registro del usuario por nombre de usuario.",
                "3. El sistema valida la contraseña utilizando el algoritmo criptográfico BCrypt.",
                "4. El sistema comprueba la vigencia de la suscripción institucional.",
                "5. El sistema genera el token JWT con algoritmo HS256 conteniendo los claims de rol, sede e institución.",
                "6. El sistema retorna la respuesta exitosa con el token y redirige al panel correspondiente al rol."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Credenciales incorrectas:", "En el paso 3, la contraseña no coincide o el usuario no existe. El sistema retorna error HTTP 400/401 'Credenciales inválidas' y no genera sesión."),
                ("Flujo alternativo A2 — Cuenta inactiva o suscripción vencida:", "En el paso 4, el usuario tiene estado inactivo o la institución tiene la suscripción vencida. El sistema deniega el acceso con mensaje explicativo.")
            ],
            "post": [
                "El usuario cuenta con un token JWT válido para consumir los servicios del backend.",
                "Se habilita el acceso restringido a la matriz de permisos de su perfil."
            ]
        },
        {
            "id": "UC-013",
            "name": "Asignar Carga Académica Docente",
            "req": "RF-17 / RF-MGD-03",
            "actors": "Primarios: Administrador, Coordinador Académico. Secundario: Base de Datos MySQL.",
            "goal": "Asignar a un docente los cursos y secciones correspondientes al año escolar activo, asegurando la no existencia de cruces de horarios.",
            "pre": [
                "El docente está registrado y activo con su especialidad pedagógica.",
                "El año escolar, los cursos de la malla curricular y las secciones están creados."
            ],
            "main_flow": [
                "1. El administrador selecciona el año escolar y la sección académica.",
                "2. El sistema despliega la lista de cursos obligatorios de la malla curricular.",
                "3. El usuario selecciona el curso a asignar y busca al docente según su especialidad.",
                "4. El usuario define el bloque horario y los días lectivos de dictado.",
                "5. El sistema ejecuta el algoritmo validador de cruces (UC-014) comprobando que ni el docente ni el aula tengan otra clase en ese horario.",
                "6. El usuario confirma la asignación académica.",
                "7. El sistema almacena la asignación y actualiza el cronograma escolar de la sección."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Cruce de horario detectado:", "En el paso 5, el docente o el aula física ya tienen una materia programada en ese bloque y día. El sistema bloquea el guardado y notifica la colisión horaria."),
                ("Flujo alternativo A2 — Especialidad docente incompatible:", "En el paso 3, el docente no cumple el perfil de especialidad requerido. El sistema emite advertencia de confirmación antes de permitir la asignación.")
            ],
            "post": [
                "La carga académica queda formalizada y visible en el panel 'Mis Cursos' del docente.",
                "El horario de la sección queda actualizado sin solapamientos."
            ]
        },
        {
            "id": "UC-023",
            "name": "Registrar Calificaciones y Promedios",
            "req": "RF-22 / RF-MCE-05",
            "actors": "Primarios: Docente / Profesor. Secundarios: Administrador, Base de Datos MySQL.",
            "goal": "Ingresar calificaciones obtenidas por los estudiantes en un periodo escolar y calcular automáticamente los promedios ponderados por área.",
            "pre": [
                "El docente tiene la sección y curso asignados en su carga académica.",
                "El periodo académico (bimestre) se encuentra en estado abierto para ingreso de notas.",
                "Existen alumnos formalmente matriculados en la sección."
            ],
            "main_flow": [
                "1. El docente ingresa a 'Mis Cursos' y selecciona la sección y materia.",
                "2. El sistema muestra la lista de alumnos matriculados y las columnas de criterios de evaluación.",
                "3. El docente ingresa las notas según la escala oficial del MINEDU (AD, A, B, C) o vigesimal.",
                "4. El sistema valida en tiempo real que cada nota pertenezca al rango autorizado.",
                "5. El docente presiona 'Guardar Calificaciones'.",
                "6. El sistema ejecuta algorítmicamente el cálculo del promedio ponderado bimestral.",
                "7. El sistema almacena las notas y muestra la confirmación de guardado exitoso."
            ],
            "alt_flows": [
                ("Flujo alternativo A1 — Nota fuera de rango:", "En el paso 4, el docente ingresa un valor no válido (ej. número negativo o letra inválida). El sistema resalta la casilla en rojo e impide el guardado."),
                ("Flujo alternativo A2 — Periodo de notas cerrado:", "En el paso 1, la fecha actual excede el límite del bimestre. El sistema despliega la planilla en modo 'Solo Lectura'.")
            ],
            "post": [
                "Las calificaciones y promedios ponderados quedan consolidados en la base de datos.",
                "Las libretas y consolidados para apoderados y SIAGIE quedan actualizados."
            ]
        }
    ]

    for spec in uc_specs:
        add_sub_heading(spec["id"], f"— {spec['name']}")
        
        # Tabla de ficha técnica de especificación
        t_spec = doc.add_table(rows=6, cols=2)
        t_spec.alignment = WD_TABLE_ALIGNMENT.CENTER
        set_tbl_borders(t_spec, color="94A3B8")
        spec_w = [Inches(1.8), Inches(4.7)]

        spec_fields = [
            ("Requerimiento Asociado", spec["req"]),
            ("Actores Participantes", spec["actors"]),
            ("Objetivo del Caso", spec["goal"]),
            ("Precondiciones", "\n• ".join([""] + spec["pre"]).strip()),
            ("Flujo Principal de Pasos", "\n".join(spec["main_flow"])),
            ("Postcondiciones", "\n• ".join([""] + spec["post"]).strip())
        ]

        for r_idx, (lbl, val) in enumerate(spec_fields):
            row = t_spec.rows[r_idx]
            c0, c1 = row.cells[0], row.cells[1]
            c0.width = spec_w[0]
            c1.width = spec_w[1]
            set_cell_padding(c0, top=60, bottom=60, left=80, right=80)
            set_cell_padding(c1, top=60, bottom=60, left=80, right=80)

            p0 = c0.paragraphs[0]
            r0 = p0.add_run(lbl)
            r0.font.name = "Calibri"
            r0.font.size = Pt(9.0)
            r0.font.bold = True
            r0.font.color.rgb = NAVY

            p1 = c1.paragraphs[0]
            r1 = p1.add_run(val)
            r1.font.name = "Calibri"
            r1.font.size = Pt(8.5)
            r1.font.color.rgb = DARK

        # Flujos alternativos
        if spec.get("alt_flows"):
            p_alt_hdr = doc.add_paragraph()
            p_alt_hdr.paragraph_format.space_before = Pt(4)
            p_alt_hdr.paragraph_format.space_after = Pt(2)
            p_alt_hdr.paragraph_format.keep_with_next = True
            r_ah = p_alt_hdr.add_run("Flujos Alternativos y Excepciones:")
            r_ah.font.name = "Calibri"
            r_ah.font.size = Pt(9.0)
            r_ah.font.bold = True
            r_ah.font.color.rgb = ROYAL

            for f_title, f_desc in spec["alt_flows"]:
                add_body_p(f_desc, bold_prefix=f"{f_title} ", space_after=2)

        doc.add_paragraph().paragraph_format.space_after = Pt(6)

    # =========================================================================
    # 17. VALIDACIONES DEL SISTEMA Y REGLAS DE NEGOCIO
    # =========================================================================
    add_sec_heading("17", "Validaciones del sistema y reglas de negocio")
    add_body_p(
        "Las validaciones del sistema definen el conjunto de condiciones lógicas, restricciones de integridad referencial, "
        "reglas de negocio y comprobaciones criptográficas que el software aplica rigurosamente en el frontend y en el backend "
        "para garantizar la consistencia absoluta de los datos escolares:"
    )

    add_sub_heading("17.1", "Matriz general de validaciones por módulo")

    t_val = doc.add_table(rows=15, cols=5)
    t_val.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_tbl_borders(t_val, color="94A3B8")
    val_widths = [Inches(1.1), Inches(1.2), Inches(1.8), Inches(1.1), Inches(1.3)]

    val_data = [
        ("Módulo", "Campo / Entidad", "Regla de Validación", "Tipo de Control", "Mensaje / Acción de Error"),
        ("Seguridad", "Contraseña", "Mínimo 8 caracteres, hash BCrypt ($2a$).", "Criptográfico", "Rechaza claves débiles o menores a 8 caracteres."),
        ("Seguridad", "Token JWT", "Firma HS256 válida, vigencia activa, claims de rol/sede.", "Autenticación", "HTTP 401 Unauthorized / Token inválido."),
        ("Seguridad", "Permisos CRUD", "Rol debe tener permiso activo (C, R, U, D) en RolModulo.", "Autorización RBAC", "HTTP 403 Forbidden / Acción no autorizada."),
        ("Infraestructura", "Aforo de Aula", "Capacidad > 0; grado entre 1ero y 6to de primaria.", "Lógica de Rango", "Rechaza aforos negativos o nulos."),
        ("Docencia", "Cruce Horario", "Docente y aula no pueden tener 2 materias en mismo día/hora.", "Validación Algorítmica", "Bloquea asignación y notifica colisión horaria."),
        ("Matrícula", "DNI del Alumno", "Exactamente 8 dígitos numéricos; único en padrón.", "Formato y Unicidad", "Notifica DNI inválido o ya registrado."),
        ("Matrícula", "Vacantes", "matriculas_activas < aforo_maximo de la sección.", "Control de Cupo", "Bloquea matrícula: 'Sección sin vacantes'."),
        ("Matrícula", "Matrícula Única", "Un alumno solo puede tener una matrícula por año escolar.", "Integridad de Negocio", "Impide matrícula duplicada en el mismo año."),
        ("Matrícula", "Apoderado", "Debe existir al menos un apoderado registrado vinculado.", "Exigencia Legal", "Impide formalizar matrícula sin tutor legal."),
        ("Evaluación", "Escala de Notas", "Notas en escala MINEDU (AD, A, B, C) o vigesimal (0-20).", "Validación de Entrada", "Resalta casilla en rojo: 'Nota fuera de rango'."),
        ("Evaluación", "Cálculo Promedio", "Promedio ponderado calculado instantáneamente por backend.", "Cálculo Automático", "Impide alteración manual de promedios."),
        ("Tesorería", "Caja Activa", "Obligatorio tener apertura de caja para registrar cobros.", "Control Operativo", "Bloquea cobro si no hay caja abierta hoy."),
        ("Tesorería", "Monto de Pago", "Monto pagado mayor a cero y no excede deuda del arancel.", "Consistencia Monetaria", "Notifica monto inválido."),
        ("Tesorería", "Arqueo de Caja", "Monto Teórico vs Monto Real en efectivo y transferencias.", "Auditoría Financiera", "Clasifica en Cuadre exacto, Faltante o Sobrante.")
    ]

    for r_idx, row_vals in enumerate(val_data):
        row = t_val.rows[r_idx]
        is_hdr = (r_idx == 0)
        for c_idx, val in enumerate(row_vals):
            cell = row.cells[c_idx]
            cell.width = val_widths[c_idx]
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            set_cell_padding(cell, top=55, bottom=55, left=65, right=65)
            if is_hdr:
                set_cell_bg(cell, "1B365D")
            elif r_idx % 2 == 1:
                set_cell_bg(cell, "F8FAFC")
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_before = Pt(1)
            p.paragraph_format.space_after = Pt(1)
            r = p.add_run(val)
            r.font.name = "Calibri"
            r.font.size = Pt(8.0) if not is_hdr else Pt(8.5)
            if is_hdr:
                r.font.bold = True
                r.font.color.rgb = RGBColor(255, 255, 255)
            else:
                r.font.color.rgb = DARK

    # 17.2 Casos de Prueba de Validación (Test Acceptance Matrix)
    add_sub_heading("17.2", "Casos de prueba de validación y criterios de verificación")
    add_body_p(
        "A continuación se presenta la matriz de casos de prueba ejecutados para certificar que todas las validaciones de "
        "seguridad, negocio y datos operan de manera impecable:"
    )

    t_tests = doc.add_table(rows=8, cols=5)
    t_tests.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_tbl_borders(t_tests, color="94A3B8")
    test_widths = [Inches(0.7), Inches(1.3), Inches(1.6), Inches(1.9), Inches(1.0)]

    test_data = [
        ("ID Test", "Caso de Uso", "Escenario de Prueba", "Comportamiento Esperado", "Resultado"),
        ("VAL-01", "UC-001 (Login)", "Intento de login con contraseña incorrecta.", "Backend deniega acceso con HTTP 401; no emite JWT.", "Aprobado ✅"),
        ("VAL-02", "UC-004 (RBAC)", "Profesor intenta acceder al módulo de Tesorería.", "Sistema bloquea navegación con HTTP 403 Forbidden.", "Aprobado ✅"),
        ("VAL-03", "CU-E01 (DNI)", "Registro de alumno con DNI duplicado.", "Sistema notifica 'DNI ya registrado' y no guarda.", "Aprobado ✅"),
        ("VAL-04", "CU-E02 (RENIEC)", "Consulta por DNI de 8 dígitos válido.", "RENIEC retorna nombres y apellidos; autocompleta formulario.", "Aprobado ✅"),
        ("VAL-05", "CU-E04 (Matrícula)", "Matrícula en sección con vacantes = 0.", "Verificar vacantes devuelve 'Sin Cupo' y bloquea registro.", "Aprobado ✅"),
        ("VAL-06", "UC-013 (Horarios)", "Asignación de docente en hora ya ocupada.", "Algoritmo detecta colisión y cancela la operación.", "Aprobado ✅"),
        ("VAL-07", "CU-E06 (Caja)", "Registro de cobro con caja cerrada.", "Sistema exige apertura previa de caja con saldo base.", "Aprobado ✅")
    ]

    for r_idx, row_vals in enumerate(test_data):
        row = t_tests.rows[r_idx]
        is_hdr = (r_idx == 0)
        for c_idx, val in enumerate(row_vals):
            cell = row.cells[c_idx]
            cell.width = test_widths[c_idx]
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            set_cell_padding(cell, top=60, bottom=60, left=70, right=70)
            if is_hdr:
                set_cell_bg(cell, "1B365D")
            elif r_idx % 2 == 1:
                set_cell_bg(cell, "F8FAFC")
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_before = Pt(1)
            p.paragraph_format.space_after = Pt(1)
            r = p.add_run(val)
            r.font.name = "Calibri"
            r.font.size = Pt(8.0) if not is_hdr else Pt(8.5)
            if is_hdr:
                r.font.bold = True
                r.font.color.rgb = RGBColor(255, 255, 255)
            elif c_idx == 4:
                r.font.bold = True
                r.font.color.rgb = RGBColor(22, 101, 52) # Verde oscuro
            else:
                r.font.color.rgb = DARK

    # Aplicar cantSplit y tblHeader a todas las tablas del documento
    for t in doc.tables:
        for r_idx, r in enumerate(t.rows):
            trPr = r._tr.get_or_add_trPr()
            trPr.append(parse_xml(f'<w:cantSplit {nsdecls("w")}/>'))
            if r_idx == 0:
                trPr.append(parse_xml(f'<w:tblHeader {nsdecls("w")}/>'))

    # Rutas de guardado
    out_path_docs = os.path.join(DOCS_DIR, "Documento_de_Vision_UNSM_SIAE.docx")
    out_path_root = r"c:\xampp\htdocs\Proyecto_Escuela\Documento_de_Vision_UNSM_SIAE.docx"
    doc.save(out_path_docs)
    doc.save(out_path_root)
    print("Documento DOCX generado exitosamente:")
    print("1.", out_path_docs)
    print("2.", out_path_root)

    # Renderizar PDF mediante Word COM
    try:
        import win32com.client
        word = win32com.client.Dispatch("Word.Application")
        word.Visible = False
        in_docx = os.path.abspath(out_path_docs)
        out_pdf = os.path.join(DOCS_DIR, "Documento_de_Vision_UNSM_SIAE.pdf")
        wdoc = word.Documents.Open(in_docx)
        wdoc.SaveAs(out_pdf, FileFormat=17) # 17 = wdFormatPDF
        wdoc.Close(False)
        word.Quit()
        print("3. Versión PDF renderizada exitosamente:", out_pdf)
    except Exception as e:
        print("Aviso al exportar PDF:", e)

if __name__ == "__main__":
    generate_complete_document()
