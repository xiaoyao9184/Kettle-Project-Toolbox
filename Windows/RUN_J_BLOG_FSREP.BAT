@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.1
::TIME 2015-05-28
::FILE RUN_J_BLOG_FSREP
::DESC run a job with base log in filesystem repositorie 


:v

::1������ֵ
set tip=Kettle���ȳ���������Դ����ҵ
set ver=1.0
set rName=
set jName=

set echorName=��Ҫ����Kettle�ļ���Դ������
set esetrName=������Kettle�ļ���Դ�����ƣ�Ȼ��س���
set echojName=��Ҫ����Kettle��ҵ����
set esetjName=������Kettle��ҵ���ƣ�Ȼ��س���

:title

::2��ʾ�ı�
title %tip% %ver%

echo Kettle���ȳ���������Դ����ҵ
echo ����رգ�����
echo ...


:check

::3�������� ��������
if "%rName%"=="" (
	echo %echorName%
	set /p rName=%esetrName%
)

if "%jName%"=="" (
	echo %echojName%
	set /p jName=%esetjName%
)


:begin

::4ִ��
set d=%date:~0,10%
set t=%time:~0,8%

%~d0

cd %~dp0

cd..

cd data-integration

echo Kettle����Ŀ¼Ϊ��%cd%
echo Kettle����Ŀ¼Ϊ��%~dp0
echo Kettle���д���Դ���е���ҵ��%rName%:%jName%
echo Kettle��־�ļ�Ϊ��"%~dp0log\%jName%%d:/=-%_%t::=-%.log"
echo ������...      Ctrl+C��������

::ִ��Kitchen
call kitchen -rep:%rName% -user:admin -pass:admin -job:%jName% -level:Basic>>"%~dp0log\%jName%%d:/=-%_%t::=-%.log"

::ִ�����
echo �Ѿ�ִ����ϣ����Խ����˳���

pause


:end

::5�˳�

exit