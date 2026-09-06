# Clases 06-09 - versión 11.4 consolidada

Esta entrega está preparada para clases presenciales de 180 minutos y para una auditoría pedagógica/técnica. La estrategia común es:

`caso real -> predicción -> intuición -> formalización -> falla -> evidencia -> decisión -> recuperación`.

## Uso recomendado

- `make validate`: valida estructura y contrato con el estilo.
- `make clase06` ... `make clase09`: compila una clase completa.
- `make all`: compila todos los materiales.
- `make clean`: elimina auxiliares y conserva PDF.

## Ruta de aula

Las diapositivas están etiquetadas:

- **NÚCLEO**: contenido que debe enseñarse.
- **ACTIVIDAD**: producción observable de los estudiantes.
- **EXTENSIÓN**: profundización si el ritmo lo permite.
- **RESPALDO**: casos, métricas o material para preguntas.

No es necesario proyectar linealmente cada página. La guía docente indica qué preservar si falta tiempo.

## Seguridad del repositorio

El parche de integración reemplaza solamente materiales de las clases 06-09, fichas y demos. No sustituye `.cls`, `.sty`, `Makefile`, `.latexmkrc` ni workflows de GitHub.

## Integración en el repositorio principal

```bash
./apply_clases06_09_v11_4.sh \
  "$HOME/Documents/Austral/Asignaturas/Sistemas Distribuidos/2026/sistemas_distribuidos"
```

El instalador genera un respaldo y no modifica .cls, .sty, Makefile ni workflows; sí actualiza el validador específico 06-09. Los `.tex` contienen overrides locales para `Segundo cuatrimestre 2026`, de modo que no es necesario reemplazar `config/course-config.tex` en el repositorio.
