SHELL := /bin/bash
PROJECT_ROOT := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
LATEXMK := latexmk
LATEXFLAGS := -xelatex -cd -interaction=nonstopmode -halt-on-error -file-line-error
BUILD_DIR := $(PROJECT_ROOT)build
export TEXINPUTS := $(PROJECT_ROOT)cls//:$(TEXINPUTS)

SLIDES_DIR := slides
APUNTES_DIR := apuntes
GUIAS_DIR := guias
GUIASR_DIR := guias_resueltas
DOCENTE_DIR := docente
SLIDES_SRC := $(wildcard $(SLIDES_DIR)/clase*.tex)
APUNTES_SRC := $(wildcard $(APUNTES_DIR)/clase*-apuntes.tex)
GUIAS_SRC := $(wildcard $(GUIAS_DIR)/clase*-guia.tex)
GUIASR_SRC := $(wildcard $(GUIASR_DIR)/clase*-guiaresuelta.tex)
DOCENTE_SRC := $(wildcard $(DOCENTE_DIR)/clase*-docente.tex)
SLIDES_PDF := $(patsubst $(SLIDES_DIR)/%.tex,$(BUILD_DIR)/slides/%.pdf,$(SLIDES_SRC))
APUNTES_PDF := $(patsubst $(APUNTES_DIR)/%.tex,$(BUILD_DIR)/apuntes/%.pdf,$(APUNTES_SRC))
GUIAS_PDF := $(patsubst $(GUIAS_DIR)/%.tex,$(BUILD_DIR)/guias/%.pdf,$(GUIAS_SRC))
GUIASR_PDF := $(patsubst $(GUIASR_DIR)/%.tex,$(BUILD_DIR)/guias_resueltas/%.pdf,$(GUIASR_SRC))
DOCENTE_PDF := $(patsubst $(DOCENTE_DIR)/%.tex,$(BUILD_DIR)/docente/%.pdf,$(DOCENTE_SRC))
ALL_PDF := $(SLIDES_PDF) $(APUNTES_PDF) $(GUIAS_PDF) $(GUIASR_PDF) $(DOCENTE_PDF)
CLASES := 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16

.PHONY: all slides apuntes guias guias_resueltas docente validate dirs clean clean-aux distclean help $(addprefix clase,$(CLASES))
all: validate $(ALL_PDF) ; @$(MAKE) clean-aux ; @echo 'OK: curso completo; build/ conserva solo PDF.'
slides: validate $(SLIDES_PDF) ; @$(MAKE) clean-aux
apuntes: validate $(APUNTES_PDF) ; @$(MAKE) clean-aux
guias: validate $(GUIAS_PDF) ; @$(MAKE) clean-aux
guias_resueltas: validate $(GUIASR_PDF) ; @$(MAKE) clean-aux
docente: validate $(DOCENTE_PDF) ; @$(MAKE) clean-aux
validate: ; @python3 tools/validate_tex.py
dirs: ; @mkdir -p $(BUILD_DIR)/slides $(BUILD_DIR)/apuntes $(BUILD_DIR)/guias $(BUILD_DIR)/guias_resueltas $(BUILD_DIR)/docente
$(BUILD_DIR)/slides/%.pdf: $(SLIDES_DIR)/%.tex | dirs ; $(LATEXMK) $(LATEXFLAGS) -outdir=$(BUILD_DIR)/slides $<
$(BUILD_DIR)/apuntes/%.pdf: $(APUNTES_DIR)/%.tex | dirs ; $(LATEXMK) $(LATEXFLAGS) -outdir=$(BUILD_DIR)/apuntes $<
$(BUILD_DIR)/guias/%.pdf: $(GUIAS_DIR)/%.tex | dirs ; $(LATEXMK) $(LATEXFLAGS) -outdir=$(BUILD_DIR)/guias $<
$(BUILD_DIR)/guias_resueltas/%.pdf: $(GUIASR_DIR)/%.tex | dirs ; $(LATEXMK) $(LATEXFLAGS) -outdir=$(BUILD_DIR)/guias_resueltas $<
$(BUILD_DIR)/docente/%.pdf: $(DOCENTE_DIR)/%.tex | dirs ; $(LATEXMK) $(LATEXFLAGS) -outdir=$(BUILD_DIR)/docente $<

define CLASS_TARGET
clase$(1): validate
	@$$(MAKE) $$(BUILD_DIR)/slides/clase$(1).pdf $$(BUILD_DIR)/apuntes/clase$(1)-apuntes.pdf $$(BUILD_DIR)/guias/clase$(1)-guia.pdf $$(BUILD_DIR)/guias_resueltas/clase$(1)-guiaresuelta.pdf $$(BUILD_DIR)/docente/clase$(1)-docente.pdf
	@$$(MAKE) clean-aux
	@echo 'OK: clase$(1) compilada.'
endef
$(foreach c,$(CLASES),$(eval $(call CLASS_TARGET,$(c))))

clean-aux:
	@if [ -d '$(BUILD_DIR)' ]; then find '$(BUILD_DIR)' -type f ! -name '*.pdf' -delete; fi
	@find slides apuntes guias guias_resueltas docente -type f \( -name '*.aux' -o -name '*.log' -o -name '*.nav' -o -name '*.out' -o -name '*.toc' -o -name '*.snm' -o -name '*.fls' -o -name '*.fdb_latexmk' -o -name '*.vrb' -o -name '*.xdv' -o -name '*.synctex.gz' \) -delete
clean: clean-aux ; @echo 'Auxiliares eliminados; PDF preservados.'
distclean: ; @rm -rf '$(BUILD_DIR)' ; @echo 'Build eliminado.'
help:
	@echo 'make all | slides | apuntes | guias | guias_resueltas | docente'
	@echo 'make clase01 ... make clase16'
	@echo 'make clean (preserva PDF) | make distclean'
