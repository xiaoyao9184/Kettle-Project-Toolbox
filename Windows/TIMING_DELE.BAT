@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2015-04-07
::FILE SCHTASKS_ADD
::DESC dele a kettle dispatch bat script from scheduled tasks


:v

::1������ֵ
set tip=Kettle���ȳ���ɾ���ƻ�����
set ver=1.0
set taskscriptName=
set scriptName=

set echotaskscriptName=��Ҫ����Kettle���е��Ƚű����ƣ�Ӧ����Kettle��Դ����ͬ��
set esettaskscriptName=������Kettle���е��Ƚű����ƣ�Ȼ��س���
set echoscriptName=��Ҫ����Kettle�������Ƚű�����
set esetscriptName=������Kettle�������Ƚű����ƣ�Ȼ��س���


:title

::2��ʾ�ı�
title %tip% %ver%

echo Kettle���ȳ���ɾ���ƻ�����
echo ���н�������ݾ�������Ƿ�ر�
echo ...


:check

::3�������� ��������
if "%taskscriptName%"=="" (
	echo %echotaskscriptName%
	set /p taskscriptName=%esettaskscriptName%
)

if "%scriptName%"=="" (
	echo %echoscriptName%
	set /p scriptName=%esetscriptName%
)


:begin

::4ִ��
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle����Ŀ¼Ϊ��%cd%
echo Kettle����Ŀ¼Ϊ��%~dp0
echo AT�ƻ��������ƣ�%taskscriptName%
echo Kettle�����ű����ƣ�%scriptName%
echo ������...      Ctrl+C��������

::ִ��AT
echo ����������Ϊ��%~dp0%taskscriptName%������ҵID���������в�Ҫ�пո�

for /f "skip=2 tokens=1,4*" %%a in ('at') do (
	::ȡ����һ���ո��������·��
	if "%%c"=="" (
		set batpath=%%b
	)else set batpath=%%b %%c

	::��ʾ�ı�
	echo ID=%%a ������=!batpath!
	
	::����ID����
	if "!batpath!"=="%~dp0%scriptName%" set id=%%a
)

::��ʾ�ı�
echo ���ҵ�����ҵIDΪ��%id%

if not "%id%"=="" (
	echo ����AT��ʱ��ҵ...

	at %id% /Delete

	echo �������
)else echo AT��ʱ��ҵδ�ҵ�

::�Ƿ����
set /p runScript=�Ƿ�Ҫ�����������е�����(Y/N)
if "runScript"=="Y" (
	echo ����ر�......
	start "" "%~dp0%scriptName%"
)

::ִ�����
echo �Ѿ�ִ����ϣ����Խ����˳���

pause


:end

::5�˳�

exit