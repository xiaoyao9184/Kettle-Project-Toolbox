@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-10
::FILE LINK_TOOL
::DESC create a symbolic link for tool directory(this directory)


:v

::1变量赋值
set tip=Kettle基本工具：生成目录联接
set ver=1.0
set tarPath=%1

set echotarPath=需要输入虚拟tool目录路径（虚拟的即目标tool目录）
set esettarPath=请输入路径或拖动目录到此，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle基本工具：生成Tool目录联接
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%tarPath%"=="" (
	echo %echotarPath%
	set /p tarPath=%esettarPath%
)


:begin

::4执行
%~d0

cd %~dp0

set srcPath=%~dp0

if exist %tarPath% (
	for %%i in (%tarPath%) do (
		for /f %%j in ('echo %%~ai^|find /i "-l"') do ( 
			choice /c dre /m 目标tool文件夹已经是符号联接，删除联接^(D^)；替换联接^(R^)；退出^(E^)？ /t 10  /d e
			if !errorlevel! equ 1 goto dele
			if !errorlevel! equ 2 goto replace
			if !errorlevel! equ 3 goto quit
		)
	)
	
	choice /c yn /m 目标tool文件夹已经存在，删除文件夹后建立联接^(Y^)；取消^(N^)？ /t 10  /d n
	if !errorlevel! equ 1 goto replace
	if !errorlevel! equ 2 goto quit
	
:quit
	echo 取消本程序，退出...
	goto endwait
:dele
	rd /s /q %tarPath%
	echo 删除目标tool目录完毕
	goto quit
:replace
	rd /s /q %tarPath%
	echo 删除目标tool目录完毕
)

echo Kettle实际tool目录为：%srcPath%
echo Kettle虚拟tool目标为：%tarPath%
echo Kettle工作目录为：%~dp0
echo Kettle将为此目录建立联接：%tarPath%；联接到：%srcPath%
echo 运行中...      Ctrl+C结束程序

::执行MKLink
mklink /j %tarPath% %srcPath% 

::执行完毕
echo 已经执行完毕，可以结束此程序


:endwait
pause

:end

::5退出

exit