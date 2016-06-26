#!/bin/bash
dockername=$1
docker exec -it $dockername hadoop-daemon.sh start namenode
docker exec -it $dockername hadoop-daemon.sh start zkfc
docker exec -it $dockername jps
