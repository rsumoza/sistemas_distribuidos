# Sistemas Distribuidos - Clase 06 v11.12.1

## Hotfix de compatibilidad editorial con el validador global

Esta revisión conserva las diapositivas y el contenido técnico de v11.12. Corrige la incompatibilidad entre los encabezados editoriales de los apuntes/guía y el contrato literal del validador global del repositorio.

Cambios:

- se incorpora una sección sustantiva `Cómo estudiar este capítulo`;
- se incorpora una sección sustantiva `Mapa intuitivo antes del formalismo`;
- se renombra `Ruta recomendada` como `Ruta recomendada de uso`;
- el validador específico de la Clase 06 comprueba ahora esos mismos componentes.

No se modifican los archivos `.cls`, el `.sty`, el `Makefile` del repositorio ni los workflows de GitHub.

## Instalación del hotfix mínimo

```bash
unzip hotfix_clase06_v11_12_1_validator.zip
cd hotfix_clase06_v11_12_1_validator
./apply_hotfix_clase06_v11_12_1.sh "/ruta/al/repositorio"
```

Después:

```bash
cd "/ruta/al/repositorio"
make validate
make clase06
```

## Validación

```text
VALIDATION_STATUS=PASS
NOTES_WORDS=7281
GUIDE_EXERCISES=20
SOLVED_ANSWERS=20
CUSTOM_ENV_CONTRACT=PASS
```

Los dos documentos modificados fueron compilados con XeLaTeX:

- `build/apuntes/clase06-apuntes.pdf`: 24 páginas;
- `build/guias/clase06-guia.pdf`: 7 páginas.
