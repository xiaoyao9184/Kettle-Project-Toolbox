@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0

SET current_script_dir=%~dp0

CALL %current_script_dir%plugins-volume.bat
CALL %current_script_dir%home-volume.bat

docker-compose -p test-jenkins-kpt up