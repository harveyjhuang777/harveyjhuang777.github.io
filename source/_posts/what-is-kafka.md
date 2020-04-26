---
title: What is Kafka?
date: 2020-04-24 07:17:45
tags: 
- kafka
categories:
- Kafka 筆記
---

# What is Kafka?

slides : [Kafka series - What's Kafka](https://slides.com/harveyjhuang/kafka-series-0)

## Overview

- Brief Introduction
- Streaming Platform
- Why Kafka
- What Kafka can do

<!--more-->

## Brief Introduction

> Apache Kafka® is a distributed streaming platform.

就官方網站的解釋說明，Kafka 是一個分布式的流式平台，那麼首先我們要初步了解一下何謂流式平台。

## Streaming Platform

### What is Streaming Platform?

根據 Kafka 官方的說明，一個 streaming platform 必須具備三個核心能力：

- 發布和訂閱訊息流（streams of records），類似於 message queue 或企業級消息系統的功能。
- 儲存訊息流並且具備容錯和保存機制。
- 實時處理訊息流

### Why Use Streaming Platform?

定義完 streaming platform，我們緊接著要說明為何軟體架構上有時要使用流式平台。

#### Asynchronous Process（異步處理）

透過 ，我們可以在同時間處理多個任務，將原本一條龍式的流程透過判斷每一步驟是否仰賴前一步驟來拆分，進一步縮短整體流程處理時間。比如電商的訂單場景中，生成訂單、短信通知以及統計數據可以分開進行，因此可透過將任務指派到 streaming platform  後，下游服務再向 streaming platform  拿取任務來加速整個訂單流程。

![https://i.imgur.com/bjJzhaJ.png](https://i.imgur.com/bjJzhaJ.png)

#### Decoupling（解耦）

透過 streaming platform ，我們可以很輕易做到服務間的解耦，使得服務不會受到其他服務影響而不穩定。
以過去工作的經驗為例，過去我們透過 Kafka 幫助以下系統做到解耦並增加穩定性：
1. 爬蟲系統：解決上游服務發放任務的速度，遠大於下游服務爬蟲的速度，進而導致整個系統不穩定的問題。
2. 訂單系統：解決上游服務同步第三方遊戲訂單的速度，遠大於下游服務寫入資料庫的速度，進而導致整個系統不穩定的問題。

以生活化的網購為例，streaming platform  的解耦特性就如同 Amazon.com 的角色一樣，提供一個平台使得消費者跟商家可以更專注做自己的事。比如消費者可以使用同一個購物流程購買產品，不用特別 survey 商家。商家可以使用同一流程出貨和收款，不用自己接洽貨運公司。
![https://i.imgur.com/2KRaGMz.png](https://i.imgur.com/2KRaGMz.png)

#### Flow Control（削峰填谷）

透過 streaming platform ，我們可以幫助系統應付瞬間高流量，防止系統因高流量而當機。舉一個生活化的例子，以前在跨年的時候，大家都會抓00:00傳送簡訊說聲新年快樂，但是並不是每個人都醒著等待新的一年，因此對於想睡覺的人來說，手機就好比一個 streaming platform 幫他先暫時儲存這些祝福，避免在睡覺時被一堆人的祝福聲吵起。 

![](flow.png)

## Why Kafka?

介紹完 streaming platform 後，緊接著我們就要來簡單說明 Kafka 在 streaming platform 中具有哪些顯著的優勢。

### Horizontally scalable（水平擴展能力）

Kafka 的水平擴展能力體現在兩大特性，分別是：

- Online：在線擴容，可以在不停止 Kafka Cluster 的情況下增加 broker。
- Simple：簡單部署，基本上 Kafka 的水平擴展只是單純在部署一台機器，雖然部署後還是需要對整個集群的 Topic 分佈做些調配，但是就水平擴展一台節點來說是十分便利的。此外在 Topic 的調配部分，Kafka 也提供相關的腳本可以使用，整體來說也是相當便利的。

然而 Kafka 的水平擴展也絕非沒有缺點，當你需要縮編你的集群時，操作起來就沒有那麼便利，主要是在縮編的時候必須考量最低副本的要求，以及在關閉節點前必須先針對 Topic 做挑整（過程中可能造成應用服務的連線問題），因此做集群縮編時有機率影響到應用服務。


### Fault-tolerant

Kafka 擁有極佳的容錯性設計並且支持 broker side 和 client side 的容錯：

- Broker Side

在 Kafka 本身 broker 的部分，主要在於針對每一個 Topic 都有 replicate & partition 的設計，如此便可以在某一台 broker 發生意外時，其他 broker 也可以正常提供服務。

![https://i.imgur.com/hL2y21W.png](https://i.imgur.com/hL2y21W.png)

- Client Side

在 client side 部分則是可以透過多個 instance 消費的機制來處理。假設 client side 有三個 instance 負責消費訊息，當其中一台出狀況的時候，其實對於只是另外兩台負責的處理量變多而已，並不會造成出狀況那台的負責任務無法被消費的情況，並且這個機制是仰賴 Kafka 的 consumer group 而成，client side 並不需要額外多做其他事情。

![https://i.imgur.com/IzWa4ES.png](https://i.imgur.com/IzWa4ES.png)

### Wicked fast

Kafka 在訊息處理效能上，無論在小訊息或是大訊息都表現得十分優異。這部分主要與 Kafka 內部設計的機制包含 zero copy 以及 disk sequence I/O 有關，後續我們會再針對這部分分享一篇文章。

![https://i.imgur.com/DVfStQx.png](https://i.imgur.com/DVfStQx.png)

![https://i.imgur.com/KD6CFqu.png](https://i.imgur.com/KD6CFqu.png)

## What Kafka can do

講完 Kafka 的優勢後，我們更近一步要跟大家分享幾個 Kafka 的常見場景：

- Messaging

![https://i.imgur.com/8AID00B.png](https://i.imgur.com/8AID00B.png)

- Website Activity Tracking

![https://i.imgur.com/1dKRpzD.png](https://i.imgur.com/1dKRpzD.png)

- Log Aggregation

![https://i.imgur.com/amizM6u.png](https://i.imgur.com/amizM6u.png)

- Stream Processing

![https://i.imgur.com/EtgWtYQ.png](https://i.imgur.com/EtgWtYQ.png)

## 總結

本篇我們簡單介紹 Kafka 是什麼東西，作為我們 Kafka Series 的第一篇文章，希望能讓大家對 Kafka 有些基本的認識。

## Ref

- [Kafka Documentation](https://kafka.apache.org/)

