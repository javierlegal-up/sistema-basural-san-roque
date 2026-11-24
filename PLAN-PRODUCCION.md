# Mapa Limpio: plan para llegar a producción

**Situación actual:** demo funcional en un solo archivo (`index.html`). Los datos se guardan solo en el navegador de cada persona, no hay usuarios, no hay servidor y las fotos no se comparten.

**Objetivo:** una app web que funcione en cualquier celular, donde lo que reporta un vecino lo vean todos, y que el municipio pueda usar para planificar el trabajo.

---

## Resumen de fases

| Fase | Qué se logra | Duración estimada |
|---|---|---|
| 0. Validación | Saber si vecinos y municipio la van a usar | 2–3 semanas |
| 1. MVP real | App con base de datos compartida, fotos y usuarios | 4–6 semanas |
| 2. Piloto en San Roque | Uso real en 1 o 2 barrios, ajustes | 6–8 semanas |
| 3. Panel municipal | Herramientas para la Municipalidad | 3–4 semanas |
| 4. Escala | Otras localidades, mejoras, sostenibilidad | continuo |

Los plazos suponen una o dos personas trabajando a tiempo parcial.

---

## Fase 0: Validación (antes de programar más)

La tecnología es la parte fácil. El riesgo real es que nadie la use o que el municipio no retire la basura.

- [ ] Mostrar la demo a 15–20 vecinos de distintos barrios y anotar qué entienden y qué no.
- [ ] Reunión con la Municipalidad de San Roque:
  - ¿Quién recibe los reportes? ¿Hay un área de Servicios Públicos o de Ambiente?
  - ¿Cómo se pide hoy el retiro de poda, escombros y voluminosos? ¿Qué días?
  - ¿Están dispuestos a mandar el camión a las jornadas programadas?
  - ¿Les sirve que los datos se puedan exportar (planilla, mapa)?
- [ ] Sumar 2 o 3 organizaciones aliadas: escuela, club, parroquia o centro de salud (este último por el tema del dengue).
- [ ] Definir el nombre definitivo y comprobar que el dominio esté libre (ej. `mapalimpio.com.ar` en NIC Argentina).
- [ ] Hacer un relevamiento a pie de los basurales existentes para cargarlos al inicio. **El mapa no puede arrancar vacío.**

**Entregable:** una lista de cambios priorizados y un compromiso (aunque sea informal) del municipio.

---

## Fase 1: MVP real

### Arquitectura recomendada (bajo costo, poco mantenimiento)

| Pieza | Opción sugerida | Por qué |
|---|---|---|
| Frontend | React + Vite (o Next.js) como **PWA** | Se instala en el celular como app, sin pasar por Play Store |
| Base de datos | **Supabase** (PostgreSQL + PostGIS) | Plan gratuito para empezar; consultas geográficas; usuarios y fotos incluidos |
| Fotos | Supabase Storage | Integrado, con límites por usuario |
| Usuarios | Supabase Auth: link por email o Google | Sin contraseñas, simple para gente no técnica |
| Hosting | Vercel, Netlify o Cloudflare Pages | Gratis en esta escala, HTTPS automático |
| Mapas | MapTiler, Stadia Maps o Protomaps (alojado propio) | Las teselas de OpenStreetMap.org **no se pueden usar** en una app en producción; estos tienen planes gratuitos o baratos |

Alternativa si hay alguien que maneje servidores: backend propio (Node o Python) + PostgreSQL/PostGIS en un VPS.

### Tareas

- [ ] Pasar la demo a un proyecto con componentes (formulario, mapa, ficha, lista).
- [ ] Modelo de datos:
  - `reportes`: ubicación (punto PostGIS), tipo, tamaño, estado, descripción, referencia y fechas.
  - `fotos`: antes y después.
  - `jornadas`: fecha, hora, punto de encuentro y organizador.
  - `voluntarios`: usuario + jornada.
  - `historial_estados`: quién cambió qué y cuándo.
  - `usuarios`: rol vecino, organizador, municipio o admin.
- [ ] **Reglas de permisos** (clave para que no se rompa):
  - Cualquiera puede **ver** el mapa sin registrarse.
  - Para **reportar** o **anotarse** hay que iniciar sesión.
  - **Programar fecha**: el que reportó, un organizador o el municipio.
  - **Marcar limpio**: exige una foto del "después". Lo confirma un organizador o el municipio, o tres vecinos distintos.
- [ ] Subida de fotos con compresión en el celular (máx. ~1 MB) y **borrado de los datos GPS/EXIF** de la imagen, por privacidad.
- [ ] Geolocalización real con permiso del usuario. Marcar en el mapa queda como alternativa.
- [ ] **Detección de duplicados:** si hay otro reporte a menos de 50 m, preguntar "¿Es este?".
- [ ] Modo sin conexión básico: guardar el reporte en el celular y enviarlo cuando vuelve la señal (importante en zonas con mala cobertura).
- [ ] Compartir por WhatsApp con un link directo al punto (`/punto/123`) que muestre vista previa con foto.

---

## Fase 2: Piloto en San Roque

- [ ] Lanzar en 1 o 2 barrios con las organizaciones aliadas.
- [ ] Hacer la **primera jornada** de limpieza en persona, con fotos del antes y después, y difundirla. Es la mejor publicidad.
- [ ] Difusión:
  - Cartel con QR en almacenes, escuela, centro de salud y club.
  - Radio local y grupos de WhatsApp del barrio.
  - Página de Facebook del municipio.
