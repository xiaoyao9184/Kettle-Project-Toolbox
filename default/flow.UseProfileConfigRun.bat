@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2017-08-26
::FILE RUN_REP_J
::DESC run a job in filesystem repositorie 


:v

::1变量赋值
set tip=Kettle调度程序：运行资源库转换
set ver=1.0
::double-clicking is outer call and will set 0
set interactive=1
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 set interactive=0
::set kettle environment
call SET_ENVIRONMENT.bat
set rName=%KETTLE_REPOSITORY%
set jName=
set pList=

set loglevel=Basic
set fileName=%~n0
set extName=
set kCommand=

set echo_rName=需要输入Kettle文件资源库名称
set eset_rName=请输入Kettle文件资源库名称，然后回车：
set echo_jName=需要输入Kettle资源库作业/转换名
set eset_jName=请输入Kettle资源库作业/转换名，然后回车：
set echo_jFile=Kettle作业文件路径：
set echo_pList=进入设置参数脚本：
set echo_kCommand=运行作业^(J^)，运行转换^(T^)？


:title

::2提示文本
title %tip% %ver%

echo Kettle调度程序：运行资源库作业
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%rName%"=="" (
    echo %echo_rName%
    set /p rName=%eset_rName%
)

::kitchen or pan

set extName=kjb
goto finding

:notfound

if %extName%==kjb (
    set extName=ktr
    goto finding
)
echo %echo_jName%
set /p jName=%eset_jName%
set fileName=
goto found

:finding

echo finding file in this path: %fileName%.%extName%
if exist "%fileName%.%extName%" (
    set jName=%fileName%
) else (
    set fileName=%fileName:.=\%
    echo finding file in sub path: !fileName!.%extName%
    if exist "!fileName!.%extName%" (
        set jName=!fileName:.=/!
    ) else (
        goto notfound
    )
)

echo %extName%
if %extName%==kjb (
    set kCommand=kitchen
)
if %extName%==ktr (
    set kCommand=pan
)
set fileName=%fileName%.%extName%
echo use this command to run: %kCommand%

:found

if "%kCommand%"=="" (
    choice /c JT /m !echo_kCommand!
    if !errorlevel! equ 1 set kCommand=kitchen
    if !errorlevel! equ 2 set kCommand=pan
)

if exist "%~n0.SET_PARAM.bat" (
    echo %echo_pList% %~n0.SET_PARAM.bat
    call %~n0.SET_PARAM.bat
)


:begin

::4执行
set d=%date:~0,10%
set t=%time:~0,8%

%~d0

cd %~dp0

cd..

cd data-integration

if _%interactive%_ equ _0_ cls

echo ===========================================================
echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Kettle作业文件路径：%fileName%
echo Kettle控制台日志文件为："%~dp0log\%~n0%d:/=-%_%t::=-%.log"
echo Kettle运行此资源库中的作业：%rName%:%jName%
echo Kettle参数：%pList% 
echo Kettle日志级别：%loglevel%
echo ===========================================================
echo 运行中...      Ctrl+C结束程序

::执行Pan
set c=%kCommand% -rep:%rName% -user:admin -pass:admin -level:%loglevel% -job:%jName%%pList%
if _%interactive%_ neq _0_ echo %c%
call %c%>>"%~dp0log\%~n0%d:/=-%_%t::=-%.log"

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit /b 0