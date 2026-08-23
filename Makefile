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

SLIDES_SRC := $(wildcard $(SLIDES_DIR)/clase*.tex)
APUNTES_SRC := $(wildcard $(APUNTES_DIR)/clase*-apuntes.tex)
GUIAS_SRC := $(wildcard $(GUIAS_DIR)/clase*-guia.tex)
GUIASR_SRC := $(wildcard $(GUIASR_DIR)/clase*-guiaresuelta.tex)
DOCENTE_SRC := $(wildcard $(DOCENTE_DIR)/clase*-docente.tex)
RUBRICA_SRC := $(wildcard $(RUBRICA_DIR)/*.tex)
DEFENSA_SRC := $(wildcard $(DEFENSA_DIR)/*.tex)

SLIDES_PDF := $(patsubst $(SLIDES_DIR)/%.tex,$(BUILD_DIR)/slides/%.pdf,$(SLIDES_SRC))
APUNTES_PDF := $(patsubst $(APUNTES_DIR)/%.tex,$(BUILD_DIR)/apuntes/%.pdf,$(APUNTES_SRC))
GUIAS_PDF := $(patsubst $(GUIAS_DIR)/%.tex,$(BUILD_DIR)/guias/%.pdf,$(GUIAS_SRC))
GUIASR_PDF := $(patsubst $(GUIASR_DIR)/%.tex,$(BUILD_DIR)/guias_resueltas/%.pdf,$(GUIASR_SRC))
DOCENTE_PDF := $(patsubst $(DOCENTE_DIR)/%.tex,$(BUILD_DIR)/docente/%.pdf,$(DOCENTE_SRC))
RUBRICA_PDF := $(patsubst $(RUBRICA_DIR)/%.tex,$(BUILD_DIR)/rubrica/%.pdf,$(RUBRICA_SRC))
DEFENSA_PDF := $(patsubst $(DEFENSA_DIR)/%.tex,$(BUILD_DIR)/defensa/%.pdf,$(DEFENSA_SRC))

ALL_PDF := $(SLIDES_PDF) $(APUNTES_PDF) $(GUIAS_PDF) $(GUIASR_PDF) \
           $(DOCENTE_PDF) $(RUBRICA_PDF) $(DEFENSA_PDF)

CLASES := 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16
CLASS_TARGETS := $(addprefix clase,$(CLASES)) $(foreach n,1 2 3 4 5 6 7 8 9,clase$(n))

# Variables de clase y tipo admitidas (ejemplos: make slides CLASE=01, make apuntes C=5, make CLASE=1 TIPO=guia)
CLASE_RAW := $(strip $(or $(CLASE),$(clase),$(CLASS),$(class),$(C),$(c),$(N),$(n),$(NUM),$(num)))
TIPO_RAW  := $(strip $(or $(TIPO),$(tipo),$(TYPE),$(type),$(T),$(t)))

ifneq ($(CLASE_RAW),)
  CLASE_NUM := $(shell echo "$(CLASE_RAW)" | sed -E 's/^[a-zA-Z_-]*//; s/^0*//' | awk '{if ($$1=="") $$1=0; printf "%02d", $$1}')
  ifeq ($(filter $(CLASE_NUM),$(CLASES)),)
    $(error Clase '$(CLASE_RAW)' no válida. Las clases disponibles son: $(CLASES))
  endif
endif

ifdef CLASE_NUM
  TARGET_SLIDES  := $(BUILD_DIR)/slides/clase$(CLASE_NUM).pdf
  TARGET_APUNTES := $(BUILD_DIR)/apuntes/clase$(CLASE_NUM)-apuntes.pdf
  TARGET_GUIAS   := $(BUILD_DIR)/guias/clase$(CLASE_NUM)-guia.pdf
  TARGET_GUIASR  := $(BUILD_DIR)/guias_resueltas/clase$(CLASE_NUM)-guiaresuelta.pdf
  TARGET_DOCENTE := $(BUILD_DIR)/docente/clase$(CLASE_NUM)-docente.pdf
  TARGET_ALL     := $(TARGET_SLIDES) $(TARGET_APUNTES) $(TARGET_GUIAS) $(TARGET_GUIASR) $(TARGET_DOCENTE)
else
  TARGET_SLIDES  := $(SLIDES_PDF)
  TARGET_APUNTES := $(APUNTES_PDF)
  TARGET_GUIAS   := $(GUIAS_PDF)
  TARGET_GUIASR  := $(GUIASR_PDF)
  TARGET_DOCENTE := $(DOCENTE_PDF)
  TARGET_ALL     := $(ALL_PDF)
endif

ifneq ($(TIPO_RAW),)
  ifeq ($(filter $(TIPO_RAW),slides slide),$(TIPO_RAW))
    TARGET_MAIN := $(TARGET_SLIDES)
  else ifeq ($(filter $(TIPO_RAW),apuntes apunte),$(TIPO_RAW))
    TARGET_MAIN := $(TARGET_APUNTES)
  else ifeq ($(filter $(TIPO_RAW),guias guia),$(TIPO_RAW))
    TARGET_MAIN := $(TARGET_GUIAS)
  else ifeq ($(filter $(TIPO_RAW),guias_resueltas guia_resuelta guias-resueltas guia-resuelta guiaresuelta guiasresueltas resueltas resuelta),$(TIPO_RAW))
    TARGET_MAIN := $(TARGET_GUIASR)
  else ifeq ($(filter $(TIPO_RAW),docente),$(TIPO_RAW))
    TARGET_MAIN := $(TARGET_DOCENTE)
  else ifeq ($(filter $(TIPO_RAW),rubrica),$(TIPO_RAW))
    TARGET_MAIN := $(RUBRICA_PDF)
  else ifeq ($(filter $(TIPO_RAW),defensa),$(TIPO_RAW))
    TARGET_MAIN := $(DEFENSA_PDF)
  else ifeq ($(filter $(TIPO_RAW),all todo todos),$(TIPO_RAW))
    TARGET_MAIN := $(TARGET_ALL)
  else
    $(error Tipo '$(TIPO_RAW)' no válido. Tipos disponibles: slides, apuntes, guias, guias_resueltas, docente, rubrica, defensa, all)
  endif
else
  TARGET_MAIN := $(TARGET_ALL)
endif

.PHONY: all slides slide apuntes apunte guias guia guias_resueltas guia_resuelta guiaresuelta docente rubrica defensa \
        validate dirs clean clean-aux distclean fix-times help $(CLASS_TARGETS)

all: validate $(TARGET_MAIN)
	@$(MAKE) --no-print-directory clean-aux
	@echo "OK: curso completo; build/ conserva únicamente PDF."

slides slide: validate $(TARGET_SLIDES)
	@$(MAKE) --no-print-directory clean-aux

apuntes apunte: validate $(TARGET_APUNTES)
	@$(MAKE) --no-print-directory clean-aux

guias guia: validate $(TARGET_GUIAS)
	@$(MAKE) --no-print-directory clean-aux

guias_resueltas guia_resuelta guiaresuelta: validate $(TARGET_GUIASR)
	@$(MAKE) --no-print-directory clean-aux

docente: validate $(TARGET_DOCENTE)
	@$(MAKE) --no-print-directory clean-aux

rubrica: validate $(RUBRICA_PDF)
	@$(MAKE) --no-print-directory clean-aux

defensa: validate $(DEFENSA_PDF)
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
		"$(BUILD_DIR)/defensa"

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

# Alias para clase1 .. clase9
clase1: clase01
clase2: clase02
clase3: clase03
clase4: clase04
clase5: clase05
clase6: clase06
clase7: clase07
clase8: clase08
clase9: clase09

clean-aux:
	@if [ -d "$(BUILD_DIR)" ]; then \
		find "$(BUILD_DIR)" -type f ! -name '*.pdf' -delete; \
		find "$(BUILD_DIR)" -type d -empty -delete 2>/dev/null || true; \
	fi
	@find "$(SLIDES_DIR)" "$(APUNTES_DIR)" "$(GUIAS_DIR)" \
		"$(GUIASR_DIR)" "$(DOCENTE_DIR)" "$(RUBRICA_DIR)" "$(DEFENSA_DIR)" \
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
	@echo "make rubrica | defensa"
	@echo "make clase01 ... make clase16"
	@echo "make slides CLASE=01 (o apuntes, guias, etc. con CLASE=XX)"
	@echo "make clean       # conserva PDF"
	@echo "make distclean   # elimina build completo"
	@echo "make fix-times   # corrige clock skew tras descomprimir"
