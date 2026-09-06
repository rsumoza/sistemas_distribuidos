#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 /ruta/a/la/raiz/del/repositorio" >&2
  exit 2
fi

ROOT=$(cd "$1" && pwd)
HERE=$(cd "$(dirname "$0")" && pwd)

for required in slides apuntes guias guias_resueltas docente recursos cls config; do
  if [[ ! -d "$ROOT/$required" ]]; then
    echo "ERROR: '$ROOT' no parece ser la raíz esperada; falta $required/" >&2
    exit 3
  fi
done

stamp=$(date +%Y%m%d_%H%M%S)
backup="$ROOT/.backup_clases06_09_v11_4_$stamp"
mkdir -p "$backup"

copy_with_backup() {
  local rel=$1
  mkdir -p "$backup/$(dirname "$rel")" "$ROOT/$(dirname "$rel")"
  if [[ -f "$ROOT/$rel" ]]; then
    cp -a "$ROOT/$rel" "$backup/$rel"
  fi
  cp -a "$HERE/$rel" "$ROOT/$rel"
  touch "$ROOT/$rel"
}

for c in 06 07 08 09; do
  copy_with_backup "slides/clase${c}.tex"
  copy_with_backup "apuntes/clase${c}-apuntes.tex"
  copy_with_backup "guias/clase${c}-guia.tex"
  copy_with_backup "guias_resueltas/clase${c}-guiaresuelta.tex"
  copy_with_backup "docente/clase${c}-docente.tex"
  copy_with_backup "recursos/clase${c}-ficha-aula.tex"
done
copy_with_backup "recursos/clase06-timelines-pizarra.tex"

mkdir -p "$ROOT/demos" "$ROOT/tools"
for f in "$HERE"/demos/*; do
  [[ -f "$f" ]] || continue
  rel="demos/$(basename "$f")"
  copy_with_backup "$rel"
done

# Este validador forma parte del contrato de los documentos v11.4 y es el
# invocado por el Makefile del paquete. Se respalda antes de reemplazar.
copy_with_backup "tools/validate_clases06_09.py"
cp -a "$HERE/tools/validate_clases06_09.py" "$ROOT/tools/validate_clases06_09_v11_4.py"
touch "$ROOT/tools/validate_clases06_09_v11_4.py"

printf '\nInstalación v11.4 completada.\n'
printf 'Respaldo: %s\n' "$backup"
printf 'No se modificaron .cls, .sty, Makefile, .latexmkrc, config/ ni .github/.\n\n'

python3 "$ROOT/tools/validate_clases06_09_v11_4.py" "$ROOT"

cat <<'MSG'

Siguiente secuencia recomendada:
  make clase06
  make clase07
  make clase08
  make clase09
  make all
MSG
