#!/usr/bin/env python3
"""Validador estructural y pedagógico para la Clase 07.

No sustituye a XeLaTeX: detecta temprano documentos truncados, entornos
institucionales no soportados, desalineaciones entre guía y soluciones, y la
ausencia de evidencias pedagógicas que forman parte del contrato de la clase.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd().resolve()
ERRORS: list[str] = []

FILES = {
    "slides": ROOT / "slides" / "clase07.tex",
    "notes": ROOT / "apuntes" / "clase07-apuntes.tex",
    "guide": ROOT / "guias" / "clase07-guia.tex",
    "solved": ROOT / "guias_resueltas" / "clase07-guiaresuelta.tex",
    "teacher": ROOT / "docente" / "clase07-docente.tex",
    "worksheet": ROOT / "recursos" / "clase07-ficha-aula.tex",
    "timelines": ROOT / "recursos" / "clase07-timelines-pizarra.tex",
    "style": ROOT / "cls" / "ua-engineering-v6-common.sty",
}


def strip_comments(text: str) -> str:
    lines: list[str] = []
    for line in text.splitlines():
        # A percent sign escaped with backslash is not a comment marker.
        parts = re.split(r"(?<!\\)%", line, maxsplit=1)
        lines.append(parts[0])
    return "\n".join(lines)


def read(key: str) -> str:
    path = FILES[key]
    if not path.is_file():
        ERRORS.append(f"{path}: archivo ausente")
        return ""
    return path.read_text(encoding="utf-8")


def require(text: str, needle: str, path: Path, label: str | None = None) -> None:
    if needle not in text:
        ERRORS.append(f"{path}: falta {label or repr(needle)}")


def count_env(text: str, env: str) -> tuple[int, int]:
    return (
        len(re.findall(rf"\\begin\{{{re.escape(env)}\}}", text)),
        len(re.findall(rf"\\end\{{{re.escape(env)}\}}", text)),
    )


def check_document(key: str) -> str:
    raw = read(key)
    text = strip_comments(raw)
    path = FILES[key]
    if not text:
        return text
    require(text, r"\documentclass", path)
    require(text, r"\begin{document}", path)
    require(text, r"\end{document}", path)
    if text.find(r"\begin{document}") > text.find(r"\end{document}"):
        ERRORS.append(f"{path}: orden inválido de begin/end document")
    for env in ("document", "frame", "columns", "itemize", "enumerate", "tabular", "tikzpicture", "uakeybox", "uainfo", "uawarn", "uaexercise", "uaanswer"):
        begins, ends = count_env(text, env)
        if begins != ends:
            ERRORS.append(f"{path}: entorno {env} desbalanceado ({begins} begin, {ends} end)")
    return text


texts = {k: check_document(k) for k in ("slides", "notes", "guide", "solved", "teacher", "worksheet", "timelines")}
style = read("style")

# Contrato con el estilo: solo se permiten entornos ya definidos.
used_custom = set()
for key, text in texts.items():
    for env in re.findall(r"\\begin\{(ua[a-zA-Z0-9_-]+)\}", text):
        used_custom.add(env)
for env in sorted(used_custom):
    if not re.search(rf"\\newtcolorbox\{{{re.escape(env)}\}}", style):
        ERRORS.append(f"{FILES['style']}: entorno usado pero no definido: {env}")
for forbidden in ("uacheck", "uacase", "uademo", "minted", "pgfplots"):
    for key, text in texts.items():
        if forbidden in text:
            ERRORS.append(f"{FILES[key]}: dependencia/entorno no permitido en este paquete: {forbidden}")

# Slides: evidencias de arquitectura pedagógica.
slides = texts["slides"]
for needle in ("Diagnóstico", "Predicción", "Evidencias de aprendizaje", "Actividad", "Exit ticket"):
    require(slides, needle, FILES["slides"], f"evidencia pedagógica {needle!r}")
for needle in (
    "Pregunta central",
    "Puente desde la clase 6",
    "Caso conductor: CampusShop",
    "Vocabulario previo",
    "Partición",
    "committed offset",
    "At-most-once",
    "At-least-once",
    "Exactly-once",
    "Transactional outbox",
    "Watermark",
    "Asteria",
):
    require(slides, needle, FILES["slides"], f"núcleo conceptual {needle!r}")
frame_count = len(re.findall(r"\\begin\{frame\}", slides)) + len(re.findall(r"\\begin\{frame\}\[plain\]", slides))
if frame_count < 55:
    ERRORS.append(f"{FILES['slides']}: solo {frame_count} frames; se esperaban al menos 55")

# Apuntes: autocontenidos y coherentes con slides.
notes = texts["notes"]
for needle in (
    "Propósito y pregunta central",
    "Contexto: del WAL local al log compartido",
    "CampusShop",
    "Vocabulario",
    "Topics, particiones y orden",
    "Offset: progreso durable",
    "Exactly-once",
    "Transactional outbox",
    "Event time",
    "Watermark",
    "Método reusable de diseño",
    "Bibliografía guiada",
    "Autoevaluación",
):
    require(notes, needle, FILES["notes"], f"sección autocontenida {needle!r}")
word_count = len(re.findall(r"\b[\wÁÉÍÓÚÜÑáéíóúüñ-]+\b", notes))
if word_count < 3800:
    ERRORS.append(f"{FILES['notes']}: extensión insuficiente ({word_count} palabras; mínimo 3800)")

# Guía y soluciones: correspondencia uno a uno.
guide = texts["guide"]
solved = texts["solved"]
exercises = len(re.findall(r"\\begin\{uaexercise\}", guide))
solved_exercises = len(re.findall(r"\\begin\{uaexercise\}", solved))
answers = len(re.findall(r"\\begin\{uaanswer\}", solved))
if exercises != 20:
    ERRORS.append(f"{FILES['guide']}: {exercises} ejercicios; se requieren 20")
if solved_exercises != exercises or answers != exercises:
    ERRORS.append(
        f"{FILES['solved']}: correspondencia inválida: ejercicios guía={exercises}, "
        f"ejercicios resueltos={solved_exercises}, respuestas={answers}"
    )
for needle in ("Ruta recomendada de uso", "Método esperado de resolución", "Criterios de entrega"):
    require(guide, needle, FILES["guide"])

# Guía docente: guion, dossier y auditoría.
teacher = texts["teacher"]
for needle in (
    "Parte A",
    "Parte A: guion operativo",
    "180 minutos",
    "Parte B",
    "Dossier técnico",
    "Parte C",
    "Parte C: auditoría",
    "Preguntas socráticas",
    "Errores previsibles",
    "Contingencias",
    "30 segundos",
    "2 minutos",
    "5 minutos",
    "Exit ticket",
):
    require(teacher, needle, FILES["teacher"], f"componente docente {needle!r}")
teacher_words = len(re.findall(r"\b[\wÁÉÍÓÚÜÑáéíóúüñ-]+\b", teacher))
if teacher_words < 4300:
    ERRORS.append(f"{FILES['teacher']}: dossier docente insuficiente ({teacher_words} palabras; mínimo 4300)")

# Recursos de aula y demos.
for needle in ("Intuiciones", "Particiones y keys", "Timeline de offset y crash", "Frontera de exactly-once", "Dual write y outbox", "Event time", "Diagnóstico de lag", "Exit ticket"):
    require(texts["worksheet"], needle, FILES["worksheet"])
for needle in ("Particiones, keys y orden local", "Publicación, réplica y condición de ACK", "Consumo, efecto, committed offset y crash", "Dual write, outbox, relay e inbox"):
    require(texts["timelines"], needle, FILES["timelines"])
for demo in (
    ROOT / "demos" / "clase07_offsets.py",
    ROOT / "demos" / "clase07_event_time.py",
    ROOT / "demos" / "clase07_particiones_lag.py",
    ROOT / "demos" / "clase07_outbox_inbox.py",
):
    if not demo.is_file():
        ERRORS.append(f"{demo}: demo ausente")

if ERRORS:
    print("VALIDATION_STATUS=FAIL")
    for error in ERRORS:
        print(f"ERROR: {error}")
    raise SystemExit(1)

print("VALIDATION_STATUS=PASS")
print(f"SLIDES_FRAMES={frame_count}")
print(f"NOTES_WORDS={word_count}")
print(f"GUIDE_EXERCISES={exercises}")
print(f"SOLVED_ANSWERS={answers}")
print(f"TEACHER_GUIDE_WORDS={teacher_words}")
print("CUSTOM_ENV_CONTRACT=PASS")
