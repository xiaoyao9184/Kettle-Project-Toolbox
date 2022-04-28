@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::copy path to external volume 


SET volume_name=test-jenkins-kpt_home_vol
SET dummy_name=dummy--%volume_name%
SET copy_path=./home/.


docker volume create --driver local %volume_name%

docker run -d --rm --name %dummy_name% ^
  --mount "type=volume,source=%volume_name%,target=/root" ^
  alpine tail -f /dev/null

docker exec %dummy_name% chmod 777 /root/

docker cp %copy_path% %dummy_name%:/root/

docker stop %dummy_name%
