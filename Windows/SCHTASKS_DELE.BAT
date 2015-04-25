@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2015-04-07
::FILE SCHTASKS_ADD
::DESC dele a kettle dispatch bat script from scheduled tasks


:v

::1变量赋值
set tip=Kettle调度程序：删除计划任务
set ver=1.0
set taskName=
set scriptName=

set echotaskName=需要输入计划任务名称（最好与Kettle资源库相同）
set esettaskName=请输入计划任务名称，然后回车：
set echoscriptName=需要输入Kettle结束调度脚本名称
set esetscriptName=请输入Kettle结束调度脚本名称，然后回车：


:title

::2提示文本
title %tip% %ver%

echo Kettle调度程序：删除计划任务
echo 运行结束后根据具体情况是否关闭
echo ...


:check

::3变量检验 参数处理
if "%taskName%"=="" (
	echo %echotaskName%
	set /p taskName=%esettaskName%
)

if "%scriptName%"=="" (
	echo %echoscriptName%
	set /p jName=%esetscriptName%
)


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Schtasks计划任务名称：%taskName%
echo Kettle结束脚本名称：%scriptName%
echo 运行中...      Ctrl+C结束程序

::执行schtasks
schtasks /delete /tn %taskName% /f

::是否结束
set /p runScript=是否要结束正在运行的任务(Y/N)
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