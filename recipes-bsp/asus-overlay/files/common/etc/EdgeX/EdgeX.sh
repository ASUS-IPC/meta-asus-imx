#!/bin/bash

images=(lfedge/ekuiper edgexfoundry/app-service-configurable-arm64 redis 
edgexfoundry/edgex-ui-arm64 edgexfoundry/device-rest-arm64 edgexfoundry/device-virtual-arm64 
edgexfoundry/core-data-arm64 edgexfoundry/support-notifications-arm64 
edgexfoundry/sys-mgmt-agent-arm64 edgexfoundry/core-metadata-arm64 edgexfoundry/core-command-arm64 
edgexfoundry/support-scheduler-arm64 consul)

image_tar_gz=(edgexfoundry_ekuiper edgexfoundry_app-service-configurable-arm64 edgexfoundry_redis 
edgexfoundry_edgex-ui-arm64 edgexfoundry_device-rest-arm64 edgexfoundry_device-virtual-arm64 
edgexfoundry_core-data-arm64 edgexfoundry_support-notifications-arm64 
edgexfoundry_sys-mgmt-agent-arm64 edgexfoundry_core-metadata-arm64 edgexfoundry_core-command-arm64 
edgexfoundry_support-scheduler-arm64 edgexfoundry_consul)

loop=0

for i in "${images[@]}";
do
    image=$(docker images | grep $i)

    if [ "$image" = "" ]; then
        echo "I can not find the image $i."
        docker load < /etc/EdgeX/EdgeXImages/${image_tar_gz[$loop]}.tar.gz
        loop=$(($loop +1))
    else
        echo "image = $image"
        loop=$(($loop +1))
    fi
done

docker-compose -p edgex -f /etc/EdgeX/docker-compose-no-secty-with-ui-arm64.yml up
