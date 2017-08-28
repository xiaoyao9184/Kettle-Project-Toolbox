@echo off
::CODER BY xiaoyao9184 1.0
::TIME 2017-08-26
::FILE SET_PARAM
::DESC set kettle param


:v

::1变量赋值
set pList=

set eset_pName=请输入参数名，然后回车（空结束）：
set eset_pValue=请输入参数值，然后回车：


:loop

set /p pName=%eset_pName%|| Set pName=NONE
if "%pName%"=="NONE" goto :end

set /p pValue=%eset_pValue%

set pItem="-param:%pName%=%pValue%"
set pList=%pList% %pItem%

echo %pList%

goto loop


:end

::5退出
exit /b 0
