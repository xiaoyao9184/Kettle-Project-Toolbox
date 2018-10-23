@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-10
::FILE LINK_KPT
::DESC create a symbolic link for Kettle-Scheduling-Scripts(this directory)


:v

::1变量赋值
set tip=Kettle基本工具：生成目录链接
set ver=1.0
set linkPath=%1
set pdiPath=%2
::not set param set 0
set interactive=1
if "%1" equ "" set interactive=0

set echo_linkPath=需要输入KPT链接目录路径
set eset_linkPath=请输入路径或拖动目录到此，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle基本工具：链接KPT目录
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%linkPath%"=="" (
	echo %echo_linkPath%
	set /p linkPath=%eset_linkPath%
)


:begin

::4执行
%~d0

cd %~dp0

cd ..

set kptPath=%cd%

cd %~dp0

if not exist %linkPath% (
    md %linkPath%
)
set linkToolPath=%linkPath%\tool
set linkDefaultPath=%linkPath%\default
set linkWindowsPath=%linkPath%\Windows
set linkPdiPath=%linkPath%\data-integration


echo KPT目录为：%kptPath%
echo 链接目录为：%linkPath%
echo 运行中...      Ctrl+C结束程序

::执行MKLink
if _%interactive%_ equ _0_ (
	cls
) else  (
	echo 冲突策略：强制替换已经存在的实体目录或链接目录
    set param=noskip force
)

echo ===========================================================
echo 链接工具目录（tool\）
call LINK_FOLDER.bat "%linkToolPath%" "%kptPath%\tool" %param%


echo ===========================================================
echo 链接默认资源库目录（default\）
call LINK_FOLDER.bat "%linkDefaultPath%" "%kptPath%\default" %param%


echo ===========================================================
echo 链接脚本目录（Windows\）
call LINK_FOLDER.bat "%linkWindowsPath%" "%kptPath%\Windows" %param%


echo ===========================================================
echo 链接Kettle引擎目录（data-integration\）
if "%pdiPath%"=="" (
	call LINK_FOLDER.bat "%linkPdiPath%"
) else (
	call LINK_FOLDER.bat "%linkPdiPath%" "%pdiPath%" %param%
)


::执行完毕
if %errorlevel% equ 0 (
    echo 已经执行完毕，可以结束此程序
) else (
    echo 执行脚本，发现错误！
)

if _%interactive%_ equ _0_ pause


:end

::5退出

exit /b 0