#!/usr/bin/r

writeHTML <- function(data) {
    html <- file("agendaTESTnew.html", "w")
    for (i in 1:NROW(data)) {

        row <- data[i,]

        ## extract pdf, ppt, pptx, ... from the 'paper' entry
        papertype <- ifelse(row$paper != "", gsub(".*\\.(.*)$", "\\1", row$paper, perl=TRUE), '')

        ## Example:
        ##<tr><td align="right">9:00am</td><td align="left"></td>- <td align="right">11:00am</td><td align="left"></td><td width="501"><b><font color="#894411">Ryan</font></b>: <font size="-1">Automated Trading with R and IBroker </font></td></tr>

        if (row$type=="HEADER") {
            cat('<tr><td colspan="5" align="left"><font size="+1">',
                row$titleH,
                '</font></td></tr>',
                "\n", sep="", file=html)
            next ## skip the rest
        }

        ## start a row
        cat('<tr><td align="right">', row$start,'</td><td align="left">',
            ifelse(row$start!="     ",'-',' '),
            '</td><td align="left">', row$end,
            '</td><td align="left"></td><td width="501"><font size="-1">',
                                        #"\n\t",
            switch(row$type,
                   smallbreak =paste('<font color="#595959">',    row$titleH, '</font></font>',           sep=""),
                   normalbreak=paste('<font color="#595959"><b>', row$titleH, '</b></font></font>', sep=""),
                   tutorial   =paste('<font color="#595959"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   keynote    =paste('<font color="#00008C"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   talk       =paste('<font color="#894411"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep=""),
                   lightning  =paste('<font color="#CC7200"><b>', row$authorH,'</b></font>: ', row$titleH, '</font>', sep="")),

            ifelse (row$paper!="", paste('<nobr>&nbsp;</nobr><a href="http://www.rinfinance.com/agenda/2011/', row$paper, '">(', papertype, ')</a>', sep=""), ''),

            '</td></tr>',

            ifelse (row$eolH=="VERTSPACE", '\n<tr><td colspan="5"></td></tr>', ''),

            "\n", sep="", file=html)
    }
    close(html)
}

writeLatex <- function(data) {
    latex <- file("agendaTEST.tex", "w")

    for (i in 1:NROW(data)) {

        row <- data[i,]

        #if (row$type=="tutorial") {
        #    next                        ## skip all tutorial entries (really?)
        #}

        if (row$type=="HEADER") {

            ## \multicolumn{5}{l}{\large \color{Breaks} Thursday, April 28th, 2011} \\[10pt]
            cat('\\multicolumn{5}{l}{\\large \\color{Breaks}',
                row$titleL,
                "} \\\\[10pt]",
                "\n", sep="", file=latex)
            next ## skip the rest
        }

        ## start a row
        #cat('<tr><td align="right">', row$start,'</td><td align="left">',

        cat(row$start, '&',

            ifelse(row$start!="     ",'\\color{Breaks}-- ',' '),
            '& ', row$end, '&   &',

            switch(row$type

                   #9:00,11:00,smallbreak,,Optional Pre-Conference Tutorials,,Optional Pre-Conference Tutorials,,
                   #9:00 & -- & 11:00 &   & \small{\mylinecolor{Breaks} Optional Pre-Conference Workshops} \\[5pt]
                   ,smallbreak =paste('\\small{\\mylinecolor{Breaks} ', row$titleL, '} ', sep="")

                   #12:15,12:30,normalbreak,,Welcome and opening remarks,,Welcome and opening remarks,,
                   #12:15  & -- & 12:30  & & \textbf{\color{Breaks} Welcome and opening remarks} \\
                   ,normalbreak=paste('\\textbf{\\color{Breaks} ', row$titleL, '} ', sep="")

                   #,     ,tutorial,Ryan,Automated Trading with R,Ryan,Automated Trading with R,,
                   ,tutorial=paste('\\textbf{\\color{Breaks} ', row$authorL, ': ', row$titleL, '} ', sep="")

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
}



data <- read.csv("agenda.csv", stringsAsFactors=FALSE)
options(width=155)
print(data[,-c(1:3,6 :9)])
writeHTML(data)
#writeLatex(data)
