@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.1
::TIME 2015-04-08
::FILE TIMING_ADD
::DESC add a kettle dispatch bat script into timing tasks


:v

::1������ֵ
set tip=Kettle���ȳ������Ӽƻ�����
set ver=1.0
set runTime=
set scriptName=

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
echo AT�ƻ�����ʱ�䣺%runTime%
echo Kettle���нű����ƣ�%scriptName%
echo ������...      Ctrl+C��������

::ִ��AT����
at %runTime% /every:m,t,w,th,f,s,su "'%~dp0%scriptName%'"

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