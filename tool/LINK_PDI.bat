@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-10
::FILE LINK_PDI
::DESC create a symbolic link(in this parent directory) for data-integration directory


:v

::1变量赋值
set tip=Kettle基本工具：生成目录联接
set ver=1.0
set pdiPath=%1

set echopdiPath=需要输入实际Kettle引擎目录路径（实际的即源data-integration目录）
set esetpdiPath=请输入路径或拖动目录到此，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle基本工具：生成Kettle引擎目录联接
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%pdiPath%"=="" (
	echo %echopdiPath%
	set /p pdiPath=%esetpdiPath%
)


:begin

::4执行
%~d0

cd %~dp0

cd..

set tarPath=%cd%\data-integration

if exist data-integration (
	for %%i in (data-integration) do (
		for /f %%j in ('echo %%~ai^|find /i "-l"') do ( 
			choice /c dre /m 目标data-integration文件夹已经是符号联接，删除联接^(D^)；替换联接^(R^)；退出^(E^)？ /t 10  /d e
			if !errorlevel! equ 1 goto dele
			if !errorlevel! equ 2 goto replace
			if !errorlevel! equ 3 goto quit
		)
	)
	
	choice /c yn /m 目标data-integration文件夹已经存在，删除文件夹后建立联接^(Y^)；取消^(N^)？ /t 10  /d n
	if !errorlevel! equ 1 goto replace
	if !errorlevel! equ 2 goto quit
	
:quit
	echo 取消本程序，退出...
	goto endwait
:dele
  rd /s /q data-integration
	echo 删除目标data-integration目录完毕
	goto quit
:replace
	rd /s /q data-integration
	echo 删除目标data-integration目录完毕
)

echo Kettle实际引擎目录为：%pdiPath%
echo Kettle虚拟引擎目录为：%tarPath%
echo Kettle工作目录为：%~dp0
echo Kettle将为此目录建立联接：%tarPath%；联接到：%pdiPath%
echo 运行中...      Ctrl+C结束程序

::执行MKLink
mklink /j "%tarPath%" "%pdiPath%" 

::执行完毕
echo 已经执行完毕，可以结束此程序


:endwait
pause

:end

::5退出

exit /b