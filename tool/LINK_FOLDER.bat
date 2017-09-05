@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2017-09-05
::FILE LINK_FOLDER
::DESC create a symbolic link for directory


:v

::1变量赋值
set tip=Kettle基本工具：生成目录联接
set ver=1.0
set linkPath=%1
set targetPath=%2
::not set param set 0
set interactive=1
if "%1" equ "" set interactive=0

set echo_linkPath=需要输入链接（虚拟）目录路径
set eset_linkPath=请输入路径或拖动目录到此，然后回车：

set echo_targetPath=需要输入被链接（目标）目录路径
set eset_targetPath=请输入路径或拖动目录到此，然后回车：

:title

::2提示文本
if _%interactive%_ neq _0_ goto check

title %tip% %ver%

echo Kettle基本工具：生成目录联接
echo 运行结束后可以关闭
echo ...

:check

::3变量检验 参数处理
if "%linkPath%"=="" (
	echo %echo_linkPath%
	set /p linkPath=%eset_linkPath%
)
if "%targetPath%"=="" (
	echo %echo_targetPath%
	set /p targetPath=%eset_targetPath%
)

if exist %linkPath% (
	for %%i in (%linkPath%) do (
		for /f %%j in ('echo %%~ai^|find /i "-l"') do ( 
			choice /c dre /m 联接目录已经是符号联接，删除联接^(D^)；替换联接^(R^)；保持不变^(默认E^)？ /t 10  /d e
			if !errorlevel! equ 1 goto dele
			if !errorlevel! equ 2 goto replace
			if !errorlevel! equ 3 goto quit
		)
	)
	
	choice /c yn /m 联接目录文件夹已经存在，删除文件夹后建立联接^(Y^)；取消^(N^)？ /t 10  /d n
	if !errorlevel! equ 1 goto replace
	if !errorlevel! equ 2 goto quit
	
:quit
	echo 未执行任何操作，退出...
	if _%interactive%_ equ _0_ pause
	goto end
:dele
	rd /s /q %linkPath%
	echo 删除联接目录，退出...
        pause
	goto end
:replace
	rd /s /q %linkPath%
	echo 删除联接目录完毕
)

:begin

::4执行
%~d0

cd %~dp0

if _%interactive%_ neq _0_ goto call

echo Kettle虚拟目标为：%linkPath%
echo Kettle实际目录为：%targetPath%
echo 运行中...      Ctrl+C结束程序

::执行MKLink
:call
set c=mklink /j %linkPath% %targetPath% 
if _%interactive%_ equ _0_ echo %c%
call %c%

::执行完毕
if _%interactive%_ equ _0_ echo 已经执行完毕，可以结束此程序


:endwait
if _%interactive%_ equ _0_ pause


:end

::5退出

exit /b 0