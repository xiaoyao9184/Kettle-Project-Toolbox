@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-05-28
::FILE COPY_REP_CFG
::DESC copy one or more repository config xml node to new file(extraction deployment configuration)


:v

::1变量赋值
set tip=Kettle部署工具：提取部署配置
set ver=1.0
set rNameRegex=%1
set tarREP=%2

set echorNameRegex=需要输入Kettle文件资源库名称（或正则表达式）
set esetrNameRegex=请输入Kettle文件资源库名称（或正则表达式），然后回车：
set echotarREP=需要输入目标Kettle文件资源库路径（用于输出）
set esettarREP=请输入目标Kettle文件资源库路径，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle部署工具：提取资源库配置
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%rNameRegex%"=="" (
	echo %echorNameRegex%
	set /p rNameRegex=%esetrNameRegex%
)

if "%1"=="" (
	choice /c yn /m 使用默认输出路径？ /t 5 /d y
	if !errorlevel! equ 1 goto default
	if !errorlevel! equ 2 goto user
)

if "%tarREP%"=="" (
	goto default
)
goto begin

::默认位置
:default
echo 使用默认位置
set tarREP=%USERPROFILE%\.kettle\[Copy]repositories.xml
goto begin

::用户输入位置
:user
echo 使用用户输入位置
if "%tarREP%"=="" (
	echo %echotarREP%
	set /p tarREP=%esettarREP%
)
goto begin


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Kettle将提取匹配此正则表达式资源库配置文件：%rNameRegex%
echo Kettle将提取资源库配置文件到：%tarREP%
echo 运行中...      Ctrl+C结束程序

::执行Pan
call pan -file:%~dp0CopyRepositoryConfig.ktr "-param:rNameRegex=%rNameRegex%" "-param:tarREP=%tarREP%"

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit