.PHONY: all slides apuntes guias guias_resueltas docente clase% clean
PROJECT_ROOT := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
LATEXMK=latexmk
LATEXFLAGS=-silent -xelatex -interaction=nonstopmode -halt-on-error

SLIDES=$(wildcard slides/*.tex)
SLIDES_DIR=$(PROJECT_ROOT)slides
APUNTES_DIR=$(PROJECT_ROOT)apuntes
GUIAS_DIR=$(PROJECT_ROOT)guias
GUIAS_RESUELTAS_DIR=$(PROJECT_ROOT)guias_resueltas
DOCENTE_DIR=$(PROJECT_ROOT)docente

APUNTES=$(wildcard apuntes/*.tex)
GUIAS=$(wildcard guias/*.tex)
GUIASR=$(wildcard guias_resueltas/*.tex)
DOCENTE=$(wildcard docente/*.tex)

BUILD_DIR := $(PROJECT_ROOT)build
BUILD_SLIDES_DIR := $(BUILD_DIR)/slides
BUILD_APUNTES_DIR := $(BUILD_DIR)/apuntes
BUILD_GUIAS_DIR := $(BUILD_DIR)/guias
BUILD_GUIAS_RESUELTAS_DIR := $(BUILD_DIR)/guias_resueltas
BUILD_DOCENTE_DIR := $(BUILD_DIR)/docente

all: slides apuntes guias guias_resueltas docente

slides:
	@mkdir -p $(BUILD_SLIDES_DIR)
	@for f in $(SLIDES); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_SLIDES_DIR) -cd $$f; \
	done

apuntes:
	@mkdir -p $(BUILD_APUNTES_DIR)
	@for f in $(APUNTES); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_APUNTES_DIR) -cd $$f; \
	done

guias:
	@mkdir -p $(BUILD_GUIAS_DIR)
	@for f in $(GUIAS); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_GUIAS_DIR) -cd $$f; \
	done

guias_resueltas:
	@mkdir -p $(BUILD_GUIAS_RESUELTAS_DIR)
	@for f in $(GUIASR); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_GUIAS_RESUELTAS_DIR) -cd $$f; \
	done

docente:
	@mkdir -p $(BUILD_DOCENTE_DIR)
	@for f in $(DOCENTE); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_DOCENTE_DIR) -cd $$f; \
	done

clase%:
	@echo "Compilando clase $*..."
	@mkdir -p $(BUILD_SLIDES_DIR) \
			  $(BUILD_APUNTES_DIR) \
			  $(BUILD_GUIAS_DIR) \
			  $(BUILD_GUIAS_RESUELTAS_DIR) \
			  $(BUILD_DOCENTE_DIR)
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_SLIDES_DIR) -cd $(SLIDES_DIR)/clase$*.tex;
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_APUNTES_DIR) -cd $(APUNTES_DIR)/clase$*-apuntes.tex;
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_GUIAS_DIR) -cd $(GUIAS_DIR)/clase$*-guia.tex;
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_GUIAS_RESUELTAS_DIR) -cd $(GUIAS_RESUELTAS_DIR)/clase$*-guiaresuelta.tex;
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_DOCENTE_DIR) -cd $(DOCENTE_DIR)/clase$*-docente.tex;


clean:
	@find . -type f \( -name "*.aux" -o -name "*.log" -o -name "*.nav" -o -name "*.out" -o -name "*.toc" -o -name "*.snm" -o -name "*.fls" -o -name "*.fdb_latexmk" -o -name "*.vrb" -o -name "*.xdv" \) -delete
	@rm -rf ./build ./out
	@echo "Cleaned auxiliary files."
