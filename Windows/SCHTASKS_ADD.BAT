@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.1
::TIME 2015-04-08
::FILE SCHTASKS_ADD
::DESC add a kettle dispatch bat script into scheduled tasks


:v

::1������ֵ
set tip=Kettle���ȳ������Ӽƻ�����
set ver=1.0
set taskName=
set runTime=
set scriptName=

set echotaskName=��Ҫ����ƻ��������ƣ������Kettle��Դ����ͬ��
set esettaskName=������ƻ��������ƣ�Ȼ��س���
set echoscriptName=��Ҫ����Kettle���е��Ƚű�����
set esetscriptName=������Kettle���е��Ƚű����ƣ�Ȼ��س���
set echorunTime=��Ҫ����ƻ���������ʱ�䣨���磺14:00���������뽫�Ե���ʱ����Ϊ�ƻ���������ʱ�䣺
set esetrunTime=������ƻ���������ʱ�䣬Ȼ��س���

:title

::2��ʾ�ı�
title %tip% %ver%

echo Kettle���ȳ������Ӽƻ�����
echo ���н�������ݾ�������Ƿ�ر�
echo ...


:check

::3�������� ��������
if "%taskName%"=="" (
	echo %echotaskName%
	set /p taskName=%esettaskName%
)

set t=%time:~0,5%
if "%runTime%"=="" (
	echo %echorunTime%%t%
	set /p runTime=%esetrunTime%
	if "!runTime!"=="" (
		set runTime=%t%
	)
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
echo Schtasks�ƻ��������ƣ�%taskName%
echo Schtasks�ƻ�����ʱ�䣺%runTime%
echo Kettle���нű����ƣ�%scriptName%
echo ������...      Ctrl+C��������

::ִ��schtasks
schtasks /create /tn %taskName% /tr "'%~dp0%scriptName%'" /sc daily /st %runTime%

::�Ƿ�����
set /p runScript=�Ƿ����ھ���������(Y/N)
if "%runScript%"=="Y" (
	echo ����ر�......
	start "" "%~dp0%scriptName%"
)

::ִ�����
echo �Ѿ�ִ����ϣ����Խ����˳���

pause


:end

::5�˳�

exit