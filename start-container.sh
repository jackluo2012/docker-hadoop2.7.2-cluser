#!/bin/bash
# the default node number is 3
#sudo docker rm $(docker ps -a) &> /dev/null
N=${1:-4}
M=${1:-3}
sudo docker stop hadoop-master > /dev/null 2>&1
sudo docker rm hadoop-master > /dev/null 2>&1
echo "start hadoop-master container..."
sudo docker run -td \
                --net=hadoop \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                jackluo/hadoop:2.7.2 > /dev/null
#start hadoop nameservice 

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker stop hadoop-slave$i > /dev/null 2>&1
	sudo docker rm  hadoop-slave$i > /dev/null 2>&1
	echo "start hadoop-slave$i container..."
	sudo docker run -td \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                jackluo/hadoop:2.7.2 > /dev/null 2>&1
	echo "先启动journalnode..."
	sudo docker exec -it hadoop-slave$i hadoop-daemon.sh start journalnode
	echo "...格式完成..."
	i=$(( $i + 1 ))
done 
sleep 5  #等3秒后执行下一条
i=1
while [ $i -lt $M ]
do
        sudo docker stop hadoop-namenode-$i > /dev/null 2>&1
        sudo docker rm  hadoop-namenode-$i > /dev/null 2>&1
        echo "start hadoop-namenode-$i container..."
        sudo docker run -td \
                        --net=hadoop \
                        -p 5007$i:50070 \
                        --name hadoop-namenode-$i \
                        --hostname hadoop-namenode-$i \
                        jackluo/hadoop:2.7.2 > /dev/null 2>&1
        i=$(( $i + 1 ))
done
# get into hadoop master container
echo "格式化 hdfs 只需要格式化1台,1主一从..."
sudo docker exec -it hadoop-namenode-1 format-hdfs.sh
echo "...完成..."

echo "再将临时目录tmp同步到02上面.."
sudo docker exec -it hadoop-namenode-1 scp-namenode.sh
echo "...完成..."

echo "格式化zookeeper,只需要在 hadoop-namenode 01 上面执行..."
sudo docker exec -it hadoop-namenode-1 hdfs zkfc -formatZK
echo "...完成..."

echo "启动namenode..."
sudo docker exec -it hadoop-namenode-1 start-dfs.sh
echo "...完成..."

echo "在hadoop-master上面启动 yarn..."
sudo docker exec -it hadoop-master start-yarn.sh
echo "...完成..."

sudo docker exec -it hadoop-master /bin/bash





