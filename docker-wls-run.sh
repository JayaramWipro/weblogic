#!/bin/sh
#

docker run -d --name wlsadmin -p 7001:7001 -p 9002:9002 -e DEBUG_FLAG=true -e PRODUCTION_MODE=dev wls-standalone-app
