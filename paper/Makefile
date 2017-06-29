SOURCE=ms
ABS=abstract
TEX=pdflatex
DVI=dvips
POST=ps2pdf
BIBTEX=bibtex

all: $(SOURCE).tex
	$(TEX) $(SOURCE).tex
	$(BIBTEX) $(SOURCE)
	$(TEX) $(SOURCE).tex
	$(TEX) $(SOURCE).tex
#	$(DVI) $(SOURCE).dvi
#	$(POST) $(SOURCE).ps

abs: abstract.tex
	$(TEX) $(ABS).tex
	$(TEX) $(ABS).tex
#	$(DVI) $(ABS).dvi
#	$(POST) $(ABS).ps

clean:
	rm -f *.aux *.bbl *.log *.dvi *.blg msNotes.bib *~

realclean:
	rm -f *.aux *.bbl *.log *.dvi *.blg msNotes.bib *~ ms.ps ms.pdf
