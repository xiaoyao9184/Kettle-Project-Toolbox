@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-11
::FILE COPY_REP
::DESC copy one or more repository config data(s) and file(s)


:v

::1变量赋值
set tip=Kettle复制工具：复制资源库
set ver=1.0
set rNameRegex=
set rNameRemove=
set rNameReplace=
set rNameNew=
set rDir=
set rPath=
set srcREP=
set tarREP=
set isCopyFile=

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

set echorDir=需要输入资源库文件夹父级路径（由于要复制多个配置，无法将多个配置指向一个具体的文件夹）
set esetrDir=请输入文件夹路径或拖动文件夹到此，然后回车：

set echorPath=需要输入目标资源库文件夹路径（新配置将指向此路径作为资源库的存储位置）
set esetrPath=请输入文件夹路径或拖动文件夹到此，然后回车：

set echosrcREP=需要输入Kettle资源库配置文件路径（用于输入）
set esetsrcREP=请输入文件路径或拖动文件到此，然后回车：

set echotarREP=需要输入Kettle资源库配置文件路径（用于输出）
set esettarREP=请输入文件路径或拖动文件到此，然后回车：

:title

::2提示文本
title %tip% %ver%

echo Kettle复制工具：复制文件资源库
echo 运行结束后可以关闭
echo ...


:check

::3变量检验 参数处理

choice /c yn /m 复制一个配置^(Y^)，多个配置^(N^)？ /t 5 /d n
	if !errorlevel! equ 1 goto one
	if !errorlevel! equ 2 goto more
	
:one
	set tempOm=one
	if "%rNameRegex%"=="" (
		echo %echorName%
		set /p rNameRegex=%esetrName%
	)

	choice /c yn /m 对要复制的资源库配置，自定义一个新名称^(Y^)，还是对旧名称进行替换^(N^)？ /t 10 /d n
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
	
	choice /c yn /m 需要指定资源库路径吗？ /t 5 /d n
		if !errorlevel! equ 1 goto path
		if !errorlevel! equ 2 goto omend

	:path
		if "%rPath%"=="" (
			echo %echorPath%
			set /p rPath=%esetrPath%
		)
	
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
	
	choice /c yn /m 需要指定资源库父级路径吗？ /t 5 /d n
		if !errorlevel! equ 1 goto dir
		if !errorlevel! equ 2 goto omend

	:dir
		if "%rDir%"=="" (
			echo %echorDir%
			set /p rDir=%esetrDir%
		)

:omend

choice /c yn /m 需要指定资源库配置文件输入、输出位置吗？ /t 5 /d n
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

	goto begin

:default
	set tempUser=default


choice /c yn /m 需要指定复制资源库文件夹吗？ /t 5 /d n
	if !errorlevel! equ 1 set isCopyFile=1
	if !errorlevel! equ 2 set isCopyFile=0


:begin

::4执行
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle引擎目录为：%cd%
echo Kettle工作目录为：%~dp0

set tempParam="-param:rNameRegex=%rNameRegex%" "-param:isCopyFile=%isCopyFile%"

if "%tempUser%"=="default" (
	echo Kettle将使用用户.kettle目录中的资源库配置文件作为输入、输出位置
)else (
	echo Kettle将读取数据从此资源库配置文件：%srcREP%
	echo Kettle将写入数据到此资源库配置文件：%tarREP%
	set tempParam=%tempParam% "-param:srcREP=%srcREP%" "-param:tarREP=%tarREP%"
)

if "%tempOm%"=="one" (
	echo Kettle将复制此资源库的配置数据：%rNameRegex%
)else (
	echo Kettle将复制匹配此正则表达式的资源库配置数据：%rNameRegex%
)

if "%tempName%"=="new" (
	echo Kettle将配置数据命名为：%rNameNew%
	set tempParam=%tempParam% "-param:rNameNew=%rNameNew%"
)else (
	echo Kettle将对配置数据旧名称进行替换：%rNameRemove% -^> %rNameReplace%
	set tempParam=%tempParam% "-param:rNameRemove=%rNameRemove%" "-param:rNameReplace=%rNameReplace%"
)

if "%tempOm%"=="one" (
	echo Kettle将配置数据路径改为：%rPath%
	set tempParam=%tempParam% "-param:rPath=%rPath% "
)else (
	echo Kettle将配置数据路径统一改为此目录下：%rDir%
	set tempParam=%tempParam% "-param:rDir=%rDir% "
)

echo 运行中...      Ctrl+C结束程序

::执行Kitchen
call kitchen -file:%~dp0CopyRepository.kjb %tempParam%
::echo %tempParam%

::执行完毕
echo 已经执行完毕，可以结束此程序

pause


:end

::5退出

exit \b