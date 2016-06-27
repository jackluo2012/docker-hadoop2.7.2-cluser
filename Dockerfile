FROM jackluo/hadoop-base:1.1
# install openssh-server, openjdk and wget

RUN mkdir -p /opt/modules
RUN mkdir -p /opt/data/tmp
RUN mkdir -p /home/hadoop/

ADD hadoop-2.7.2.tar.gz /opt/modules/
ENV HADOOP_HOME /opt/modules/hadoop-2.7.2
WORKDIR /opt/modules/hadoop-2.7.2

ENV PATH $PATH:/opt/modules/hadoop-2.7.2/bin:$HADOOP_HOME/sbin

COPY etc/hadoop/* ./etc/hadoop/

RUN mv ./etc/hadoop/start-hadoop.sh ./bin/
RUN chmod a+x ./bin/start-hadoop.sh
RUN mv ./etc/hadoop/format-hdfs.sh ./bin/
RUN chmod a+x ./bin/format-hdfs.sh
RUN mv ./etc/hadoop/scp-namenode.sh ./bin/
RUN chmod a+x ./bin/scp-namenode.sh
# Volumes
#VOLUME /var/multrix

# Expose ports
EXPOSE 50070
EXPOSE 8088


# format namenode
#RUN hadoop namenode -format
