---
title: Kafka 基本概念與安裝
date: 2020-05-05 13:13:28
tags:
- kafka
categories:
- Kafka 筆記
---

# 前言

slides : [Kafka Series - Basic use & knowledge](https://slides.com/harveyjhuang/kafka-series-1)
本篇將以淺顯易懂的方式，分別講述 Kafka 幾個主題：
1. 透過將整個Kafka Cluster 比喻成媒體體系，藉此來幫助大家快速了解 Kafka Cluster 各成員的職責。
2. Step by Step 教你手搭一組 Kafka Cluster。
3. Kafka 參數百百種，不藏私直接告訴您關鍵參數。

## 大綱

今天主要分享的主題如下：
- Kafka 基本概念
- 如何安裝 Kafka
- Kafka 最重要的幾個參數

<!--more-->

## Kafka Basic Concept

### Overview

整個 Kafka Cluster 的基本觀念大概可以用下面兩張圖表示:
1. 一張詳細畫出 Kafka Cluster 內部各個重要元件的關係，以及整個資料的流向。
![](kafka_cluster.png)

2. 另一張我們以媒體生態關係來生動的描述各個元件的互動以及關聯，以便讓看的人很快就可以透過對照的方式知道 Kafka Cluster 內外部的運作。
![](kafka_media.png)

### Broker

#### 解說

#### 特性
1. No master cluster
2. Accept and handle clients' requests
3. Preserver message until expired
4. Controller coordinates and manages broker cluster

### Producer

#### 解說

#### 特性
1. Push message to Kafka
2. Partition strategy
    - Round-robin
    - Randomness
    - Key-ordering
3. Compression algorithm
    - GZIP
    - Snappy
    - LZ4
    - Zstandard
4. How not to lost message (ACK)

### Consumer

#### 解說

#### 特性
1. Pull message from Kafka
2. Why consumer group
3. What is consumer offsets
4. How to commit offset

### Topic

#### 解說

#### 特性
1. Why partition
2. How replica works
3. What is ISR
4. How log is preserved
![](kafka_topic.png)
![](kafka_topic2.png)

### Zookeeper

#### 解說

#### 特性
1. Manage Kafka cluster metadata
2. Help Controller to coordinate cluster

![](kafka_zk.png)

## How to install

### Install Zookeeper Cluster

- Install JAVA
- Install Zookeeper
- Set myid for each node
- Start Zookeeper Cluster

```
########################
### Install Zookeeper ##
########################

# install tools
yum -y install which wget nc net-tools

# install jdk
yum -y install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64

# java home
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

# get zk from web
wget "${ZOOKEEPER_URL}" -O "/tmp/${ZOOKEEPER_FILENAME}"

# install zookeeper
tar xfz /tmp/${ZOOKEEPER_FILENAME} -C /opt

# add zookeeper config (add all zk node ip)
cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

# add myid file for zookeeper
touch /zookeeper/log/myid
echo $NODE_ID >> /zookeeper/log/myid

# start zk
/opt/zookeeper/bin/zkServer.sh start /opt/zookeeper/conf/zoo.cfg

################################
### Check Zookeeper is alive! ##
################################

# [4 letter words]

echo [word] | nc localhost 2181

conf : Print details about serving configuration.
cons : List full connection/session details for all clients connected to this server.
crst : Reset connection/session statistics for all connections.
dump : Lists the outstanding sessions and ephemeral nodes. 
       This only works on the leader.
envi : Print details about serving environment
ruok : Tests if server is running in a non-error state. 
       The server will respond with imok 
       if it is running. Otherwise it will not respond at all.
srst : Reset server statistics.
srvr : Lists full details for the server.
stat : Lists brief details for the server and connected clients.
wchs : Lists brief information on watches for the server.
mntr : Outputs a list of variables that could be used for monitoring the health 
       of the cluster.

# example
echo srvr | nc localhost 2181
```

### Install Kafka Cluster

- Install JAVA
- Install Kafka
- Set server.properties
- Start Kafka Cluster

```
####################
## Install Kafka  ##
####################

# install tools
yum -y install which wget nc net-tools

# install jdk
yum -y install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64

# java home
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

# Get Kafka From web
wget "${KAFKA_URL}" -O "/tmp/${KAFKA_FILENAME}"

# install kafka
tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

# edit config/server.properties (listener, zookeeper.connect)
cp /opt/kafka/config/server.properties /opt/kafka/config/server-default.properties

# start setting your broker cfg (plz follow previous slides)
vi /opt/kafka/config/server.properties

# start kafka
/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties

###########################
## Check Kafka is alive! ##
###########################

# check kafka cluster size
echo dump | nc 10.200.252.232 2181 | grep brokers

# test create topic
/opt/kafka/bin/kafka-topics.sh --zookeeper {{zks_ip:2181}} --create --topic {{name}} 
 --partitions 3 --replication-factor 3

# list topic
/opt/kafka/bin/kafka-topics.sh --zookeeper {{zks_ip:2181}} --list

# show topic detail
/opt/kafka/bin/kafka-topics.sh --zookeeper {{zks_ip:2181}} --describe --topic {{name}}

# produce msg to topic
/opt/kafka/bin/kafka-console-producer.sh --broker-list {{kas_ip:9092}} --topic {{name}} 

# consuming msg from topic
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server {{kas_ip:9092}} 
 --topic {{name}} --group {{name}} --from-beginning 
 --consumer-property enable.auto.commit=false
```

## Most Important Properties

