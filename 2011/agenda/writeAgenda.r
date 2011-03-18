#!/usr/bin/r

data <- read.csv("agenda.csv", stringsAsFactors=FALSE)
print(data)

html <- file("agendaTEST.html", "w")
for (i in 1:NROW(data)) {

    row <- data[i,]
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
        '</td></tr>',
        ifelse (row$eolH=="VERTSPACE", '\n<tr><td colspan="5"></td></tr>', ''),
        "\n", sep="", file=html)
}
close(html)
