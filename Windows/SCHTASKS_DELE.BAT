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
set taskName=
set scriptName=

set echotaskName=��Ҫ����ƻ��������ƣ������Kettle��Դ����ͬ��
set esettaskName=������ƻ��������ƣ�Ȼ��س���
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
if "%taskName%"=="" (
	echo %echotaskName%
	set /p taskName=%esettaskName%
)

if "%scriptName%"=="" (
	echo %echoscriptName%
	set /p jName=%esetscriptName%
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
echo Kettle�����ű����ƣ�%scriptName%
echo ������...      Ctrl+C��������

::ִ��schtasks
schtasks /delete /tn %taskName% /f

::�Ƿ����
set /p runScript=�Ƿ�Ҫ�����������е�����(Y/N)
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