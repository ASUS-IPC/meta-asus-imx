#!/bin/bash

images=(lfedge/ekuiper edgexfoundry/app-service-configurable-arm64 redis 
edgexfoundry/edgex-ui-arm64 edgexfoundry/device-rest-arm64 edgexfoundry/device-virtual-arm64 
edgexfoundry/core-data-arm64 edgexfoundry/support-notifications-arm64 
edgexfoundry/sys-mgmt-agent-arm64 edgexfoundry/core-metadata-arm64 edgexfoundry/core-command-arm64 
edgexfoundry/support-scheduler-arm64 consul)

for i in "${images[@]}";
do
    image=$(docker images | grep $i)

    if [ "$image" = "" ]; then
        echo "I can not find the image $i."
        docker load -i /etc/EdgeX/ImageforEdgeX.tar
        break
    else
        echo "image = $image"
    fi
done

docker-compose -p edgex -f /etc/EdgeX/docker-compose-no-secty-with-ui-arm64.yml up
