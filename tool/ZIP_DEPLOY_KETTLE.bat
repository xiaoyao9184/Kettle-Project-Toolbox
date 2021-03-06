@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-05-28
::FILE ZIP_DEPLOY_KETTLE
::DESC create kettle config zip file for deploy


:v

::1变量赋值
set tip=Kettle部署工具：生成部署文件
set ver=1.0
::double-clicking is outer call and will set 0
set interactive=1
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 set interactive=0
::set kettle environment
set rNameRegex=%1

set echorNameRegex=需要输入Kettle文件资源库名称（或正则表达式，默认：.*）
set esetrNameRegex=请输入名称或正则表达式，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle部署工具：生成KETTLE配置部署文件
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%rNameRegex%"=="" (
	echo %echorNameRegex%
	set /p rNameRegex=%esetrNameRegex%
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
echo Kettle将生成此资源库的KETTLE配置部署文件：%rNameRegex%
echo Kettle将生成部署文件到：%USERPROFILE%\.kettle\[Deploy].kettle.zip
echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call kitchen -file:%~dp0ZipDeploy4KettleConfig.kjb "-param:rNameRegex=%rNameRegex%" "-param:notRegex=.*\.backup$|.*\.log$|.*\.git\\.*|.*db\.cache.*" "-param:regex=kettle.properties|repositories.xml|shared.xml""%isOpenShell%

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