- [ ] Canal de ayuda: un número de WhatsApp para quien no se anime a usar la app.
- [ ] Medir:
  - Reportes por semana.
  - % de reportes que llegan a limpieza.
  - Días promedio entre "reportado" y "limpio".
  - Cantidad de voluntarios distintos.
  - Puntos que se vuelven a ensuciar.
- [ ] Reunión de revisión cada 2 semanas con los aliados.

---

## Fase 3: Panel municipal

- [ ] Vista para el municipio con filtros por barrio, tipo y antigüedad.
- [ ] Estado adicional **"En gestión municipal"** (ej. camión asignado).
- [ ] Asignar un reporte a una cuadrilla y fijar fecha de retiro.
- [ ] Exportar a planilla (CSV/Excel) y a GeoJSON para usar en QGIS.
- [ ] Mapa de calor: dónde se repiten los basurales. Sirve para decidir dónde poner contenedores, carteles o un punto de acopio.
- [ ] Informe mensual automático: reportes, limpiezas, toneladas estimadas y tiempo de respuesta.
- [ ] Notificaciones (push web o email): "tu reporte fue programado", "mañana es la jornada", "el punto que reportaste quedó limpio".

---

## Fase 4: Escala y sostenibilidad

- [ ] Configuración por localidad (límites, contactos y días de recolección) para sumar otros municipios de Corrientes.
- [ ] Capa informativa: puntos de acopio, recuperadores urbanos y días de recolección por zona.
- [ ] Reconocimientos simples: insignia de "vecino que limpió 5 puntos" o ranking por barrio (con cuidado, sin exponer datos personales).
- [ ] Vincular con campañas de descacharrado del área de salud (temporada de dengue).
- [ ] Datos abiertos: publicar estadísticas anónimas.
- [ ] Buscar financiamiento:
  - Convenio con el municipio.
  - Programas provinciales o nacionales de ambiente.
  - Fundaciones o empresas locales (RSE).
  - Concursos de innovación cívica.

---

## Aspectos legales y de privacidad

- **Ley 25.326 de Protección de Datos Personales:**
  - Pedir solo los datos necesarios.
  - Tener una política de privacidad clara.
  - Permitir que el usuario borre su cuenta.
  - No mostrar emails ni teléfonos públicamente.
- **Términos de uso:**
  - Prohibido acusar o identificar a personas en reportes o fotos.
  - Se borran fotos con caras o patentes visibles (o se difuminan automáticamente).
  - Los reportes son información ciudadana, no denuncias formales.
- **Responsabilidad en jornadas:**
  - Aclarar que la participación es voluntaria.
  - Mostrar las recomendaciones de seguridad antes de anotarse.
  - Si el municipio co-organiza, evaluar un seguro para voluntarios.
- **Moderación:**
  - Botón "reportar contenido".
  - Revisión de fotos nuevas por un admin durante el piloto.
  - Límite de reportes por usuario por día.

---

## Calidad y seguridad técnica

- [ ] HTTPS en todo (lo da el hosting).
- [ ] Reglas de acceso en la base de datos (Row Level Security en Supabase). **No confiar solo en el frontend.**
- [ ] Límite de tamaño y tipo de archivo en fotos.
- [ ] Protección contra spam (captcha invisible tipo Cloudflare Turnstile).
- [ ] Copias de seguridad automáticas de la base.
- [ ] Monitoreo de errores (ej. Sentry, plan gratuito).
- [ ] Pruebas en celulares de gama baja y conexión 3G lenta. Es el caso real de muchos usuarios.
- [ ] Accesibilidad: textos grandes, buen contraste y botones fáciles de tocar.

---

## Costos aproximados de arranque

En la escala de un piloto (cientos de usuarios) casi todo entra en planes gratuitos:

| Concepto | Costo |
|---|---|
| Hosting web | Gratis |
| Supabase | Gratis al inicio; plan pago si crece |
| Mapas (MapTiler/Stadia) | Gratis hasta cierto volumen |
| Dominio `.com.ar` | Arancel anual de NIC Argentina |
| Carteles con QR, impresión | Bajo |
| Guantes y bolsas para jornadas | Gestionar con municipio o donaciones |

**El costo principal es el tiempo de las personas**, no la tecnología.

---

## Riesgos principales

| Riesgo | Cómo mitigarlo |
|---|---|
| Se reporta pero nadie retira la basura | Acuerdo previo con el municipio; no lanzar sin eso |
| Mapa vacío al inicio, nadie lo usa | Cargar relevamiento propio antes del lanzamiento |
| Reportes falsos o con agresiones | Login obligatorio, moderación, términos claros |
| El basural vuelve a aparecer | Darle uso al espacio (plantar, cartel); opción "reabrir" |
| Depende de una sola persona | Documentar todo; sumar a la escuela técnica o la universidad |

---

## Próximos 3 pasos concretos

1. Mostrar la demo actual a la Municipalidad y a 2 organizaciones del barrio. Anotar todo.
2. Hacer el relevamiento de basurales existentes (foto + ubicación) en un barrio.
3. Con eso, arrancar la Fase 1 con Supabase y convertir la demo en una PWA.
