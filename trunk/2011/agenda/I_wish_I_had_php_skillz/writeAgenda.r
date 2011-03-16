#!/usr/bin/r

data <- read.csv("agenda.csv", stringsAsFactors=FALSE)
print(data)

html <- file("agendaTEST.html", "w")
for (i in 1:NROW(data)) {

    row <- data[i,]
    print(row)
    ## Example:
    ##<tr><td align="right">9:00am</td><td align="left"></td>- <td align="right">11:00am</td><td align="left"></td><td width="501"><b><font color="#894411">Ryan</font></b>: <font size="-1">Automated Trading with R and IBroker </font></td></tr>

    ## start a row
    cat('<tr><td align="right">',row$start,
        '</td><td align="left"></td>- <td align="right">', row$end,
        "\n", sep="", file=html)
}
close(html)
