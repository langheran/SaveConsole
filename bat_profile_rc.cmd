doskey save=doskey /history $g$g %USERPROFILE%\command_history.log
doskey quit=doskey /history $g$g %USERPROFILE%\command_history.log $T exit
doskey exit=doskey /history $g$g %USERPROFILE%\command_history.log $t exit $1 $2
doskey history=find /I "$*" %USERPROFILE%\command_history.log
cls