@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-05-06
::FILE KPT_RUN_BY_REP


:init_variable

::script info
SET current_script_dir=%~dp0

::default param
IF "!KPT_CALLER_SCRIPT_PATH!"=="" SET KPT_CALLER_SCRIPT_PATH=%~0
IF "!KPT_MODE!"=="" SET KPT_MODE=rep


:begin

CALL %current_script_dir%KPT_RUN_COMMAND.bat


:end

ECHO:
ECHO pause by %~nx0
PAUSE
