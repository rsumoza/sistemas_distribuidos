#!/usr/bin/env python3
"""Validador estructural, conceptual y pedagógico de la Clase 06.

No sustituye a XeLaTeX. Detecta documentos truncados, entornos no definidos,
desalineación entre guía y soluciones y ausencia de los elementos que conforman
el contrato pedagógico de la clase.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd().resolve()
ERRORS: list[str] = []

FILES = {
    "slides": ROOT / "slides" / "clase06.tex",
    "notes": ROOT / "apuntes" / "clase06-apuntes.tex",
    "guide": ROOT / "guias" / "clase06-guia.tex",
    "solved": ROOT / "guias_resueltas" / "clase06-guiaresuelta.tex",
    "teacher": ROOT / "docente" / "clase06-docente.tex",
    "worksheet": ROOT / "recursos" / "clase06-ficha-aula.tex",
    "timelines": ROOT / "recursos" / "clase06-timelines-pizarra.tex",
    "style": ROOT / "cls" / "ua-engineering-v6-common.sty",
}


def strip_comments(text: str) -> str:
    lines: list[str] = []
    for line in text.splitlines():
        lines.append(re.split(r"(?<!\\)%", line, maxsplit=1)[0])
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
    for needle in (r"\documentclass", r"\begin{document}", r"\end{document}"):
        require(text, needle, path)
    for env in (
        "document", "frame", "columns", "itemize", "enumerate", "tabular",
        "tikzpicture", "uakeybox", "uainfo", "uawarn", "uaexercise", "uaanswer",
    ):
        begins, ends = count_env(text, env)
        if begins != ends:
            ERRORS.append(f"{path}: entorno {env} desbalanceado ({begins} begin, {ends} end)")
    return text


texts = {k: check_document(k) for k in (
    "slides", "notes", "guide", "solved", "teacher", "worksheet", "timelines"
)}
style = read("style")

# Contrato con el estilo institucional compartido.
used_custom: set[str] = set()
for text in texts.values():
    used_custom.update(re.findall(r"\\begin\{(ua[a-zA-Z0-9_-]+)\}", text))
for env in sorted(used_custom):
    if not re.search(rf"\\newtcolorbox\{{{re.escape(env)}\}}", style):
        ERRORS.append(f"{FILES['style']}: entorno usado pero no definido: {env}")
for forbidden in ("uacheck", "uacase", "uademo", "minted", "pgfplots", "shell-escape"):
    for key, text in texts.items():
        if forbidden in text:
            ERRORS.append(f"{FILES[key]}: dependencia/entorno no permitido: {forbidden}")

slides = texts["slides"]
for needle in ("Diagnóstico", "Predicción", "Evidencias de aprendizaje", "Actividad", "Exit ticket"):
    if not re.search(re.escape(needle), slides, re.IGNORECASE):
        ERRORS.append(f"{FILES['slides']}: falta evidencia pedagógica {needle!r}")
for needle in (
    "Pregunta central", "Caso conductor: CampusShop", "WAL", "MVCC", "Árbol B",
    "EXPLAIN", "LSM-tree", "Filtro de Bloom", "write stall", "write skew",
    "Group commit", "Checkpoint", "Método reusable",
):
    require(slides, needle, FILES["slides"], f"núcleo conceptual {needle!r}")
frame_count = len(re.findall(r"\\begin\{frame\}", slides))
if frame_count < 65:
    ERRORS.append(f"{FILES['slides']}: solo {frame_count} frames; se esperaban al menos 65")

notes = texts["notes"]
for needle in (
    "Propósito y pregunta central", "Cómo estudiar este capítulo",
    "Mapa intuitivo antes del formalismo",
    "Contexto: dónde vive el almacenamiento distribuido",
    "Camino crítico y patrón de entrada/salida", "Caso conductor: CampusShop",
    "Vocabulario y siglas antes del detalle", "WAL y recuperación",
    "Cómo se reconstruye la data", "MVCC", "bloat",
    "Transición desde MVCC: visibilidad no es localización", "Árbol B",
    "EXPLAIN", "LSM-tree", "Filtro de Bloom", "Compactación",
    "Conexión con el Trabajo Final Integrador", "Autoevaluación", "Bibliografía guiada",
):
    require(notes, needle, FILES["notes"], f"sección autocontenida {needle!r}")
word_count = len(re.findall(r"\b[\wÁÉÍÓÚÜÑáéíóúüñ-]+\b", notes))
if word_count < 5600:
    ERRORS.append(f"{FILES['notes']}: extensión insuficiente ({word_count} palabras; mínimo 5600)")

# Correspondencia guía-soluciones.
guide = texts["guide"]
solved = texts["solved"]
exercises = len(re.findall(r"\\begin\{uaexercise\}", guide))
solved_exercises = len(re.findall(r"\\begin\{uaexercise\}", solved))
answers = len(re.findall(r"\\begin\{uaanswer\}", solved))
if exercises != 20:
    ERRORS.append(f"{FILES['guide']}: {exercises} ejercicios; se requieren 20")
if solved_exercises != exercises or answers != exercises:
    ERRORS.append(
        f"{FILES['solved']}: correspondencia inválida: guía={exercises}, "
        f"resueltos={solved_exercises}, respuestas={answers}"
    )
for needle in (
    "Propósito y método de resolución", "Ruta recomendada de uso", "Timeline WAL",
    "Matriz de crashes y reconstrucción completa", "MVCC no implica serializabilidad",
    "De la visibilidad a la localización", "Diagnóstico cuantitativo de compactación",
    "Rúbrica compacta",
):
    require(guide, needle, FILES["guide"], f"componente de guía {needle!r}")

teacher = texts["teacher"]
for needle in (
    "Parte A: guion operativo", "180 minutos", "Frames fuente", "Plan de pizarrón",
    "WAL y recuperación", "Transición suave desde MVCC", "Parte B: dossier técnico",
    "Vacuum, versiones muertas y bloat", "Árbol B, fan-out",
    "30 segundos", "2 minutos", "5 minutos", "Banco de preguntas previsibles",
    "Parte C: evaluación", "Preguntas que puede formular un auditor",
    "Contingencias", "Checklist personal de estudio", "Exit ticket",
):
    require(teacher, needle, FILES["teacher"], f"componente docente {needle!r}")
teacher_words = len(re.findall(r"\b[\wÁÉÍÓÚÜÑáéíóúüñ-]+\b", teacher))
if teacher_words < 6000:
    ERRORS.append(f"{FILES['teacher']}: dossier docente insuficiente ({teacher_words} palabras; mínimo 6000)")

worksheet = texts["worksheet"]
for needle in (
    "Contexto y vocabulario inicial", "Timeline WAL", "Crashes y recuperación",
    "Timeline MVCC", "Transición: MVCC, árbol B y ruta física", "EXPLAIN",
    "LSM-tree", "Compactación y write stall", "Exit ticket",
):
    require(worksheet, needle, FILES["worksheet"], f"recurso de aula {needle!r}")
for needle in ("Timeline WAL", "Timeline MVCC"):
    require(texts["timelines"], needle, FILES["timelines"])

for demo_name in (
    "clase06_wal_recovery.py", "clase06_mvcc_visibility.py",
    "clase06_compaction_capacity.py", "clase06_explain.sql",
    "rocksdb_compaction_metrics_didactica.txt", "README_CLASE06_DEMOS.md",
):
    path = ROOT / "demos" / demo_name
    if not path.is_file():
        ERRORS.append(f"{path}: demo/recurso ausente")

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
