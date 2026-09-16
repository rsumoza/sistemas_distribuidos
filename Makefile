SHELL := /bin/bash

LATEXMK := latexmk
LATEXFLAGS := -xelatex -cd -interaction=nonstopmode -halt-on-error -file-line-error
BUILD_DIR := build

SLIDES_PDF := $(BUILD_DIR)/slides/clase07.pdf
NOTES_PDF := $(BUILD_DIR)/apuntes/clase07-apuntes.pdf
GUIDE_PDF := $(BUILD_DIR)/guias/clase07-guia.pdf
SOLVED_PDF := $(BUILD_DIR)/guias_resueltas/clase07-guiaresuelta.pdf
TEACHER_PDF := $(BUILD_DIR)/docente/clase07-docente.pdf
WORKSHEET_PDF := $(BUILD_DIR)/recursos/clase07-ficha-aula.pdf
TIMELINES_PDF := $(BUILD_DIR)/recursos/clase07-timelines-pizarra.pdf
ALL_PDF := $(SLIDES_PDF) $(NOTES_PDF) $(GUIDE_PDF) $(SOLVED_PDF) \
           $(TEACHER_PDF) $(WORKSHEET_PDF) $(TIMELINES_PDF)

.PHONY: all clase07 validate slides apuntes guia guia_resuelta docente recursos \
        demos clean clean-aux distclean fix-times help

all: validate $(ALL_PDF)
	@$(MAKE) --no-print-directory clean-aux
	@echo "OK: Clase 07 compilada; build/ conserva únicamente PDF."

clase07: all

validate:
	@python3 tools/validate_clase07.py .

slides: validate $(SLIDES_PDF)
	@$(MAKE) --no-print-directory clean-aux
apuntes: validate $(NOTES_PDF)
	@$(MAKE) --no-print-directory clean-aux
guia: validate $(GUIDE_PDF)
	@$(MAKE) --no-print-directory clean-aux
guia_resuelta: validate $(SOLVED_PDF)
	@$(MAKE) --no-print-directory clean-aux
docente: validate $(TEACHER_PDF)
	@$(MAKE) --no-print-directory clean-aux
recursos: validate $(WORKSHEET_PDF) $(TIMELINES_PDF)
	@$(MAKE) --no-print-directory clean-aux

demos:
	@set -e; \
	for script in demos/clase07_*.py; do \
	  echo "==> $$script"; \
	  python3 "$$script"; \
	  echo; \
	done

$(BUILD_DIR)/slides/%.pdf: slides/%.tex | $(BUILD_DIR)/slides
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/slides" "$<"

$(BUILD_DIR)/apuntes/%.pdf: apuntes/%.tex | $(BUILD_DIR)/apuntes
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/apuntes" "$<"

$(BUILD_DIR)/guias/%.pdf: guias/%.tex | $(BUILD_DIR)/guias
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/guias" "$<"

$(BUILD_DIR)/guias_resueltas/%.pdf: guias_resueltas/%.tex | $(BUILD_DIR)/guias_resueltas
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/guias_resueltas" "$<"

$(BUILD_DIR)/docente/%.pdf: docente/%.tex | $(BUILD_DIR)/docente
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/docente" "$<"

$(BUILD_DIR)/recursos/%.pdf: recursos/%.tex | $(BUILD_DIR)/recursos
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/recursos" "$<"

$(BUILD_DIR)/slides $(BUILD_DIR)/apuntes $(BUILD_DIR)/guias \
$(BUILD_DIR)/guias_resueltas $(BUILD_DIR)/docente $(BUILD_DIR)/recursos:
	@mkdir -p "$@"

clean-aux:
	@if [[ -d "$(BUILD_DIR)" ]]; then \
	  find "$(BUILD_DIR)" -type f ! -name '*.pdf' -delete; \
	  find "$(BUILD_DIR)" -type d -empty -delete 2>/dev/null || true; \
	fi
	@find slides apuntes guias guias_resueltas docente recursos -maxdepth 1 -type f \
	  \( -name '*.aux' -o -name '*.log' -o -name '*.nav' -o -name '*.snm' \
	     -o -name '*.toc' -o -name '*.out' -o -name '*.fls' \
	     -o -name '*.fdb_latexmk' -o -name '*.xdv' -o -name '*.synctex.gz' \) \
	  -delete 2>/dev/null || true

clean: clean-aux
	@echo "Auxiliares eliminados; los PDF se conservaron."

distclean:
	@rm -rf "$(BUILD_DIR)"
	@echo "build/ eliminado, incluidos sus PDF."

fix-times:
	@find . -path './.git' -prune -o -type f -exec touch {} +
	@echo "Timestamps normalizados."

help:
	@printf '%s\n' \
	  'make all              Compila los siete documentos de la Clase 07' \
	  'make clase07          Alias de make all' \
	  'make slides           Compila solo las diapositivas' \
	  'make apuntes          Compila solo los apuntes' \
	  'make guia             Compila solo la guía de ejercicios' \
	  'make guia_resuelta    Compila solo la guía resuelta' \
	  'make docente          Compila solo la guía docente' \
	  'make recursos         Compila la ficha y los timelines' \
	  'make demos            Ejecuta las demostraciones Python' \
	  'make validate         Verifica estructura y contrato pedagógico' \
	  'make clean            Elimina auxiliares y conserva PDF' \
	  'make distclean        Elimina build/ completo'
