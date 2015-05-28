@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-05-28
::FILE ZIP_DEPLOY_PATCH_FSREP
::DESC create a zip patch file for deploy in filesystem repositorie


:v

::1变量赋值
set tip=Kettle部署工具：生成部署补丁
set ver=1.0
set rName=%1

set echorName=需要输入Kettle文件资源库名称
set esetrName=请输入Kettle文件资源库名称，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle部署工具：生成资源库部署补丁
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
echo Kettle将生成此资源库的部署补丁：%rName%
echo Kettle将生成部署补丁到：（资源库同级目录）
echo 运行中...      Ctrl+C结束程序

::执行Pan
call pan -file:%~dp0ZipDeployPatch4FSREP.ktr "-param:rName=%rName%"

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit