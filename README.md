# Mapa Limpio · San Roque, Corrientes

Un mapa hecho entre vecinos y municipio para saber dónde hay basura acumulada (microbasurales) y organizarse para sacarla.

**Probala acá:** https://javierlegal-up.github.io/sistema-basural-san-roque/

> Versión de prueba. Los puntos del mapa son ejemplos y los datos se guardan solo en el navegador de cada persona.

## Qué se puede hacer

- **Reportar** un punto con basura: ubicación en el mapa, tipo (domiciliarios, poda, escombros, voluminosos), tamaño y foto.
- **Seguir el estado** de cada punto:
  - 🔴 Reportado
  - 🟡 Limpieza programada
  - 🟢 Limpio
- **Sumarse a una limpieza** y compartir el punto por WhatsApp.
- **Ver un resumen** con estadísticas, que se puede imprimir o guardar como PDF.
- **Exportar los datos** a planilla (CSV) o a mapa (GeoJSON, para QGIS).
- **Guardar y juntar respaldos** para hacer un relevamiento entre varias personas.
- **Leer información** sobre salud (dengue, leptospirosis), normativa y seguridad antes de limpiar.

## Modo Municipalidad (demo)

En el celular: pestaña **Más** → "Soy de la Municipalidad". En la computadora: ícono del edificio, arriba al lado del buscador. Después entrá como encargado. Ahí hay tres pantallas:

- **Bandeja:** los reclamos de los vecinos, ordenados por prioridad (dengue, tamaño, días de espera y cantidad de vecinos).
- **Recorrido de hoy:** la ruta en orden, con km, tiempo y m³ estimados. Se puede ver en el mapa o abrir en Google Maps.
- **Cuadrilla:** la vista del chofer, parada por parada, con "Cómo llegar" y "Hecho + foto".

Presentación para mandar en PDF: [presentacion.html](presentacion.html). Abrila en el navegador y tocá "Guardar como PDF".

## Cómo usarla

- **En el celular o en la compu:** abrí el link de arriba.
- **Sin internet para instalar nada:** descargá el repositorio y hacé doble clic en `INICIAR.bat` (Windows), o abrí `index.html` en Chrome o Edge.

## Tecnología

Un solo archivo `index.html` que usa:

- [Leaflet](https://leafletjs.com/) para el mapa.
- [Tailwind CSS](https://tailwindcss.com/) para el diseño.
- Nominatim (OpenStreetMap) para buscar calles.
- `localStorage` del navegador para guardar los datos.

## Próximos pasos

El plan completo para llegar a producción (base de datos compartida, usuarios, panel municipal y piloto) está en [PLAN-PRODUCCION.md](PLAN-PRODUCCION.md).
