@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2015-05-24
::FILE COPY_REP_CFG
::DESC copy one or more repository config xml node to new file(extraction deployment configuration)


:v

::1变量赋值
set tip=Kettle部署工具：提取部署配置
set ver=1.0
set rNameRegex=%1

set echorNameRegex=需要输入Kettle文件资源库名称(或正则表达式)
set esetrNameRegex=请输入Kettle文件资源库名称(或正则表达式)，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle部署工具：提取资源库配置
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理
if "%rNameRegex%"=="" (
	echo %echorNameRegex%
	set /p rNameRegex=%esetrNameRegex%
)


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0
echo Kettle将提取匹配此正则表达式资源库配置文件：%rNameRegex%
echo 运行中...      Ctrl+C结束程序

::执行Pan
pan -file:%~dp0CopyRepositoryConfig.ktr "-param:rNameRegex=%rNameRegex%"

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit