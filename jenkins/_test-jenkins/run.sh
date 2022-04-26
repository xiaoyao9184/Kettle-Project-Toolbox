# copy to external volume
docker volume create --driver local test-jenkins-kpt_plugins_vol

docker run -d --rm --name dummy \
  --mount "type=volume,source=test-jenkins-kpt_plugins_vol,target=/root" \
  alpine tail -f /dev/null

docker exec dummy chmod 777 /root/

docker cp ./plugins/. dummy:/root/

docker stop dummy

docker-compose -p test-jenkins-kpt up