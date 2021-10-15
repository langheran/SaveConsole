set "HISTORY_FILE=%USERPROFILE%\command_history.log"
doskey save=doskey /history $g$g "%HISTORY_FILE%"
doskey quit=doskey /history $g$g "%HISTORY_FILE%" $T exit
doskey exit=doskey /history $g$g "%HISTORY_FILE%" $t exit $1 $2
doskey history=find /I "$*" "%HISTORY_FILE%"
cls