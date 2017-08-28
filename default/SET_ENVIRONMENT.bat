@echo off
::CODER BY xiaoyao9184 1.0
::TIME 2017-08-24
::FILE SET_ENVIRONMENT
::DESC set kettle environment with KETTLE_HOME


:v

::1变量赋值
set KETTLE_HOME=
set KETTLE_REPOSITORY=
for %%a in (.) do set current_folder=%%~na
if exist SET_JAVA_ENVIRONMENT.bat (
    call SET_JAVA_ENVIRONMENT.bat
)

set echo_use_project_kettle_home=使用项目KETTLE_HOME目录！
set echo_use_user_kettle_home=使用用户KETTLE_HOME目录！
set echo_use_dir_name_as_repositorie_name=使用项目目录名作为默认连接资源库！


:begin

if exist .kettle (
    echo %echo_use_project_kettle_home%
    set KETTLE_HOME=%cd%
) else ( 
    echo %echo_use_user_kettle_home%
)

set "_temp_file_repository=0"

if exist repository.log (
    set _temp_file_repository=1
)
if exist .meta (
    set _temp_file_repository=1
)
if exist *.kdb (
    set _temp_file_repository=1
)
if exist config.xml (
    set _temp_file_repository=1
)
if %_temp_file_repository% equ 1 (
    echo %echo_use_dir_name_as_repositorie_name%
    set KETTLE_REPOSITORY=%current_folder%
)


:end

::5退出
exit /b 0
