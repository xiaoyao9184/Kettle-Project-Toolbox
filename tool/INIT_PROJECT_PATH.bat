@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2017-08-22
::FILE INIT_PROJECT_PATH
::DESC init file repository as project directory


:v

::1变量赋值
set tip=Kettle项目工具：初始化项目资源库
set ver=1.0
set rName=

set echorName=需要输入项目资源库名称名称
set esetrName=请输入名称，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle项目工具：初始化项目资源库
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
echo Kettle将生成此资源库的项目目录：%rName%
echo Kettle将生成项目目录到：（引擎同级目录）
echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call kitchen -file:%~dp0CreateProjectRepository.kjb "-param:rName=%rName%"

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit \b