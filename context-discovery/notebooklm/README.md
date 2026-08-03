# Volcado de NotebookLM — Notebook "TryPRI"

Contenido descargado íntegramente del notebook de NotebookLM **TryPRI**
(`4a792919-0e3e-41f5-ac85-e12fc382b911`, compartido — no somos propietarios).

Fecha de descarga: **2026-07-27** · Herramienta: `notebooklm-py` v0.7.3

## Contenido

### `reports/` — Artefactos generados en NotebookLM (3)

| Archivo | Título original | Artifact ID |
|---|---|---|
| [01-especificacion-requerimientos.md](reports/01-especificacion-requerimientos.md) | Especificación de Requerimientos: Sistema Inteligente de Administración de Préstamos | `3b767bc3-…` |
| [02-sistema-inteligente-prestamos-ia.md](reports/02-sistema-inteligente-prestamos-ia.md) | Sistema Inteligente de Administración de Préstamos con IA | `421c1fa3-…` |
| [03-guia-maestra-trycontroller.md](reports/03-guia-maestra-trycontroller.md) | Guía Maestra de Operación y Control Estratégico: Plataforma TryController | `a0a0470e-…` |

### `sources/` — Texto completo de las 3 fuentes del notebook

| Archivo | Fuente | Tipo | Caracteres |
|---|---|---|---|
| [00-guias-resumen.md](sources/00-guias-resumen.md) | Resúmenes + keywords que NotebookLM genera por fuente | — | — |
| [01-requirements-gdoc.md](sources/01-requirements-gdoc.md) | "Requirements" | Google Doc | 7.142 |
| [02-webinar-clientes-ventas-limite.md](sources/02-webinar-clientes-ventas-limite.md) | Webinar: crear clientes, ventas con límite, notificaciones, histórico de llaves, venta temporal ([YouTube](https://www.youtube.com/live/SKScNik4e_Q)) | Transcripción | 18.489 |
| [03-webinar-trabajador-renovaciones.md](sources/03-webinar-trabajador-renovaciones.md) | Webinar: crear trabajador, desvincular dispositivo, pagos con límite, renovaciones, venta directa ([YouTube](https://www.youtube.com/watch?v=fhNKbtDQNyw)) | Transcripción | 19.116 |

Cada fuente está también en `.json` crudo (tal como la devuelve la API) junto al `.md`.

### `chat/` — Historial de conversación

[historial.md](chat/historial.md) — los 5 turnos completos de preguntas y respuestas
(conversación `c44df9b3-…`), incluida la petición que originó `requirements.md`.
El `.json` conserva la estructura original.

## Derivados en la raíz de `context-discovery/`

- `requirements.md` ← copia del reporte 01 (era un archivo vacío).
- `funcionalidad.md` ← lista consolidada de funcionalidades (turno 3 del chat; era un archivo vacío).

## Cómo volver a sincronizar

```bash
NB=4a792919-0e3e-41f5-ac85-e12fc382b911
notebooklm artifact list --notebook $NB --json
notebooklm source list --notebook $NB --json
notebooklm download report ./salida.md -a <artifact_id> -n $NB
notebooklm source fulltext <source_id> --notebook $NB --json
```

> Nota: el notebook **no tiene notas** (`note list` → 0) ni artefactos de audio,
> vídeo, quiz, flashcards, mapa mental, infografía o slide-deck. Los 3 reportes
> de arriba son todo lo generado.
