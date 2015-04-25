@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2015-04-07
::FILE STOP_ALLJ_NOLOG_FSREP
::DESC stop all job with no log in filesystem repositorie


:v

::1变量赋值
set tip=Kettle调度程序：结束资源库运行
set ver=1.0
set rName=

set echorName=需要输入Kettle文件资源库名称
set esetrName=请输入Kettle文件资源库名称，然后回车：


:title

::2提示文本
title %tip% %ver%

echo Kettle调度程序：结束资源库运行作业
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%rName%"=="" (
	echo %echorName%
	set /p rName=%esetrName%
)


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Kettle结束运行在此资源库中的所有作业：%rName%
echo 运行中...      Ctrl+C结束程序

::执行WMIC结束
wmic process where (name like 'java%%.exe' and commandline like '%%-rep:%rName% -user:admin -pass:admin -job:%%') call terminate

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit