

all:			agendaGENERATED.html agenda.pdf 

#agendaGENERATED.html:	agenda.csv
#			r writeAgenda.r

agenda.pdf:		agenda.csv
			r writeAgenda.r
			pdflatex agenda
			mv -v agenda.pdf RFinance2012.pdf
			chmod 0644 RFinance2012.pdf

copy:
			@cp -vax RFinance2012.pdf /var/www/rinfinance.com/agenda/RFinance2012.pdf

.PHONY: all agendaGENERATED.html agenda.pdf 
