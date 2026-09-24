SHELL := /bin/bash

LATEXMK := latexmk
LATEXFLAGS := -xelatex -cd -interaction=nonstopmode -halt-on-error -file-line-error
BUILD_DIR := build

# Directorios con documentos LaTeX autónomos. Los que no existan se ignoran.
COURSE_DIRS := slides apuntes guias guias_resueltas docente recursos \
               rubrica defensa evaluaciones tp programa anexos
EXTRA_DIRS ?=
ACTIVE_DIRS := $(strip $(foreach d,$(COURSE_DIRS) $(EXTRA_DIRS),$(if $(wildcard $(d)),$(d))))

# No incluimos config/ ni cls/: contienen fragmentos y clases, no documentos autónomos.
TEX_SOURCES := $(sort $(foreach d,$(ACTIVE_DIRS),$(wildcard $(d)/*.tex)))
ALL_PDF := $(patsubst %.tex,$(BUILD_DIR)/%.pdf,$(TEX_SOURCES))

CLASSES := 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16
CLASS_TARGETS := $(addprefix clase,$(CLASSES))

# Permite encontrar las clases .cls por nombre incluso si la ruta del repositorio contiene espacios.
export TEXINPUTS := $(abspath cls)//:$(TEXINPUTS)

.PHONY: all validate list slides apuntes guias guias_resueltas docente recursos \
        rubrica defensa evaluaciones tp programa anexos clean clean-aux distclean \
        fix-times check-package help $(CLASS_TARGETS)

all: validate $(ALL_PDF)
	@$(MAKE) --no-print-directory clean-aux
	@echo "OK: curso completo compilado ($(words $(ALL_PDF)) PDF detectados)."
	@echo "    build/ conserva únicamente archivos PDF."

# Inspección previa: muestra exactamente qué va a compilar make all.
list:
	@echo "Directorios activos: $(ACTIVE_DIRS)"
	@echo
	@echo "Fuentes detectadas ($(words $(TEX_SOURCES))):"
	@for f in $(TEX_SOURCES); do printf '  %s\n' "$$f"; done
	@echo
	@echo "PDF esperados ($(words $(ALL_PDF))):"
	@for f in $(ALL_PDF); do printf '  %s\n' "$$f"; done

# Se ejecuta el validador global si existe y, además, todos los validadores por clase.
validate:
	@set -e; found=0; \
	if [[ -f tools/validate_tex.py ]]; then \
	  echo "==> tools/validate_tex.py"; python3 tools/validate_tex.py; found=1; \
	elif [[ -f tools/validate_course.py ]]; then \
	  echo "==> tools/validate_course.py"; python3 tools/validate_course.py .; found=1; \
	elif [[ -f tools/validate_all.py ]]; then \
	  echo "==> tools/validate_all.py"; python3 tools/validate_all.py .; found=1; \
	fi; \
	if compgen -G 'tools/validate_clase*.py' > /dev/null; then \
	  for v in tools/validate_clase*.py; do \
	    echo "==> $$v"; python3 "$$v" .; \
	  done; \
	  found=1; \
	fi; \
	if [[ $$found -eq 0 ]]; then \
	  echo "ADVERTENCIA: no se encontró un validador en tools/."; \
	fi

# Regla genérica: build/<directorio>/<documento>.pdf <- <directorio>/<documento>.tex
$(BUILD_DIR)/%.pdf: %.tex
	@mkdir -p "$(@D)"
	$(LATEXMK) $(LATEXFLAGS) -outdir="$(abspath $(@D))" "$<"

# Targets por categoría.
slides: validate $(filter $(BUILD_DIR)/slides/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
apuntes: validate $(filter $(BUILD_DIR)/apuntes/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
guias: validate $(filter $(BUILD_DIR)/guias/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
guias_resueltas: validate $(filter $(BUILD_DIR)/guias_resueltas/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
docente: validate $(filter $(BUILD_DIR)/docente/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
recursos: validate $(filter $(BUILD_DIR)/recursos/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
rubrica: validate $(filter $(BUILD_DIR)/rubrica/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
defensa: validate $(filter $(BUILD_DIR)/defensa/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
evaluaciones: validate $(filter $(BUILD_DIR)/evaluaciones/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
tp: validate $(filter $(BUILD_DIR)/tp/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
programa: validate $(filter $(BUILD_DIR)/programa/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux
anexos: validate $(filter $(BUILD_DIR)/anexos/%,$(ALL_PDF))
	@$(MAKE) --no-print-directory clean-aux

# Targets make clase01 ... make clase16. Compilan todo archivo cuyo nombre comience por claseNN.
define CLASS_TARGET
CLASS_$(1)_PDF := $$(foreach p,$$(ALL_PDF),$$(if $$(findstring /clase$(1),$$(p)),$$(p)))
clase$(1): validate $$(CLASS_$(1)_PDF)
	@if [[ -z "$$(strip $$(CLASS_$(1)_PDF))" ]]; then \
	  echo "ERROR: no se detectaron fuentes clase$(1)*.tex en: $$(ACTIVE_DIRS)"; exit 2; \
	fi
	@$$(MAKE) --no-print-directory clean-aux
	@echo "OK: clase$(1) compilada ($$(words $$(CLASS_$(1)_PDF)) PDF)."
endef
$(foreach c,$(CLASSES),$(eval $(call CLASS_TARGET,$(c))))

# Verifica que un paquete esté instalado: make check-package PKG=siunitx
check-package:
	@if [[ -z "$(PKG)" ]]; then \
	  echo "Uso: make check-package PKG=nombre_del_paquete"; exit 2; \
	fi
	@p="$$(kpsewhich "$(PKG).sty")"; \
	if [[ -n "$$p" ]]; then echo "OK: $(PKG) -> $$p"; \
	else echo "ERROR: no se encontró $(PKG).sty en esta instalación de TeX Live"; exit 1; fi

clean-aux:
	@if [[ -d "$(BUILD_DIR)" ]]; then \
	  find "$(BUILD_DIR)" -type f ! -name '*.pdf' -delete; \
	  find "$(BUILD_DIR)" -type d -empty -delete 2>/dev/null || true; \
	fi
	@for d in $(ACTIVE_DIRS); do \
	  find "$$d" -maxdepth 1 -type f \
	    \( -name '*.aux' -o -name '*.log' -o -name '*.nav' -o -name '*.snm' \
	       -o -name '*.toc' -o -name '*.out' -o -name '*.fls' \
	       -o -name '*.fdb_latexmk' -o -name '*.xdv' -o -name '*.synctex.gz' \
	       -o -name '*.vrb' -o -name '*.bcf' -o -name '*.run.xml' \
	       -o -name '*.bbl' -o -name '*.blg' -o -name '*.lof' -o -name '*.lot' \) \
	    -delete 2>/dev/null || true; \
	done

clean: clean-aux
	@echo "Auxiliares eliminados; los PDF fueron preservados."

distclean:
	@rm -rf "$(BUILD_DIR)"
	@echo "build/ eliminado, incluidos sus PDF."

fix-times:
	@find . -path './.git' -prune -o -path './build' -prune -o -type f -exec touch {} +
	@find . -path './.git' -prune -o -path './build' -prune -o -type d -exec touch {} +
	@echo "Timestamps normalizados."

help:
	@printf '%s\n' \
	  'make list                         Lista todo lo que compilará make all' \
	  'make all                          Compila todo el curso' \
	  'make clase01 ... make clase16     Compila una clase y todos sus documentos' \
	  'make slides|apuntes|guias|docente Compila una categoría' \
	  'make recursos|rubrica|defensa     Compila recursos adicionales' \
	  'make check-package PKG=siunitx    Verifica un paquete LaTeX' \
	  'make clean                        Borra auxiliares, conserva PDF' \
	  'make distclean                    Borra build/ completo' \
	  'make -B all                       Fuerza recompilación completa'
