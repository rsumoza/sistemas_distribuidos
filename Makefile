SHELL := /bin/bash

LATEXMK := latexmk
LATEXFLAGS := -xelatex -cd -interaction=nonstopmode -halt-on-error -file-line-error
BUILD_DIR := build
CLASSES := 06 07 08 09

SLIDES_SRC := $(foreach c,$(CLASSES),slides/clase$(c).tex)
NOTES_SRC := $(foreach c,$(CLASSES),apuntes/clase$(c)-apuntes.tex)
GUIDES_SRC := $(foreach c,$(CLASSES),guias/clase$(c)-guia.tex)
SOLVED_SRC := $(foreach c,$(CLASSES),guias_resueltas/clase$(c)-guiaresuelta.tex)
TEACHER_SRC := $(foreach c,$(CLASSES),docente/clase$(c)-docente.tex)
WORKSHEET_SRC := $(foreach c,$(CLASSES),recursos/clase$(c)-ficha-aula.tex)
EXTRA_RESOURCE_SRC := recursos/clase06-timelines-pizarra.tex

SLIDES_PDF := $(patsubst slides/%.tex,$(BUILD_DIR)/slides/%.pdf,$(SLIDES_SRC))
NOTES_PDF := $(patsubst apuntes/%.tex,$(BUILD_DIR)/apuntes/%.pdf,$(NOTES_SRC))
GUIDES_PDF := $(patsubst guias/%.tex,$(BUILD_DIR)/guias/%.pdf,$(GUIDES_SRC))
SOLVED_PDF := $(patsubst guias_resueltas/%.tex,$(BUILD_DIR)/guias_resueltas/%.pdf,$(SOLVED_SRC))
TEACHER_PDF := $(patsubst docente/%.tex,$(BUILD_DIR)/docente/%.pdf,$(TEACHER_SRC))
WORKSHEET_PDF := $(patsubst recursos/%.tex,$(BUILD_DIR)/recursos/%.pdf,$(WORKSHEET_SRC))
EXTRA_RESOURCE_PDF := $(patsubst recursos/%.tex,$(BUILD_DIR)/recursos/%.pdf,$(EXTRA_RESOURCE_SRC))
ALL_PDF := $(SLIDES_PDF) $(NOTES_PDF) $(GUIDES_PDF) $(SOLVED_PDF) $(TEACHER_PDF) $(WORKSHEET_PDF) $(EXTRA_RESOURCE_PDF)

.PHONY: all validate slides apuntes guias guias_resueltas docente recursos \
        clase06 clase07 clase08 clase09 clean clean-aux distclean fix-times help

all: validate $(ALL_PDF)
	@$(MAKE) --no-print-directory clean-aux
	@echo "OK: clases 06-09 compiladas; build/ conserva únicamente PDF."

validate:
	@python3 tools/validate_clases06_09.py .

slides: $(SLIDES_PDF)
	@$(MAKE) --no-print-directory clean-aux
apuntes: $(NOTES_PDF)
	@$(MAKE) --no-print-directory clean-aux
guias: $(GUIDES_PDF)
	@$(MAKE) --no-print-directory clean-aux
guias_resueltas: $(SOLVED_PDF)
	@$(MAKE) --no-print-directory clean-aux
docente: $(TEACHER_PDF)
	@$(MAKE) --no-print-directory clean-aux
recursos: $(WORKSHEET_PDF) $(EXTRA_RESOURCE_PDF)
	@$(MAKE) --no-print-directory clean-aux

define CLASS_TARGET
clase$(1): validate \
  $(BUILD_DIR)/slides/clase$(1).pdf \
  $(BUILD_DIR)/apuntes/clase$(1)-apuntes.pdf \
  $(BUILD_DIR)/guias/clase$(1)-guia.pdf \
  $(BUILD_DIR)/guias_resueltas/clase$(1)-guiaresuelta.pdf \
  $(BUILD_DIR)/docente/clase$(1)-docente.pdf \
  $(BUILD_DIR)/recursos/clase$(1)-ficha-aula.pdf $(if $(filter 06,$(1)),$(BUILD_DIR)/recursos/clase06-timelines-pizarra.pdf,)
	@$$(MAKE) --no-print-directory clean-aux
	@echo "OK: clase$(1) compilada."
endef
$(foreach c,$(CLASSES),$(eval $(call CLASS_TARGET,$(c))))

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
	     -o -name '*.fdb_latexmk' -o -name '*.xdv' -o -name '*.synctex.gz' \) -delete 2>/dev/null || true
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
	  'make all               Compila todos los materiales auditados 06-09' \
	  'make clase06           Compila clase 06 y timelines' \
	  'make clase07           Compila los seis materiales de clase 07' \
	  'make clase08           Compila los seis materiales de clase 08' \
	  'make clase09           Compila los seis materiales de clase 09' \
	  'make validate          Valida estructura, densidad y contrato con el .sty' \
	  'make clean             Elimina auxiliares y conserva PDF' \
	  'make distclean         Elimina build/ completo'
