@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-20
::FILE ZIP_DEPLOY_FSREP
::DESC create a zip file for deploy in filesystem repositorie


:v

::1变量赋值
set tip=Kettle部署工具：生成部署文件
set ver=1.0
set rName=%1

set echorName=需要输入Kettle文件资源库名称（默认为：.*，将第一个作为标准）
set esetrName=请输入名称，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle部署工具：生成资源库部署文件
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
echo Kettle将生成此资源库的部署文件：%rName%
echo Kettle将生成部署文件到：（资源库同级目录）
echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call kitchen -file:%~dp0ZipDeploy4RepositoryFile.kjb "-param:rNameRegex=%rName%" "-param:notRegex=.*\.backup$|.*\.log$|.*\.git.*|.*db\.cache.*" "-param:regex=.*"

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit \b