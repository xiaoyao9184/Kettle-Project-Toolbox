@echo off
::CODER BY xiaoyao9184 1.0
::TIME 2017-08-24
::FILE SET_ENVIRONMENT
::DESC set kettle environment with KETTLE_HOME and KETTLE_REPOSITORY
::PARAM none
::--------------------
::CHANGE 2018-12-28
::current_folder_name and current_path fix
::--------------------


:v

::current info
set current_path=%~dp0
for %%i in ("%~dp0.") do set "current_folder_name=%%~ni"
::set java environment
if exist "%current_path%SET_JAVA_ENVIRONMENT.bat" (
    call %current_path%SET_JAVA_ENVIRONMENT.bat
)
::tip info
set echo_use_project_kettle_home=Use project path as KETTLE_HOME:
set echo_use_user_kettle_home=Use user home path as KETTLE_HOME!
set echo_use_dir_name_as_repository_name=Use project path name as KETTLE_REPOSITORY:
::defult param
set KETTLE_HOME=
set KETTLE_REPOSITORY=


:begin

if exist %current_path%.kettle (
    echo %echo_use_project_kettle_home% %current_path%
    set KETTLE_HOME=%current_path:\=/%
) else ( 
    echo %echo_use_user_kettle_home%
)

set "_temp_file_repository=0"

if exist %current_path%repository.log (
    set _temp_file_repository=1
)
if exist %current_path%.meta (
    set _temp_file_repository=1
)
if exist %current_path%.profile (
    set _temp_file_repository=1
)
if exist %current_path%*.kdb (
    set _temp_file_repository=1
)
if exist %current_path%config.xml (
    set _temp_file_repository=1
)
if %_temp_file_repository% equ 1 (
    echo %echo_use_dir_name_as_repository_name% %current_folder_name%
    set KETTLE_REPOSITORY=%current_folder_name%
)


:end

exit /b 0
