#!/bin/bash

pdflatex agenda.tex
pdflatex agenda.tex
cp -vax agenda.pdf /var/www/rinfinance.com/agenda/RFinance2010.pdf 
cp -vax index.html /var/www/rinfinance.com/agenda/