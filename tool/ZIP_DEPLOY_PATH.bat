@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-20
::FILE ZIP_DEPLOY_PATH
::DESC create a zip file for deploy in filesystem path


:v

::1变量赋值
set tip=Kettle部署工具：生成部署补丁
set ver=1.0
::double-clicking is outer call and will set 0
set interactive=1
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 set interactive=0
::set kettle environment
set srcPath=%1

set echosrcPath=需要输入文件夹路径（默认为E:/Kettle）
set esetsrcPath=请输入文件夹路径，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle部署工具：生成文件夹部署补丁
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%srcPath%"=="" (
	echo %echosrcPath%
	set /p srcPath=%esetsrcPath%
)

if _%interactive%_ equ _0_ (
	set isOpenShell= "-param:isOpenShell=true"
)


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Kettle将生成此文件夹的部署补丁：%srcPath%
echo Kettle将生成部署文件到：（%srcPath%同级目录）
echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call kitchen -file:%~dp0ZipDeploy4Path.kjb "-param:srcPath=%srcPath%" "-param:notRegex=.*\.backup$|.*\.log$|.*\.git\\.*|.*db\.cache.*|.*data-integration.*" "-param:regex=.*"%isOpenShell%

::执行完毕
if %errorlevel% equ 0 (
    echo 已经执行完毕，可以结束此程序
) else (
    echo 执行脚本，发现错误！
)

if _%interactive%_ equ _0_ pause


:end

::5退出

exit /b %errorlevel%