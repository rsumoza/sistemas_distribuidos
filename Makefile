SHELL := /bin/bash

LATEXMK := latexmk
LATEXFLAGS := -xelatex -cd -interaction=nonstopmode -halt-on-error -file-line-error

BUILD_DIR := build
SLIDES_DIR := slides
APUNTES_DIR := apuntes
GUIAS_DIR := guias
GUIASR_DIR := guias_resueltas
DOCENTE_DIR := docente
RUBRICA_DIR := rubrica
DEFENSA_DIR := defensa
TRABAJO_PRACTICO_DIR := trabajo_practico

SLIDES_SRC := $(wildcard $(SLIDES_DIR)/clase*.tex)
APUNTES_SRC := $(wildcard $(APUNTES_DIR)/clase*-apuntes.tex)
GUIAS_SRC := $(wildcard $(GUIAS_DIR)/clase*-guia.tex)
GUIASR_SRC := $(wildcard $(GUIASR_DIR)/clase*-guiaresuelta.tex)
DOCENTE_SRC := $(wildcard $(DOCENTE_DIR)/clase*-docente.tex)
RUBRICA_SRC := $(wildcard $(RUBRICA_DIR)/*.tex)
DEFENSA_SRC := $(wildcard $(DEFENSA_DIR)/*.tex)
TRABAJO_PRACTICO_SRC := $(TRABAJO_PRACTICO_DIR)/enunciado.tex

SLIDES_PDF := $(patsubst $(SLIDES_DIR)/%.tex,$(BUILD_DIR)/slides/%.pdf,$(SLIDES_SRC))
APUNTES_PDF := $(patsubst $(APUNTES_DIR)/%.tex,$(BUILD_DIR)/apuntes/%.pdf,$(APUNTES_SRC))
GUIAS_PDF := $(patsubst $(GUIAS_DIR)/%.tex,$(BUILD_DIR)/guias/%.pdf,$(GUIAS_SRC))
GUIASR_PDF := $(patsubst $(GUIASR_DIR)/%.tex,$(BUILD_DIR)/guias_resueltas/%.pdf,$(GUIASR_SRC))
DOCENTE_PDF := $(patsubst $(DOCENTE_DIR)/%.tex,$(BUILD_DIR)/docente/%.pdf,$(DOCENTE_SRC))
RUBRICA_PDF := $(patsubst $(RUBRICA_DIR)/%.tex,$(BUILD_DIR)/rubrica/%.pdf,$(RUBRICA_SRC))
DEFENSA_PDF := $(patsubst $(DEFENSA_DIR)/%.tex,$(BUILD_DIR)/defensa/%.pdf,$(DEFENSA_SRC))
TRABAJO_PRACTICO_PDF := $(patsubst $(TRABAJO_PRACTICO_DIR)/%.tex,$(BUILD_DIR)/trabajo_practico/%.pdf,$(TRABAJO_PRACTICO_SRC))

ALL_PDF := $(SLIDES_PDF) $(APUNTES_PDF) $(GUIAS_PDF) $(GUIASR_PDF) \
           $(DOCENTE_PDF) $(RUBRICA_PDF) $(DEFENSA_PDF) $(TRABAJO_PRACTICO_PDF)

CLASES := 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16
CLASS_TARGETS := $(addprefix clase,$(CLASES))

.PHONY: all slides apuntes guias guias_resueltas docente rubrica defensa trabajo_practico \
        validate dirs clean clean-aux distclean fix-times help $(CLASS_TARGETS)

all: validate $(ALL_PDF)
	@$(MAKE) --no-print-directory clean-aux
	@echo "OK: curso completo; build/ conserva únicamente PDF."

slides: validate $(SLIDES_PDF)
	@$(MAKE) --no-print-directory clean-aux

apuntes: validate $(APUNTES_PDF)
	@$(MAKE) --no-print-directory clean-aux

guias: validate $(GUIAS_PDF)
	@$(MAKE) --no-print-directory clean-aux

guias_resueltas: validate $(GUIASR_PDF)
	@$(MAKE) --no-print-directory clean-aux

docente: validate $(DOCENTE_PDF)
	@$(MAKE) --no-print-directory clean-aux

rubrica: validate $(RUBRICA_PDF)
	@$(MAKE) --no-print-directory clean-aux

defensa: validate $(DEFENSA_PDF)
	@$(MAKE) --no-print-directory clean-aux

trabajo_practico: validate $(TRABAJO_PRACTICO_PDF)
	@$(MAKE) --no-print-directory clean-aux

validate:
	@python3 tools/validate_tex.py

dirs:
	@mkdir -p \
		"$(BUILD_DIR)/slides" \
		"$(BUILD_DIR)/apuntes" \
		"$(BUILD_DIR)/guias" \
		"$(BUILD_DIR)/guias_resueltas" \
		"$(BUILD_DIR)/docente" \
		"$(BUILD_DIR)/rubrica" \
		"$(BUILD_DIR)/defensa" \
		"$(BUILD_DIR)/trabajo_practico"

$(BUILD_DIR)/slides/%.pdf: $(SLIDES_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/slides" "$<"

$(BUILD_DIR)/apuntes/%.pdf: $(APUNTES_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/apuntes" "$<"

$(BUILD_DIR)/guias/%.pdf: $(GUIAS_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/guias" "$<"

$(BUILD_DIR)/guias_resueltas/%.pdf: $(GUIASR_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/guias_resueltas" "$<"

$(BUILD_DIR)/docente/%.pdf: $(DOCENTE_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/docente" "$<"

$(BUILD_DIR)/rubrica/%.pdf: $(RUBRICA_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/rubrica" "$<"

$(BUILD_DIR)/defensa/%.pdf: $(DEFENSA_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/defensa" "$<"

$(BUILD_DIR)/trabajo_practico/%.pdf: $(TRABAJO_PRACTICO_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir="../$(BUILD_DIR)/trabajo_practico" "$<"

define CLASS_TARGET
clase$(1): validate
	@$$(MAKE) --no-print-directory \
		$$(BUILD_DIR)/slides/clase$(1).pdf \
		$$(BUILD_DIR)/apuntes/clase$(1)-apuntes.pdf \
		$$(BUILD_DIR)/guias/clase$(1)-guia.pdf \
		$$(BUILD_DIR)/guias_resueltas/clase$(1)-guiaresuelta.pdf \
		$$(BUILD_DIR)/docente/clase$(1)-docente.pdf
	@$$(MAKE) --no-print-directory clean-aux
	@echo "OK: clase$(1) compilada; se conservaron únicamente sus PDF."
endef

$(foreach c,$(CLASES),$(eval $(call CLASS_TARGET,$(c))))

clean-aux:
	@if [ -d "$(BUILD_DIR)" ]; then \
		find "$(BUILD_DIR)" -type f ! -name '*.pdf' -delete; \
		find "$(BUILD_DIR)" -type d -empty -delete 2>/dev/null || true; \
	fi
	@find "$(SLIDES_DIR)" "$(APUNTES_DIR)" "$(GUIAS_DIR)" \
		"$(GUIASR_DIR)" "$(DOCENTE_DIR)" "$(RUBRICA_DIR)" "$(DEFENSA_DIR)" \
		"$(TRABAJO_PRACTICO_DIR)" \
		-type f \( \
		-name '*.aux' -o -name '*.log' -o -name '*.nav' -o -name '*.out' \
		-o -name '*.toc' -o -name '*.snm' -o -name '*.fls' \
		-o -name '*.fdb_latexmk' -o -name '*.vrb' -o -name '*.xdv' \
		-o -name '*.synctex.gz' -o -name '*.bcf' -o -name '*.run.xml' \
		-o -name '*.bbl' -o -name '*.blg' -o -name '*.lof' -o -name '*.lot' \
		\) -delete

clean: clean-aux
	@echo "Auxiliares eliminados; los PDF fueron preservados."

distclean:
	@rm -rf "$(BUILD_DIR)"
	@echo "Build completo eliminado."

# Ejecutar una sola vez si los archivos del ZIP quedaron fechados en el futuro.
fix-times:
	@find . -path './.git' -prune -o -path './build' -prune -o -type f -exec touch {} +
	@find . -path './.git' -prune -o -path './build' -prune -o -type d -exec touch {} +
	@echo "Marcas de tiempo normalizadas con el reloj actual del sistema."

help:
	@echo "make all"
	@echo "make slides | apuntes | guias | guias_resueltas | docente"
	@echo "make rubrica | defensa | trabajo_practico"
	@echo "make clase01 ... make clase16"
	@echo "make clean       # conserva PDF"
	@echo "make distclean   # elimina build completo"
	@echo "make fix-times   # corrige clock skew tras descomprimir"
