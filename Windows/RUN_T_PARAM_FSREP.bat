@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2015-04-08
::FILE RUN_T_PARAM_NOLOG_FSREP
::DESC run a transformation with param no log in filesystem repositorie 


:v

::1变量赋值
set tip=Kettle调度程序：运行资源库含参转换
set ver=1.0
set rName=
set tName=
set pName=
set pValue=

set echorName=需要输入Kettle文件资源库名称
set esetrName=请输入Kettle文件资源库名称，然后回车：
set echotName=需要输入Kettle转换文件名
set esettName=请输入Kettle转换文件名后，然后回车：
set echopName=需要输入参数名
set esetpName=请输入参数名后，然后回车：
set echopValue=需要输入参数值
set esetpValue=请输入参数值后，然后回车：


:title

::2提示文本
title %tip% %ver%

echo Kettle调度程序：运行资源库含参转换
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%rName%"=="" (
	echo %echorName%
	set /p rName=%esetrName%
)

if "%tName%"=="" (
	echo %echotName%
	set /p tName=%esettName%
)

if "%pName%"=="" (
	echo %echopName%
	set /p pName=%esetpName%
)

if "%~1"=="" (
	echo %echopValue%
	set /p pValue=%esetpValue%
)else set pValue=%~1
	

:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Kettle运行此资源库中的转换：%rName%:%tName%
echo Kettle转换参数为：%pName%=%pValue% 
echo 运行中...      Ctrl+C结束程序

::执行Pan
Pan -rep:%rName% -user:admin -pass:admin -job:%tName% "-param:%pName%=%pValue%"

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit