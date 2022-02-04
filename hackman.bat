@echo off
setlocal enabledelayedexpansion

:: load api key
call env

set alphabet=1ABCDEFGHIJKLMNOPQRSTUVWXYZ
set backto=gameloop
set /a health=3
set placeholders=____
set guess=
set word=uhhh
set letter=

:load
    :: fetch api result and store in res variable
    curl http://clemsonhackman.com/api/word?key=%API_KEY%^&length=4 > res.json
    set /p res=<res.json
    del res.json

    :: get word from json


    set backto = gameloop
    goto gameloop


:gameloop
    echo.
    echo.
    echo.
    echo.

    echo Health: %health%
    echo %guess%%placeholders%

    :: choice sets ERRORLEVEL variable
    choice /c abcdefghijklmnopqrstuvwxyz /m "Enter a character: "

    :: godamn I'm a genius
    set letter=!alphabet:~%ERRORLEVEL%,1!

    goto gameloop
