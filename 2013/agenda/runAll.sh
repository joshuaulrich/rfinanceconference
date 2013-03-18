#!/bin/bash

./writeAgenda.csv
pdflatex agenda && rm agenda.aux agenda.log
cp -vax agenda.pdf /var/www/rinfinance.com/agenda/RFinance2013.pdf
