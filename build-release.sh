#!/usr/bin/env bash
set -euo pipefail

build_dir="${BUILD_DIR:-build}"
pdf_list="$(mktemp)"
trap 'rm -f "$pdf_list"' EXIT

if [[ ! -d "$build_dir" ]]; then
  echo "::error::No existe el directorio $build_dir. Ejecutá make all antes de armar el release."
  exit 1
fi

if [[ ! -w "$build_dir" ]] && command -v sudo >/dev/null 2>&1; then
  sudo chown -R "$(id -u):$(id -g)" "$build_dir"
fi

if [[ ! -w "$build_dir" ]]; then
  echo "::error::No se puede escribir en $build_dir."
  ls -ld "$build_dir"
  exit 1
fi

if ! command -v zip >/dev/null 2>&1; then
  echo "::error::zip no está instalado en el runner."
  exit 1
fi

find "$build_dir" -type f -name '*.pdf' -print | sort > "$pdf_list"
pdf_count="$(wc -l < "$pdf_list" | tr -d ' ')"

if [[ "$pdf_count" -eq 0 ]]; then
  echo "::error::No se encontraron PDFs en $build_dir."
  exit 1
fi

zip -q "$build_dir/release.zip" -@ < "$pdf_list"

echo "PDFs packed: $pdf_count files in $build_dir/release.zip"
