# Animania — Bopeebo (Hard) para Snake Engine

**Contenido jugable configurado:** una sola canción, `bopeebo-animania`, con dificultad `Hard`. La entrada de Freeplay está en `weeks/bopeebo-animania.json`; el chart está en `data/bopeebo-animania/bopeebo-animania-hard.json`.

## Audio
- `Inst.adp`: instrumental original convertido a SADP/IMA-ADPCM.
- `Voices.adp`: mezcla mono de los stems originales de voces de BF (versión Hard) y Dad, manteniendo su alineación temporal.

## Personajes y escenario
- BF y Dad usan hojas Sparrow 1024×1024 hechas a partir de poses completas reconstruidas disponibles en el material de trabajo: idle y una pose por dirección. **No conservan todas las fases de animación del rig Animate original.**
- Girlfriend usa el personaje base `gf` del engine porque las poses reconstruidas disponibles para la GF de Animania estaban incompletas.
- El escenario usa capas estáticas de `mainStageAmTake`; crowd y elementos animados del escenario no están integrados en esta versión.

## Verificación y limitaciones
Se validaron la estructura de archivos, JSON, rutas de audio y escenario, formato del chart para las lanes absolutas del parser, cabeceras SADP, duración del audio y dimensiones de las hojas de personajes. **No se ha ejecutado dentro de Snake Engine ni probado en una Nintendo 3DS**, así que no puedo garantizar aún que Freeplay, posiciones, texturas y reproducción funcionen en hardware. Este ZIP es un candidato de integración, no una build certificada.
