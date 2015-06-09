@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.1
::TIME 2015-05-28
::FILE RUN_J_BLOG_FSREP
::DESC run a job with base log in filesystem repositorie 


:v

::1变量赋值
set tip=Kettle调度程序：运行资源库作业
set ver=1.0
set rName=
set jName=

set echorName=需要输入Kettle文件资源库名称
set esetrName=请输入Kettle文件资源库名称，然后回车：
set echojName=需要输入Kettle作业名称
set esetjName=请输入Kettle作业名称，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle调度程序：运行资源库作业
echo 请勿关闭！！！
echo ...


:check

::3变量检验 参数处理
if "%rName%"=="" (
	echo %echorName%
	set /p rName=%esetrName%
)

if "%jName%"=="" (
	echo %echojName%
	set /p jName=%esetjName%
)


:begin

::4执行
set d=%date:~0,10%
set t=%time:~0,8%

%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Kettle运行此资源库中的作业：%rName%:%jName%
echo Kettle日志文件为："%~dp0log\%jName%%d:/=-%_%t::=-%.log"
echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call kitchen -rep:%rName% -user:admin -pass:admin -job:%jName% -level:Basic>>"%~dp0log\%jName%%d:/=-%_%t::=-%.log"

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit