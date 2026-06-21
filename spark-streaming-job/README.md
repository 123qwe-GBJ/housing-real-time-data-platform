# spark-streaming-job 实时流处理模块
## 功能概述
基于Spark Streaming对接Kafka housing-topic，实时消费模拟房源JSON数据，完成数据清洗、异常过滤，批量写入MySQL ods_housing_info原始明细表；同时提供数据查询校验逻辑。

## 核心流程
1. Direct直连Kafka消费，手动管理offset
2. 解析JSON，捕获脏数据丢弃
3. 自建简易MySQL连接池，批量insert提升写入性能
4. 优雅关闭流，释放数据库连接资源
5. 写入后查询库中最新数据做打印校验

## 核心配置
- Kafka地址：192.168.17.150:9092
- 消费主题：housing-topic
- 批次间隔：10s
- MySQL库：housing_db，表：ods_housing_info

## 依赖包
spark-streaming-kafka-0-10、fastjson、mysql-connector-java
