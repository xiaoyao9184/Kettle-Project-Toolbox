@echo off
::CODER BY xiaoyao9184 1.0
::TIME 2017-08-26
::FILE SET_PARAM
::DESC set kettle param


:v

::tip info
set pList=

set eset_pName=Need input param name('NONE' end loop):
set eset_pValue=Need input param value:


:loop

set /p pName=%eset_pName%|| Set pName=NONE
if "%pName%"=="NONE" goto :end

set /p pValue=%eset_pValue%

set pItem="-param:%pName%=%pValue%"
set pList=%pList% %pItem%

echo %pList%

goto loop


:end

::exit
exit /b 0
