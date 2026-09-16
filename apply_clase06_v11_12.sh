#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  ./apply_clase06_v11_12.sh "/ruta/al/repositorio"

El script crea un respaldo y reemplaza únicamente materiales de la Clase 06.
No modifica cls/, archivos .sty, Makefile, .latexmkrc, config/ ni workflows de GitHub.
USAGE
}

if [[ $# -ne 1 ]]; then
  usage >&2
  exit 2
fi

REPO=$1
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if [[ ! -d "$REPO" ]]; then
  echo "ERROR: no existe el directorio: $REPO" >&2
  exit 2
fi

# Señales mínimas de que se recibió la raíz del curso.
if [[ ! -d "$REPO/slides" || ! -d "$REPO/config" || ! -d "$REPO/cls" ]]; then
  echo "ERROR: la ruta no parece ser la raíz del repositorio del curso." >&2
  echo "Se esperaban los directorios slides/, config/ y cls/." >&2
  exit 2
fi

STAMP=$(date +%Y%m%d_%H%M%S)
BACKUP="$REPO/.backups/clase06_v11_12_$STAMP"
mkdir -p "$BACKUP"

FILES=(
  "slides/clase06.tex"
  "apuntes/clase06-apuntes.tex"
  "guias/clase06-guia.tex"
  "guias_resueltas/clase06-guiaresuelta.tex"
  "docente/clase06-docente.tex"
  "recursos/clase06-ficha-aula.tex"
  "recursos/clase06-timelines-pizarra.tex"
  "demos/clase06_wal_recovery.py"
  "demos/clase06_mvcc_visibility.py"
  "demos/clase06_compaction_capacity.py"
  "demos/clase06_explain.sql"
  "demos/rocksdb_compaction_metrics_didactica.txt"
  "demos/README_CLASE06_DEMOS.md"
)

for rel in "${FILES[@]}"; do
  src="$SCRIPT_DIR/$rel"
  dst="$REPO/$rel"

  if [[ ! -f "$src" ]]; then
    echo "ERROR: falta en el parche: $rel" >&2
    exit 3
  fi

  mkdir -p "$(dirname -- "$dst")"
  if [[ -f "$dst" ]]; then
    mkdir -p "$(dirname -- "$BACKUP/$rel")"
    cp -p -- "$dst" "$BACKUP/$rel"
  fi
  cp -p -- "$src" "$dst"
done

# El validador específico se instala con nombre propio para no reemplazar el global.
mkdir -p "$REPO/tools"
cp -p -- "$SCRIPT_DIR/tools/validate_clase06.py" \
  "$REPO/tools/validate_clase06_v11_12.py"

# Evitar clock skew después de descomprimir/copiar.
for rel in "${FILES[@]}" "tools/validate_clase06_v11_12.py"; do
  [[ -e "$REPO/$rel" ]] && touch -- "$REPO/$rel"
done

echo "Instalación completada."
echo "Respaldo: $BACKUP"

echo
echo "Validación específica de la Clase 06:"
python3 "$REPO/tools/validate_clase06_v11_12.py" "$REPO"

if [[ -f "$REPO/Makefile" ]]; then
  echo
echo "Validación global del repositorio:"
  if make -C "$REPO" --no-print-directory validate; then
    echo "Validación global: PASS"
  else
    echo "ADVERTENCIA: la validación global falló. El respaldo quedó disponible en:" >&2
    echo "$BACKUP" >&2
    exit 4
  fi
fi

echo
echo "Siguiente paso recomendado:"
echo "  cd \"$REPO\""
echo "  make clase06"
