@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2017-08-21
::FILE RUN_SPOON
::DESC run spoon with customize KETTLE_HOME


:v

::1变量赋值
set tip=Kettle调度程序：运行Spoon
set ver=1.0
set KETTLE_HOME=
set KETTLE_REPOSITORY=
::current folder
for %%a in (.) do set current_folder=%%~na
::double-clicking is outer call and will set 0
set interactive=1
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 set interactive=0

set echo_use_project_kettle_home=使用项目KETTLE_HOME目录！
set echo_use_user_kettle_home=使用用户KETTLE_HOME目录！
set echo_use_dir_name_as_repositorie_name=使用项目目录名作为默认连接资源库！

:title

::2提示文本
title %tip% %ver%

echo Kettle调度程序：运行Spoon
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if exist .kettle (
    echo %echo_use_project_kettle_home%
    set KETTLE_HOME=%cd%
) else ( 
    echo %echo_use_user_kettle_home%
)

set "_temp_file_repository=0"

if exist .kettle (
    set _temp_file_repository=1
)
if exist .meta (
    set _temp_file_repository=1
)
if exist repository.log (
    set _temp_file_repository=1
)
if exist *.kdb (
    set _temp_file_repository=1
)
if exist config.xml (
    set _temp_file_repository=1
)
if %_temp_file_repository% equ 1 (
    echo %echo_use_dir_name_as_repositorie_name%
    set KETTLE_REPOSITORY=%current_folder%
)


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo KETTLE_HOME为：%KETTLE_HOME%
echo KETTLE_REPOSITORY为：%KETTLE_REPOSITORY%
echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call Spoon.bat

::执行完毕
if %ERRORLEVEL% equ 0 (
    if _%interactive%_ equ _0_ exit 
)

echo 已经执行完毕，可以结束此程序
pause


:end

::5退出