#!/usr/bin/env bash
set -euo pipefail

find build -type f -name '*.pdf' -print | sort > build/pdf-files.txt
zip -q "build/release.zip" -@ < build/pdf-files.txt

echo "PDFs packed."
