#!/bin/bash
# CODER BY xiaoyao9184 1.0
# copy path to external volume 


volume_name="test-jenkins-kpt_home_vol"
dummy_name="dummy--$volume_name"
copy_path="./home/."


docker volume create --driver local $volume_name

docker run -d --rm --name $dummy_name \
  --mount "type=volume,source=$volume_name,target=/root" \
  alpine tail -f /dev/null

docker exec $dummy_name chmod 777 /root/

docker cp $copy_path $dummy_name:/root/

docker stop $dummy_name
