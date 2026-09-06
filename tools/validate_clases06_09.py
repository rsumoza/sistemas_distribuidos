#!/usr/bin/env python3
"""Validador estructural y pedagógico para las clases auditadas 06-09."""
from __future__ import annotations
import argparse, re, sys
from collections import Counter
from pathlib import Path

CLASSES=("06","07","08","09")
DOCS={
 "slides":"slides/clase{c}.tex",
 "apuntes":"apuntes/clase{c}-apuntes.tex",
 "guias":"guias/clase{c}-guia.tex",
 "resueltas":"guias_resueltas/clase{c}-guiaresuelta.tex",
 "docente":"docente/clase{c}-docente.tex",
 "ficha":"recursos/clase{c}-ficha-aula.tex",
}
REQUIRED_TEACHER=(
 "Parte A: guion operativo","Parte B: dossier técnico","Parte C: auditoría",
 "Objetivo pedagógico profundo","Resultados de aprendizaje","180 minutos",
 "Preparación previa","Plan de pizarrón","Guion de apertura","intuición",
 "Demostraciones","Preguntas socráticas","Errores previsibles",
 "evaluación formativa","Contingencias","Trabajo Final Integrador",
 "exit ticket","Dossier técnico de preparación del docente",
 "Cómo explicar los conceptos en tres profundidades",
 "Banco de preguntas previsibles","Preguntas que puede formular un auditor pedagógico",
 "Checklist personal de estudio","Matriz de corrección y preguntas de defensa",
)
REQUIRED_NOTES_GROUPS=(
 ("Mapa intuitivo antes del formalismo","Cinco intuiciones antes del detalle"),
 ("Método",), ("Errores",), ("Bibliografía guiada",),
 ("Trabajo Final Integrador",), ("Glosario operativo",),
 ("Autoevaluación",), ("Síntesis final",), ("Cómo estudiar este capítulo",),
)
SLIDE_EVIDENCE=("Diagnóstico","Predicción","Actividad","Exit ticket","Evidencias de aprendizaje")


def strip_comments(text:str)->str:
 out=[]
 for line in text.splitlines():
  m=re.search(r"(?<!\\)%",line)
  out.append(line[:m.start()] if m else line)
 return "\n".join(out)

def word_count(text:str)->int:
 clean=strip_comments(text)
 clean=re.sub(r"\\[A-Za-z@]+\*?(?:\[[^\]]*\])?"," ",clean)
 return len(re.findall(r"\b[\wÁÉÍÓÚÜÑáéíóúüñ-]+\b",clean))

def defined_envs(text:str)->set[str]:
 pats=(r"\\newtcolorbox\{([^}]+)\}",r"\\newenvironment\{([^}]+)\}",r"\\NewDocumentEnvironment\{([^}]+)\}")
 out=set()
 for p in pats: out.update(re.findall(p,text))
 return out

def check_balance(path:Path,text:str,errors:list[str]):
 clean=strip_comments(text)
 b=Counter(re.findall(r"\\begin\{([^}]+)\}",clean)); e=Counter(re.findall(r"\\end\{([^}]+)\}",clean))
 for env in sorted(set(b)|set(e)):
  if b[env]!=e[env]: errors.append(f"{path}: entorno {env!r} desbalanceado (begin={b[env]}, end={e[env]})")

