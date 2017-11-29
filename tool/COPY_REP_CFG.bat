@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-19
::FILE COPY_REP_CFG
::DESC copy one or more repository config data(s) to a new file or merger to a exist file


:v

::1变量赋值
set tip=Kettle复制工具：复制资源库
set ver=1.0
set rNameRegex=
set rNameRemove=
set rNameReplace=
set rNameNew=
set rPath=
set rPathType=
set srcREP=
set tarREP=

set echorName=需要输入Kettle文件资源库名称（准确名称，默认：dev.*）
set esetrName=请输入名称，然后回车：

set echorNameRegex=需要输入Kettle文件资源库名称过滤正则表达式（默认：dev.*）
set esetrNameRegex=请输入正则表达式，然后回车：

set echorNameRemove=需要输入资源库名称搜索参数（用于查找字符，默认：dev）
set esetrNameRemove=请输入一个包含在名称中的字符串，然后回车：

set echorNameReplace=需要输入资源库名称替换参数（用于将查找字符替换，默认空）
set esetrNameReplace=请输入一个用于替换的字符串，然后回车：

set echorNameNew=需要输入自定义资源库名称（用于标识复制的新数据）
set esetrNameNew=请输入字符串，然后回车：

set echorPath=需要输入目标资源库文件夹路径（新配置将指向此路径作为资源库的存储位置）
set esetrPath=请输入文件夹路径或拖动文件夹到此，然后回车：

set echosrcREP=需要输入Kettle资源库配置文件路径（用于输入）
set esetsrcREP=请输入文件路径或拖动文件到此，然后回车：

set echotarREP=需要输入Kettle资源库配置文件路径（用于输出）
set esettarREP=请输入文件路径或拖动文件到此，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle复制工具：复制文件资源库配置
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理

choice /c yn /m 复制一个配置^(Y^)，批量复制多个配置^(N，默认^)？ /t 5 /d n
	if !errorlevel! equ 1 goto one
	if !errorlevel! equ 2 goto more
	
:one
	set tempOm=one
	if "%rNameRegex%"=="" (
		echo %echorName%
		set /p rNameRegex=%esetrName%
	)

	choice /c yn /m 对要复制的资源库配置，自定义一个新名称^(Y^)，还是对旧名称进行替换^(N，默认^)？ /t 10 /d n
		if !errorlevel! equ 1 goto namenew
		if !errorlevel! equ 2 goto namereplace
	
	:namenew
		set tempName=new
		if "%rNameNew%"=="" (
			echo %echorNameNew%
			set /p rNameNew=%esetrNameNew%
		)
	
		goto nameend
	
	:namereplace
		set teampname=replace
		if "%rNameRemove%"=="" (
			echo %echorNameRemove%
			set /p rNameRemove=%esetrNameRemove%
		)
		
		if "%rNameReplace%"=="" (
			echo %echorNameReplace%
			set /p rNameReplace=%esetrNameReplace%
		)
	
	:nameend
		goto omend

:more
	set tempOm=more
	if "%rNameRegex%"=="" (
		echo %echorNameRegex%
		set /p rNameRegex=%esetrNameRegex%
	)
	
	set tempName=replace
	if "%rNameRemove%"=="" (
		echo %echorNameRemove%
		set /p rNameRemove=%esetrNameRemove%
	)
	
	if "%rNameReplace%"=="" (
		echo %echorNameReplace%
		set /p rNameReplace=%esetrNameReplace%
	)

:omend

choice /c yn /m 需要指定新资源库文件夹路径吗？（默认与旧文件夹同级，与新资源库名称同名） /t 10 /d n
	if !errorlevel! equ 1 goto path
	if !errorlevel! equ 2 goto pathend

:path
	if "%rPath%"=="" (
		echo %echorPath%
		echo （当输入的路径以\结尾，将被判定为模糊路径，并作为新资源库文件夹的父级路径使用）
		set /p rPath=%esetrPath%
	)
	
	echo %rPath%end|findstr /o /r /c:\\end >cmd.tmp
	for /f %%i in (cmd.tmp) do (
		set isDir=%%i
	)
	del cmd.tmp

	if not "%isDir%"=="" (
		choice /c yn /m 复制的新资源库文件夹，沿用旧文件夹名称^(Y^)，与新资源库名称同名^(N，默认^)？ /t 15 /d n
			if !errorlevel! equ 1 set rPathType=1
			if !errorlevel! equ 2 set rPathType=0
	)
:pathend

choice /c yn /m 需要指定资源库配置文件输入、输出位置吗（默认不指定）？ /t 5 /d n
	if !errorlevel! equ 1 goto user
	if !errorlevel! equ 2 goto default

:user
	set tempUser=user
	if "%srcREP%"=="" (
		echo %echosrcREP%
		set /p srcREP=%esetsrcREP%
	)

	if "%tarREP%"=="" (
		echo %echotarREP%
		set /p tarREP=%esettarREP%
	)

	goto uesrend

:default
	set tempUser=default

:uesrend

:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0

set tempParam="-param:rNameRegex=%rNameRegex%"

if "%tempUser%"=="default" (
	echo Kettle将使用用户.kettle目录中的资源库配置文件作为输入、输出位置
)else (
	echo Kettle将读取数据从此资源库配置文件：%srcREP%
	echo Kettle将写入数据到此资源库配置文件：%tarREP%
	set tempParam=%tempParam% "-param:srcREP=%srcREP%" "-param:tarREP=%tarREP%"
)

if "%tempOm%"=="one" (
	echo Kettle将复制此资源库的 配置数据：%rNameRegex%
)else (
	echo Kettle将复制匹配此正则表达式的资源库 配置数据：%rNameRegex%
)

echo Kettle将不会复制 配置文件夹

if "%tempName%"=="new" (
	echo Kettle将命名 配置名称 为：%rNameNew%
	set tempParam=%tempParam% "-param:rNameNew=%rNameNew%"
)else (
	echo Kettle将替换 配置名称 为：%rNameRemove% -^> %rNameReplace%
	set tempParam=%tempParam% "-param:rNameRemove=%rNameRemove%" "-param:rNameReplace=%rNameReplace%"
)

if "%rPath%"=="" (
	echo Kettle将修改 配置路径 ，与旧配置在同级目录，并已 配置名称 命名文件夹 
)else (
	echo Kettle将修改 配置^(父级^)路径 为：%rPath%
	if "%rPathType%"=="1" (
		echo Kettle将沿用旧 配置文件夹 名称
		set tempParam=!tempParam! "-param:rPathType=%rPathType%"
	)else (
		echo Kettle将修改 配置文件夹 名称与 配置名称 相同
		set tempParam=!tempParam! "-param:rPathType=%rPathType%"
	)
	set tempParam=!tempParam! "-param:rPath=%rPath% "
)

echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call kitchen -file:%~dp0CopyRepositoryData.kjb %tempParam%
::echo %tempParam%

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit /b