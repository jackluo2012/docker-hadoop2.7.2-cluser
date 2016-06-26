#!/bin/bash
#1.先启动journalnode 节点 zk 的节点上 slave1,slave2,slave3
#$HADOOP_HOME/sbin/hadoop-daemon.sh start journalnode
$HADOOP_HOME/sbin/hadoop-daemons.sh start journalnode
#2.这个要在nameservice 上面格式化 hadoop-namenode 01 ,再将临时目录tmp同步到02上面
echo "Y" | hdfs namenode -format
#3.格式化zookeeper,只需要在 hadoop-namenode 01 上面执行
hdfs zkfc -formatZK
#4.启动HDFS 在 hadoop-namenode01 上面启动
$HADOOP_HOME/sbin/start-dfs.sh
#5.在hadoop-master上面启动 yarn
$HADOOP_HOME/sbin/start-yarn.sh
