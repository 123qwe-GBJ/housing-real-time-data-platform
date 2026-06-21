# 数据模拟生产者模块 data-generator
## 功能介绍
Java Kafka生产者程序，循环生成加州房屋模拟JSON数据，发送至Kafka `housing-topic` 主题，作为实时流处理数据源。
1. 每2秒生成一条房源数据；
2. 每10条数据休眠5秒；
3. 输出JSON包含收入、房龄、房间、经纬度、房价、衍生指标等字段。

## 环境与版本
- Java 8
- Maven 3.6+
- Kafka集群地址：192.168.17.150:9092
- 目标Topic：housing-topic（需提前手动创建）

## Maven依赖清单
```xml
<!-- Kafka客户端 -->
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>kafka-clients</artifactId>
    <version>3.2.0</version>
</dependency>

<!-- FastJSON JSON序列化工具 -->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.78</version>
</dependency>
