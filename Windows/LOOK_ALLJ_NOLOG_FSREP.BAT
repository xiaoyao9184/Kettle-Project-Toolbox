@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2015-04-07
::FILE LOOK_ALLJ_NOLOG_FSREP
::DESC look all job with no log in filesystem repositorie


:v

::1������ֵ
set tip=Kettle���ȳ��򣺲鿴��Դ��������ҵ
set ver=1.0
set rName=

set echorName=��Ҫ����Kettle�ļ���Դ������
set esetrName=������Kettle�ļ���Դ�����ƣ�Ȼ��س���


:title

::2��ʾ�ı�
title %tip% %ver%

echo Kettle���ȳ��򣺲鿴��Դ������
echo ���н�������Թر�
echo ...


:check

::3�������� ��������
if "%rName%"=="" (
	echo %echorName%
	set /p rName=%esetrName%
)


:begin

::4ִ��
%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle����Ŀ¼Ϊ��%cd%
echo Kettle����Ŀ¼Ϊ��%~dp0
echo Kettle�鿴�����ڴ���Դ���е�������ҵ��%rName%
echo ������...      Ctrl+C��������

::ִ��WMIC��ȡ��Ϣ
wmic process where (name like 'java%%.exe' and commandline like '%%-rep:%rName% -user:admin -pass:admin -job:%%') get name,executablepath,commandline,processid,parentprocessid,threadcount,workingsetsize/value

::ִ�����
echo �Ѿ�ִ����ϣ����Խ����˳���

pause


:end

::5�˳�

exit