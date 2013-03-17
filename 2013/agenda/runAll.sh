#!/bin/bash

./writeAgenda.csv
pdflatex agenda
cp -vax agenda.pdf /var/www/rinfinance.com/agenda/RFinance2013.pdf
