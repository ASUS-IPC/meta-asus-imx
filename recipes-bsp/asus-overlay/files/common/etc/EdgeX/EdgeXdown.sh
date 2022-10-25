#!/bin/bash

docker-compose -p edgex -f /etc/EdgeX/docker-compose-no-secty-with-ui-arm64.yml down -v

echo "Shut down EdgeX..."