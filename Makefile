.PHONY: all slides apuntes guias guias_resueltas docente clean

LATEXMK=latexmk
LATEXFLAGS=-xelatex -interaction=nonstopmode -halt-on-error

SLIDES=$(wildcard slides/*.tex)
APUNTES=$(wildcard apuntes/*.tex)
GUIAS=$(wildcard guias/*.tex)
GUIASR=$(wildcard guias_resueltas/*.tex)
DOCENTE=$(wildcard docente/*.tex)

all: slides apuntes guias guias_resueltas docente

slides:
	@mkdir -p build/slides
	@for f in $(SLIDES); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=../build/slides -cd $$f; \
	done

apuntes:
	@mkdir -p build/apuntes
	@for f in $(APUNTES); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=../build/apuntes -cd $$f; \
	done

guias:
	@mkdir -p build/guias
	@for f in $(GUIAS); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=../build/guias -cd $$f; \
	done

guias_resueltas:
	@mkdir -p build/guias_resueltas
	@for f in $(GUIASR); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=../build/guias_resueltas -cd $$f; \
	done

docente:
	@mkdir -p build/docente
	@for f in $(DOCENTE); do \
		echo "Compiling $$f"; \
		$(LATEXMK) $(LATEXFLAGS) -output-directory=../build/docente -cd $$f; \
	done

clean:
	@find . -type f \( -name "*.aux" -o -name "*.log" -o -name "*.nav" -o -name "*.out" -o -name "*.toc" -o -name "*.snm" -o -name "*.fls" -o -name "*.fdb_latexmk" -o -name "*.vrb" -o -name "*.xdv" \) -delete
	@echo "Cleaned auxiliary files."
