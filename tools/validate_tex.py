from pathlib import Path
import sys,re
root=Path(__file__).resolve().parents[1]
errors=[]
folders=['slides','apuntes','guias','guias_resueltas','docente']
for folder in folders:
    files=sorted((root/folder).glob('*.tex'))
    if len(files)!=16: errors.append(f'{folder}: se esperaban 16 archivos y hay {len(files)}')
    for p in files:
        s=p.read_text(errors='replace')
        rel=p.relative_to(root)
        for token in (r'\documentclass',r'\begin{document}',r'\end{document}'):
            if token not in s: errors.append(f'{rel}: falta {token}')
        for env in ('itemize','enumerate','frame','uaexercise','uaanswer','tikzpicture'):
            b=len(re.findall(r'\\begin\{'+env+r'\}',s)); e=len(re.findall(r'\\end\{'+env+r'\}',s))
            if b!=e: errors.append(f'{rel}: {env} desbalanceado ({b}/{e})')
        if folder=='apuntes' and len(s)<8000: errors.append(f'{rel}: apuntes demasiado breves ({len(s)} caracteres)')
        if folder=='guias':
            n=len(re.findall(r'\\begin\{uaexercise\}',s))
            if n!=20: errors.append(f'{rel}: se esperaban 20 ejercicios y hay {n}')
        if folder=='guias_resueltas':
            q=len(re.findall(r'\\begin\{uaexercise\}',s)); a=len(re.findall(r'\\begin\{uaanswer\}',s))
            if q!=20 or a!=20: errors.append(f'{rel}: se esperaban 20 ejercicios/20 respuestas y hay {q}/{a}')
        if folder=='docente':
            for marker in ('Arquitectura didáctica v9','Preguntas socráticas','Criterios de evaluación formativa'):
                if marker not in s: errors.append(f'{rel}: falta sección {marker}')
        if folder=='slides':
            m=re.search(r'clase(\d\d)',p.name); num=int(m.group(1)) if m else 0
            frames=len(re.findall(r'\\begin\{frame\}',s))
            if num>=6 and frames<18: errors.append(f'{rel}: solo {frames} frames; mínimo 18 desde clase 6')
if errors:
    print('VALIDATION_STATUS=FAIL')
    print('\n'.join(errors)); sys.exit(2)
print('VALIDATION_STATUS=PASS')
