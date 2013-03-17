#!/usr/bin/r

prefixZero <- function(x) {
    if (nchar(x) == 4) {
        return(paste0('0', x))
    } else {
        return(x)
    }
}

writeHTML <- function(data) {

    html <- file("agendaGENERATED.html", "w")

    firstHeader <- TRUE                 # need that for the body/head/body transition from day 1 to 2

    cat('<table class="table table-condensed">', sep="", file=html)

    for (i in 1:NROW(data)) {           # for all the data
        row <- data[i,]

        ## extract pdf, ppt, pptx, ... from the 'paper' entry
        papertype <- ifelse(row$paper != "", gsub(".*\\.(.*)$", "\\1", row$paper, perl=TRUE), '')

        ## Example:
        ##<tr><td align="right">9:00am</td><td align="left"></td>- <td align="right">11:00am</td><td align="left"></td><td width="501"><b><font color="#894411">Ryan</font></b>: <font size="-1">Automated Trading with R and IBroker </font></td></tr>

        if (row$type=="HEADER") {

            ## <thead>
            ##   <tr><th colspan="2" align="left"><font size="+1">Friday, May 17th, 2013</font></th></tr>
            ## </thead>
            cat(ifelse(firstHeader, '', '</tbody>'), '\n', sep="", file=html) 	## second header next a closing body tag
            cat('<thead>','\n', sep="", file=html)
            cat('  <tr><td colspan="2" style="padding-top: 30px;"><font size="+2">', row$titleH, '</font></td></tr>', "\n", sep="", file=html)
            cat('</thead>','\n', sep="", file=html)
            cat('<tbody>','\n', sep="", file=html)
            firstHeader <- FALSE
            next ## skip the rest
        }

        ## start a row
        ## <tr><td>08:00 - 09:00</td><td><font size="-1"><font color="#595959">Optional Pre-Conference Tutorials</font></font></td></tr>

        cat('  <tr><td>',
            ifelse(!is.na(row$start) && row$start!="",
                   paste0('<nobr>',prefixZero(row$start),'&nbsp;-&nbsp;', prefixZero(row$end), '</nobr>'), ''),
            '</td><td><font size="-1">',
            switch(row$type,
                   smallbreak =paste('<font color="#595959">',    row$titleH, '</font></font>',           sep=""),
                   normalbreak=paste('<font color="#595959"><b>', row$titleH, '</b></font></font>', sep=""),
                   tutorial   =paste('<font color="#595959"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   keynote    =paste('<font color="#00008C"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   talk       =paste('<font color="#894411"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   lightning  =paste('<font color="#CC7200"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep="")),

            ifelse (!is.na(row$paper) && row$paper!="",
                    paste('<nobr>&nbsp;</nobr><a href="http://www.rinfinance.com/agenda/2013/', row$paper, '">(', papertype, ')</a>', sep=""),
                    ''),

            '</td></tr>',

            "\n", sep="", file=html)
    }
    cat('</tbody>','\n', sep="", file=html)
    cat('</table>','\n', sep="", file=html)

    close(html)
}

OLDwriteHTML <- function(data) {
    html <- file("agendaGENERATED.html", "w")
    for (i in 1:NROW(data)) {

        row <- data[i,]

        ## extract pdf, ppt, pptx, ... from the 'paper' entry
        papertype <- ifelse(row$paper != "", gsub(".*\\.(.*)$", "\\1", row$paper, perl=TRUE), '')

        ## Example:
        ##<tr><td align="right">9:00am</td><td align="left"></td>- <td align="right">11:00am</td><td align="left"></td><td width="501"><b><font color="#894411">Ryan</font></b>: <font size="-1">Automated Trading with R and IBroker </font></td></tr>

        if (row$type=="HEADER") {
            cat('<tr><td colspan="5" align="left"><nobr>&nbsp; &nbsp;</nobr></td></tr>', "\n", sep="", file=html)
            cat('<tr><td colspan="5" align="left"><font size="+1">',
                row$titleH,
                '</font></td></tr>',
                "\n", sep="", file=html)
            cat('<tr><td colspan="5" align="left"><nobr>&nbsp; &nbsp;</nobr></td></tr>', "\n", sep="", file=html)
            next ## skip the rest
        }

        ## start a row
        cat('<tr><td align="right">', row$start,'</td><td align="left">',
            ifelse(row$start!="     ",'-',' '),
            '</td><td align="left">', row$end,
            '</td><td align="left"></td><td width="581"><font size="-1">',
                                        #"\n\t",
            switch(row$type,
                   smallbreak =paste('<font color="#595959">',    row$titleH, '</font></font>',           sep=""),
                   normalbreak=paste('<font color="#595959"><b>', row$titleH, '</b></font></font>', sep=""),
                   tutorial   =paste('<font color="#595959"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   keynote    =paste('<font color="#00008C"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   talk       =paste('<font color="#894411"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   lightning  =paste('<font color="#CC7200"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep="")),

            ifelse (!is.na(row$paper) && row$paper!="", paste('<nobr>&nbsp;</nobr><a href="http://www.rinfinance.com/agenda/2012/', row$paper, '">(', papertype, ')</a>', sep=""), ''),

            '</td></tr>',

            ifelse (row$eolH=="VERTSPACE", '\n<tr><td colspan="5"></td></tr>', ''),

            "\n", sep="", file=html)
    }
    close(html)
}

writeLatex <- function(data) {
    latex <- file("agendaTEST.tex", "w")

    starting <- TRUE
    for (i in 1:NROW(data)) {

        row <- data[i,]

        #if (row$type=="tutorial") {
        #    next                        ## skip all tutorial entries (really?)
        #}

        if (row$type=="HEADER") {
          if (!starting) {
            cat('\\end{tabular}', "\n\n",
                "\\clearpage", "\n\n", sep="", file=latex)
          }
          cat('{\\Huge \\textbf{\\color{KeynoteTalk} R/Finance 2013} \\huge \\phantom{i} Applied Finance with R} \\\\',
              '{\\large \\color{Breaks} May 17th and 18th, 2013, at the University of Illinois at Chicago} \\\\',
              '\\vspace{3ex}', '\\hrulefill',
              '\\vspace{-2ex}', '\\begin{center}',
              '\\includegraphics[scale=0.8]{sponsors.pdf}',
              '\\end{center}', '\\vspace{-3ex}',
              '\\hrulefill', '', sep="\n", file=latex)
          cat("\\vspace{3ex}", sep="\n", file=latex)
          cat('{\\large \\color{Breaks}', row$titleL, "} \\\\",
              "\n", sep="", file=latex)
          cat("\\vspace{7ex}", sep="\n", file=latex)
          cat('\\begin{tabular}{rlrp{6.1in}}', "\n", sep="", file=latex)
          starting <- FALSE
          next ## skip the rest
        }

        ## start a row
        #cat('<tr><td align="right">', row$start,'</td><td align="left">',

        cat(row$start, '&',

            ifelse(row$start!="     ",'\\color{Breaks}--\\hspace{-10ex}',' '),
            '& ', row$end, '&',

            switch(row$type

                   #9:00,11:00,smallbreak,,Optional Pre-Conference Tutorials,,Optional Pre-Conference Tutorials,,
                   #9:00 & -- & 11:00 &   & \small{\mylinecolor{Breaks} Optional Pre-Conference Workshops} \\[5pt]
                   ,smallbreak =paste('\\small{\\mylinecolor{Breaks} ', row$titleL, '} ', sep="")

                   #12:15,12:30,normalbreak,,Welcome and opening remarks,,Welcome and opening remarks,,
                   #12:15  & -- & 12:30  & & \textbf{\color{Breaks} Welcome and opening remarks} \\
                   ,normalbreak=paste('\\textbf{\\color{Breaks} ', row$titleL, '} ', sep="")

                   #,     ,tutorial,Ryan,Automated Trading with R,Ryan,Automated Trading with R,,
                   ,tutorial=paste('\\textbf{\\color{Breaks} ', row$authorL, '}: \\small{', row$titleL, '} ', sep="")

                   #12:30,13:20,keynote,Faber,Global Tactical Investing,Faber,Global Tactical Investing,,
                   #%12:30pm& -- & 1:20pm &    & \textbf{\color{KeynoteTalk} Faber}: \small{TBA} \\
                   ,keynote=paste('\\textbf{\\color{KeynoteTalk} ', row$authorL, '}: \\small{', row$titleL, '} ', sep="")

                   #16:20,16:40,talk,Lewis,The \emph{betfair} Package,Lewis,The <em>betfair</em> Package,,
                   #16:20 & -- & 16:40 &    & \textbf{\color{Talk} Lewis}: \small{The \emph{betfair} Package} \\
                   ,talk=paste('\\textbf{\\color{Talk} ', row$authorL, '}: \\small{', row$titleL, '} ', sep="")

                   #,     ,lightning,Long,The \emph{Segue} Package for R,Long,The <em>Segue</em> Package for R,,
                   #&    &        &    & \textbf{\color{LightningTalk} Long}: \small{The \emph{Segue} Package for R} \\
                   ,lightning=paste('\\textbf{\\color{LightningTalk} ', row$authorL, '}: \\small{', row$titleL, '} ', sep="")
                   ),



            ifelse (row$eolH=="VERTSPACE", '\\\\[12pt]', '\\\\'),
            "\n", sep="", file=latex)

    }
    cat('\\end{tabular}', "\n", sep="", file=latex)
}



data <- read.csv("agenda.csv", stringsAsFactors=FALSE)
options(width=155)
#print(colnames(data))
#print(data[,-c(1:3,8:10)])
writeHTML(data)
writeLatex(data)
