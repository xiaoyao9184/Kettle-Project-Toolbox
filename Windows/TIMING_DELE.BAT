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
set taskscriptName=
set scriptName=

set echotaskscriptName=需要输入Kettle运行调度脚本名称（应该与Kettle资源库相同）
set esettaskscriptName=请输入Kettle运行调度脚本名称，然后回车：
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
if "%taskscriptName%"=="" (
	echo %echotaskscriptName%
	set /p taskscriptName=%esettaskscriptName%
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
echo AT计划任务名称：%taskscriptName%
echo Kettle结束脚本名称：%scriptName%
echo 运行中...      Ctrl+C结束程序

::执行AT
echo 查找命令行为“%~dp0%taskscriptName%”的作业ID（命令行中不要有空格）

for /f "skip=2 tokens=1,4*" %%a in ('at') do (
	::取得有一个空格的命令行路径
	if "%%c"=="" (
		set batpath=%%b
	)else set batpath=%%b %%c

	::提示文本
	echo ID=%%a 命令行=!batpath!
	
	::设置ID变量
	if "!batpath!"=="%~dp0%scriptName%" set id=%%a
)

::提示文本
echo 查找到的作业ID为：%id%

if not "%id%"=="" (
	echo 结束AT定时作业...

	at %id% /Delete

	echo 结束完成
)else echo AT定时作业未找到

::是否结束
set /p runScript=是否要结束正在运行的任务(Y/N)
if "runScript"=="Y" (
	echo 请勿关闭......
	start "" "%~dp0%scriptName%"
)

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit