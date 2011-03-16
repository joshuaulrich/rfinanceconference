#!/usr/bin/r

data <- read.csv("agenda.csv", stringsAsFactors=FALSE)
print(data)

html <- file("agendaTEST.html", "w")
for (i in 1:NROW(data)) {

    row <- data[i,]
    ## Example:
    ##<tr><td align="right">9:00am</td><td align="left"></td>- <td align="right">11:00am</td><td align="left"></td><td width="501"><b><font color="#894411">Ryan</font></b>: <font size="-1">Automated Trading with R and IBroker </font></td></tr>

    ## start a row
    cat('<tr><td align="right">', row$start,
        '</td><td align="left"></td>- <td align="right">', row$end,
        '</td><td align="left"></td><td width="501">',
        #"\n\t",
        switch(row$type,
               smallbreak =paste('<font size="-1" color="#595959">',    row$titleH, '</font>',           sep=""),
               normalbreak=paste('<font size="0"  color="#595959"><b>', row$titleH, '</b></font>', sep=""),
               keynote    =paste('<font size="0"  color="#00008C"><b>', row$authorH,'</b></font>: <font size="-1">', row$titleH, '</font>', sep=""),
               talk       =paste('<font size="0"  color="#894411"><b>', row$authorH,'</b></font>: <font size="-1">', row$titleH, '</font>', sep=""),
               lightning  =paste('<font size="0"  color="#CC7200"><b>', row$authorH,'</b></font>: <font size="-1">', row$titleH, '</font>', sep="")),
        '</td></tr>',
        "\n", sep="", file=html)
}
close(html)
