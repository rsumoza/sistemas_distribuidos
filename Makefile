SHELL := /bin/bash

LATEXMK := latexmk
LATEXFLAGS := -xelatex -cd -interaction=nonstopmode -halt-on-error -file-line-error

SLIDES_DIR := slides
NOTES_DIR := apuntes
GUIDES_DIR := guias
SOLVED_DIR := guias_resueltas
DOCENTE_DIR := docente
BUILD_DIR := build

# =========================
# Descubrimiento automático
# =========================

SLIDES_SRC := $(wildcard $(SLIDES_DIR)/clase*.tex)
NOTES_SRC := $(wildcard $(NOTES_DIR)/clase*-apuntes.tex)
GUIDES_SRC := $(wildcard $(GUIDES_DIR)/clase*-guia.tex)
SOLVED_SRC := $(wildcard $(SOLVED_DIR)/clase*-guiaresuelta.tex)
DOCENTE_SRC := $(wildcard $(DOCENTE_DIR)/clase*-docente.tex)

SLIDES_PDF := $(patsubst $(SLIDES_DIR)/%.tex,$(BUILD_DIR)/slides/%.pdf,$(SLIDES_SRC))
NOTES_PDF := $(patsubst $(NOTES_DIR)/%.tex,$(BUILD_DIR)/apuntes/%.pdf,$(NOTES_SRC))
GUIDES_PDF := $(patsubst $(GUIDES_DIR)/%.tex,$(BUILD_DIR)/guias/%.pdf,$(GUIDES_SRC))
SOLVED_PDF := $(patsubst $(SOLVED_DIR)/%.tex,$(BUILD_DIR)/guias_resueltas/%.pdf,$(SOLVED_SRC))
DOCENTE_PDF := $(patsubst $(DOCENTE_DIR)/%.tex,$(BUILD_DIR)/docente/%.pdf,$(DOCENTE_SRC))

ALL_PDF := $(SLIDES_PDF) $(NOTES_PDF) $(GUIDES_PDF) $(SOLVED_PDF) $(DOCENTE_PDF)

# =========================
# Targets principales
# =========================

.PHONY: all clean distclean dirs

all: $(ALL_PDF)

dirs:
	mkdir -p $(BUILD_DIR)/slides
	mkdir -p $(BUILD_DIR)/apuntes
	mkdir -p $(BUILD_DIR)/guias
	mkdir -p $(BUILD_DIR)/guias_resueltas
	mkdir -p $(BUILD_DIR)/docente

# =========================
# Reglas de compilación
# =========================

$(BUILD_DIR)/slides/%.pdf: $(SLIDES_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir=../$(BUILD_DIR)/slides $<
	$(LATEXMK) -cd -c -outdir=../$(BUILD_DIR)/slides $<

$(BUILD_DIR)/apuntes/%.pdf: $(NOTES_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir=../$(BUILD_DIR)/apuntes $<
	$(LATEXMK) -cd -c -outdir=../$(BUILD_DIR)/apuntes $<

$(BUILD_DIR)/guias/%.pdf: $(GUIDES_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir=../$(BUILD_DIR)/guias $<
	$(LATEXMK) -cd -c -outdir=../$(BUILD_DIR)/guias $<

$(BUILD_DIR)/guias_resueltas/%.pdf: $(SOLVED_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir=../$(BUILD_DIR)/guias_resueltas $<
	$(LATEXMK) -cd -c -outdir=../$(BUILD_DIR)/guias_resueltas $<

$(BUILD_DIR)/docente/%.pdf: $(DOCENTE_DIR)/%.tex | dirs
	$(LATEXMK) $(LATEXFLAGS) -outdir=../$(BUILD_DIR)/docente $<
	$(LATEXMK) -cd -c -outdir=../$(BUILD_DIR)/docente $<

# =========================
# Targets por clase (automático)
# =========================

CLASES := $(shell ls $(SLIDES_DIR)/clase*.tex | sed 's/.*clase\([0-9][0-9]\).tex/\1/')

define MAKE_CLASE_TARGET
clase$(1):
	@echo "Compilando clase $(1)..."
	$(MAKE) $(BUILD_DIR)/slides/clase$(1).pdf
	$(MAKE) $(BUILD_DIR)/apuntes/clase$(1)-apuntes.pdf
	$(MAKE) $(BUILD_DIR)/guias/clase$(1)-guia.pdf
	$(MAKE) $(BUILD_DIR)/guias_resueltas/clase$(1)-guiaresuelta.pdf
	$(MAKE) $(BUILD_DIR)/docente/clase$(1)-docente.pdf
endef

$(foreach c,$(CLASES),$(eval $(call MAKE_CLASE_TARGET,$(c))))

# =========================
# Limpieza
# =========================

clean:
	find $(BUILD_DIR) -type f \
	\( -name "*.aux" -o -name "*.log" -o -name "*.nav" -o -name "*.snm" -o -name "*.toc" \
	-o -name "*.out" -o -name "*.fls" -o -name "*.fdb_latexmk" -o -name "*.xdv" \
	-o -name "*.bcf" -o -name "*.run.xml" -o -name "*.blg" -o -name "*.bbl" \
	-o -name "*.synctex.gz" -o -name "*.vrb" -o -name "*.lof" -o -name "*.lot" \) -delete
	@echo "Auxiliares eliminados (PDFs preservados)."

distclean:
	rm -rf $(BUILD_DIR)
	@echo "Build completo eliminado."
