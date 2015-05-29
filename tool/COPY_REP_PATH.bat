@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-05-29
::FILE COPY_REP_PATH
::DESC copy one filesystem repository folder to new folder


:v

::1变量赋值
set tip=Kettle部署工具：提取部署配置
set ver=1.0
set rName=%1
set tarPath=%2

set echorName=需要输入Kettle文件资源库名称（或正则表达式）
set esetrName=请输入Kettle文件资源库名称（或正则表达式），然后回车：
set echotarPath=需要输入Kettle文件资源库文件夹输出路径
set esettarPath=请输入Kettle文件资源库文件夹输出路径，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle部署工具：复制资源库文件夹
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%rName%"=="" (
	echo %echorName%
	set /p rName=%esetrName%
)

if "%1"=="" (
	choice /c yn /m 使用默认输出路径？ /t 5 /d y
	if !errorlevel! equ 1 goto default
	if !errorlevel! equ 2 goto user
)

if "%tarPath%"=="" (
	goto default
)
goto begin

::默认位置
:default
echo 使用默认位置
set tarPathparam=
goto begin

::用户输入位置
:user
echo 使用用户输入位置
if "%tarPath%"=="" (
	echo %echotarPath%
	set /p tarPath=%esettarPath%
)
REM 此处的空格是为了防止\后缀+"被当作\"发生转义
set tarPathparam="-param:tarPath=%tarPath% "
goto begin


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Kettle将复制此资源库的文件夹：%rName%
echo Kettle将复制资源库文件夹到：%tarPath%
echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call kitchen -file:%~dp0CopyRepositoryPath.kjb "-param:rName=%rName%" %tarPathparam%

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit