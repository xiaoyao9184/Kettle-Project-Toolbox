@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2015-04-07
::FILE TIMING_ADD
::DESC add a kettle dispatch bat script into timing tasks


:v

::1变量赋值
set tip=Kettle调度程序：添加计划任务
set ver=1.0
set runTime=
set scriptName=

set echoscriptName=需要输入Kettle运行调度脚本名称
set esetscriptName=请输入Kettle运行调度脚本名称，然后回车：
set echorunTime=需要输入计划任务运行时间（例如：14:00），不输入将以当期时间作为计划任务运行时间：
set esetrunTime=请输入计划任务运行时间，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle调度程序：添加计划任务
echo 运行结束后根据具体情况是否关闭
echo ...


:check

::3变量检验 参数处理
set t=%time:~0,5%
if "%runTime%"=="" (
	echo %echorunTime%%t%
	set /p runTime=%esetrunTime%
	if "%runTime%"=="" (
		set runTime=%t%
	)
)

if "%scriptName%"=="" (
	echo %echoscriptName%
	set /p scriptName=%esetscriptName%
)


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo AT计划任务时间：%runTime%
echo Kettle运行脚本名称：%scriptName%
echo 运行中...      Ctrl+C结束程序

::执行AT添加
at %runTime% /every:m,t,w,th,f,s,su %~dp0%scriptName%

::是否运行
set /p runScript=是否现在就运行任务(Y/N)
if "%runScript%"=="Y" (
	echo 请勿关闭......
	start "" "%~dp0%scriptName%"
)

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit