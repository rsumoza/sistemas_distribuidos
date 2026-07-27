.PHONY: all slides apuntes guias guias_resueltas docente clase% clean
PROJECT_ROOT := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
LATEXMK=latexmk
LATEXFLAGS=-silent -xelatex -interaction=nonstopmode -halt-on-error
BUILD_DIR := $(PROJECT_ROOT)build
export TEXINPUTS := $(PROJECT_ROOT)cls//:$(TEXINPUTS)

SLIDES=$(wildcard slides/*.tex)
SLIDES_DIR=$(PROJECT_ROOT)slides
BUILD_SLIDES_DIR := $(BUILD_DIR)/slides

APUNTES=$(wildcard apuntes/*.tex)
APUNTES_DIR=$(PROJECT_ROOT)apuntes
BUILD_APUNTES_DIR := $(BUILD_DIR)/apuntes

GUIAS=$(wildcard guias/*.tex)
GUIAS_DIR=$(PROJECT_ROOT)guias
BUILD_GUIAS_DIR := $(BUILD_DIR)/guias

GUIASR=$(wildcard guias_resueltas/*.tex)
GUIAS_RESUELTAS_DIR=$(PROJECT_ROOT)guias_resueltas
BUILD_GUIAS_RESUELTAS_DIR := $(BUILD_DIR)/guias_resueltas

DOCENTE=$(wildcard docente/*.tex)
DOCENTE_DIR=$(PROJECT_ROOT)docente
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
	@rm -f $(BUILD_SLIDES_DIR)/clase$*.* \
		   $(BUILD_APUNTES_DIR)/clase$*-apuntes.* \
		   $(BUILD_GUIAS_DIR)/clase$*-guia.* \
		   $(BUILD_GUIAS_RESUELTAS_DIR)/clase$*-guiaresuelta.* \
		   $(BUILD_DOCENTE_DIR)/clase$*-docente.*
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_SLIDES_DIR) -cd $(SLIDES_DIR)/clase$*.tex;
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_APUNTES_DIR) -cd $(APUNTES_DIR)/clase$*-apuntes.tex;
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_GUIAS_DIR) -cd $(GUIAS_DIR)/clase$*-guia.tex;
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_GUIAS_RESUELTAS_DIR) -cd $(GUIAS_RESUELTAS_DIR)/clase$*-guiaresuelta.tex;
	@$(LATEXMK) $(LATEXFLAGS) -output-directory=$(BUILD_DOCENTE_DIR) -cd $(DOCENTE_DIR)/clase$*-docente.tex;


clean:
	@find . -type f \( -name "*.aux" -o -name "*.log" -o -name "*.nav" -o -name "*.out" -o -name "*.toc" -o -name "*.snm" -o -name "*.fls" -o -name "*.fdb_latexmk" -o -name "*.vrb" -o -name "*.xdv" \) -delete
	@rm -rf ./build ./out
	@echo "Cleaned auxiliary files."
