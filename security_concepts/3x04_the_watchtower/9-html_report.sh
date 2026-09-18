#!/bin/bash
{
    echo '<!DOCTYPE html>'
    echo '<html lang="en">'
    echo '<head><meta charset="UTF-8"><title>Security Report</title></head>'
    echo '<body>'
    echo '<h1>Security Report</h1>'
    echo '<table>'
    echo '<tr><th>IP Address</th><th>Failed Attempts</th></tr>'

    grep "Failed password" "$1" |
        grep -oE 'from ([0-9]{1,3}\.){3}[0-9]{1,3} port' |
        awk '{print $2}' |
        sort | uniq -c | sort -rn | head -n 5 |
        awk '{print "<tr><td>" $2 "</td><td>" $1 "</td></tr>"}'

    echo '</table>'
    echo '</body>'
    echo '</html>'
} > $2