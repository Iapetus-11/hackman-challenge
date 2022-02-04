@echo off
setlocal enabledelayedexpansion

:: load api key
call env

set alphabet=1ABCDEFGHIJKLMNOPQRSTUVWXYZ
set /a health=3
set length=4
set word=uhhh
set letter=
set w1=
set w2=
set w3=
set w4=
set g1=_
set g2=_
set g3=_
set g4=_

:load
    :: fetch api result and store in res variable
    curl "https://clemsonhackman.com/api/word?key=%API_KEY%&length=%length%">res.json
    set /p res=<res.json
    del res.json

    echo %res%

    :: set res={^"word^": ^"test^"}

    :: get word from json
    :: substring, assumes json like: {"word":"test"}
    set word=!res:~9,%length%!
    :: set variables for each letter, just easier to deal with
    set w1=%word:~0,1%
    set w2=%word:~1,1%
    set w3=%word:~2,1%
    set w4=%word:~3,1%

    goto gameLoop


:gameLoop
    if %health%==0 goto lose
    if /i %w1%%w2%%w3%%w4%==%g1%%g2%%g3%%g4% goto win
    
    cls

    echo Health: %health%
    echo %g1%%g2%%g3%%g4%
    ::echo %w1%%w2%%w3%%w4%

    :: choice sets ERRORLEVEL variable
    choice /n /c abcdefghijklmnopqrstuvwxyz /m "Enter a character: "

    :: set letter using the errorlevel as index
    set letter=!alphabet:~%ERRORLEVEL%,1!

    set matched=false
    
    if /i not %g1%==%w1% (
        if %matched%==false (
            if /i %letter%==%w1% (
                set g1=%letter%
                set matched=true
            )
        )
    )
    
    if /i not %g2%==%w2% (
        if %matched%==false (
            if /i %letter%==%w2% (
                set g2=%letter%
                set matched=true
            )
        )
    )
    
    if /i not %g3%==%w3% (
        if %matched%==false (
            if /i %letter%==%w3% (
                set g3=%letter%
                set matched=true
            )
        )
    )
    
    if /i not %g4%==%w4% (
        if %matched%==false (
            if /i %letter%==%w4% (
                set g4=%letter%
                set matched=true
            )
        )
    )

    if %matched%==false set /a health=%health%-1

    goto gameLoop

:win
    echo.
    echo Congratulations, you WON!
    exit

:lose
    echo.
    echo Sorry... but you suck.
    echo The word was %word%.
    exit