def main()->int:
 ap=argparse.ArgumentParser(); ap.add_argument("root",nargs="?",default="."); ns=ap.parse_args()
 root=Path(ns.root).resolve(); errors=[]; warnings=[]
 style=root/"cls/ua-engineering-v6-common.sty"
 if not style.exists():
  errors.append(f"Falta {style}"); envs=set()
 else: envs=defined_envs(style.read_text(encoding="utf-8"))
 for c in CLASSES:
  loaded={}
  for kind,tpl in DOCS.items():
   p=root/tpl.format(c=c)
   if not p.exists(): errors.append(f"Falta {p}"); continue
   t=p.read_text(encoding="utf-8"); loaded[kind]=(p,t)
   if "\\documentclass" not in t: errors.append(f"{p}: falta \\documentclass")
   if "\\begin{document}" not in t or "\\end{document}" not in t: errors.append(f"{p}: documento incompleto")
   check_balance(p,t,errors)
   used=set(re.findall(r"\\begin\{(ua[A-Za-z0-9@_-]+)\}",strip_comments(t)))
   for env in sorted(used-envs): errors.append(f"{p}: usa entorno institucional {env!r} no definido en el .sty")
  if "slides" in loaded:
   p,t=loaded["slides"]; frames=t.count("\\begin{frame}"); wc=word_count(t)
   if frames<40: errors.append(f"{p}: solo {frames} frames; se esperaban >=40 para 180 min")
   if wc<2400: errors.append(f"{p}: contenido demasiado breve ({wc} palabras)")
   for needle in SLIDE_EVIDENCE:
    if needle.lower() not in t.lower(): errors.append(f"{p}: falta evidencia pedagógica {needle!r}")
  if "apuntes" in loaded:
   p,t=loaded["apuntes"]; wc=word_count(t)
   if wc<3000: errors.append(f"{p}: apuntes no autocontenidos según umbral ({wc}<3000)")
   for group in REQUIRED_NOTES_GROUPS:
    if not any(n.lower() in t.lower() for n in group):
     errors.append(f"{p}: falta componente editorial alternativo {group!r}")
  if "guias" in loaded:
   p,t=loaded["guias"]; n=t.count("\\begin{uaexercise}"); wc=word_count(t)
   if n!=20: errors.append(f"{p}: se esperaban 20 ejercicios y hay {n}")
   if wc<850: errors.append(f"{p}: ejercicios demasiado breves ({wc}<850)")
   if "Ruta recomendada de uso".lower() not in t.lower(): errors.append(f"{p}: falta ruta de uso")
  if "resueltas" in loaded:
   p,t=loaded["resueltas"]; ne=t.count("\\begin{uaexercise}"); na=t.count("\\begin{uaanswer}"); wc=word_count(t)
   if ne!=20 or na!=20: errors.append(f"{p}: correspondencia inválida ejercicios={ne}, respuestas={na}")
   if wc<1900: errors.append(f"{p}: soluciones demasiado breves ({wc}<1900)")
   if "Criterio de autocorrección".lower() not in t.lower(): errors.append(f"{p}: falta criterio de autocorrección")
  if "docente" in loaded:
   p,t=loaded["docente"]; wc=word_count(t)
   if wc<3500: errors.append(f"{p}: guía docente demasiado breve ({wc}<3500)")
   for n in REQUIRED_TEACHER:
    if n.lower() not in t.lower(): errors.append(f"{p}: falta componente docente {n!r}")
  if "ficha" in loaded:
   p,t=loaded["ficha"]; wc=word_count(t)
   if wc<350: errors.append(f"{p}: ficha de aula demasiado breve ({wc}<350)")
 # Stable-repo constraints
 sources="\n".join((root/tpl.format(c=c)).read_text(encoding="utf-8") for c in CLASSES for tpl in DOCS.values() if (root/tpl.format(c=c)).exists())
 for forbidden in ("minted","pgfplots","uacheck","uacase","uademo"):
  if forbidden in sources: warnings.append(f"Se encontró {forbidden!r}; revisar compatibilidad")
 for w in warnings: print("WARNING:",w)
 if errors:
  print("VALIDATION_STATUS=FAIL")
  for e in errors: print("ERROR:",e)
  return 1
 print("VALIDATION_STATUS=PASS")
 print("CLASSES=06,07,08,09")
 print("GUIDES=20 exercises per class")
 print("SOLVED=20 matched student answers; rubrics moved to teacher guides")
 print("TEACHER_GUIDES=technical dossier + audit questions")
 print("CUSTOM_ENV_CONTRACT=PASS")
 return 0
if __name__=="__main__": sys.exit(main())
