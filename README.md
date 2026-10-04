# housing-real-time-data-platform
基于Hadoop‑Spark生态搭建的**房产实时数据分析平台**，实现从原始数据预处理、离线数仓分层、实时流处理、指标同步到可视化大屏的完整数据链路。

## 项目概述
本项目以加州房产公开数据集为数据源，采用**离线+实时双链路架构**：
- 离线链路：Python完成前置数据清洗 → Hive分层建模 → SparkSQL全量指标计算 → DataX同步MySQL，生成历史基线；
- 实时链路：Java程序仿真增量房产数据 → Kafka消息队列 → Spark Streaming流式消费与ETL → 增量刷新MySQL指标；
- 最终通过SpringBoot后端 + ECharts可视化大屏，完成房价分布、区域统计、投资潜力等多维度数据分析。

>设计思路：离线保证历史数据完整、口径统一；实时跟进增量数据动态更新，贴近企业数仓平台开发思路。

## 技术栈
- 数据预处理：Python（Pandas）
- 存储&计算：Hadoop(HDFS)、Hive、Spark、Spark Streaming(Scala)
- 消息队列：Kafka
- 数据同步：DataX
- 增量生产者：Java
- 后端服务：SpringBoot、MyBatis
- 前端可视化：ECharts

## 整体流程说明
原始数据集 → Python清洗（去重、缺失/异常值处理、衍生字段计算） → 上传虚拟机本地 → 上传HDFS → Hive ODS‑DWS‑DWT分层建模 + SparkSQL指标计算 → DataX同步指标至MySQL；
Java生产者仿真增量数据 → Kafka → Spark Streaming流式ETL → 增量更新MySQL指标；
MySQL指标库 → SpringBoot后端接口 → ECharts可视化大屏。

>详细离线流程：
<img width="715" height="285" alt="mmexport1791076686147" src="https://github.com/user-attachments/assets/4c5f14e9-5d7d-4458-b2aa-d7b4a7fec275" />


>DataX Hive→MySQL同步运行验证：
<img width="1212" height="487" alt="mmexport1791079726258" src="https://github.com/user-attachments/assets/58af45d3-60fd-4e12-894a-8a48df6d4dc1" />
*注：该截图为链路功能验证；完整全量任务逻辑与脚本见仓库代码。*

>Kafka实时JSON数据流（Java仿真增量输入）：
<img width="1900" height="759" alt="mmexport1791079728667" src="https://github.com/user-attachments/assets/43149fad-9dd9-4ba4-9ac0-747bb1a7ace6" />


>最终可视化大屏效果：
<img width="1427" height="750" alt="mmexport1791076683650" src="https://github.com/user-attachments/assets/d150e3e4-7774-4368-a9c7-7bbd599f8c98" />


## 项目目录结构
## 项目目录结构

```text
housing-real-time-data-platform
├── data-generator/                  # Java增量数据生产者
│   └── HousingDataProducer.java
├── dataset/                         # 原始数据集 & Python清洗后数据集
│   └── california_housing_prices_cleaned.csv
├── docs/                            # 流程图、运行截图等文档资源
├── spark-streaming-job/             # Spark Streaming流式处理任务（Scala）
│   ├── HousingStreamToMySQL.scala
│   └── MySQLUtil.scala
├── springboot-api/                  # SpringBoot后端接口服务
│   └── src/main/java/com/zyg
│       ├── controller/
│       ├── mapper/
│       ├── pojo/
│       ├── service/
│       ├── jdbc/
│       ├── util/
│       └── AppStart.java
├── sql/                             # Hive&MySQL建表、分层初始化SQL
│   ├── 01_ods_hive.sql
│   ├── 02_dws_mysql.sql
│   └── 03_base_mysql.sql
└── README.md
```

## 模块说明
1. **Python数据预处理**
使用Pandas对原始数据集清洗：去重、过滤异常房价、处理缺失值、计算房价收入比、单位房价等衍生字段；清洗完成输出`california_housing_prices_cleaned.csv`存入`dataset`目录，保证进入数仓的数据质量。
>清洗脚本可自行放置于`scripts/`（或直接说明：清洗逻辑见项目文档，输出文件已提交至dataset）

2. **离线数仓模块**
清洗后数据上传HDFS；通过`sql/`下脚本完成ODS、DWS、BASE三层建表；SparkSQL完成区域房价统计、分档、均值等指标预计算；通过DataX将汇总指标同步至MySQL，作为历史基线。

3. **实时增量模块**
`data-generator/HousingDataProducer.java`为Java生产者，循环仿真生成新增房产JSON数据发送至Kafka；
`spark-streaming-job/`下Scala任务消费Kafka消息，完成流式转换、数据校验，增量写入并刷新MySQL指标，实现数据动态更新。

4. **后端与可视化模块**
`springboot-api`采用标准分层架构（controller‑service‑mapper‑pojo‑util）读取MySQL指标库，提供REST接口；前端ECharts实现热力图、TOP排行、趋势图等多维度可视化展示。

## 运行步骤
1. 运行Python清洗脚本，生成清洗后csv文件存入`dataset`；
2. 将清洗后文件上传虚拟机本地，再上传至HDFS；
3. 依次执行`sql/`目录下SQL脚本，完成Hive、MySQL分层建表；
4. 运行SparkSQL指标计算任务，配置并启动DataX同步任务；
5. 启动Kafka，运行`data-generator`中`HousingDataProducer.java`发送仿真增量数据；
6. 提交`spark-streaming-job`流式任务；
7. 启动`springboot-api`的`AppStart.java`，访问前端页面查看可视化大屏。

## 项目亮点
- 预处理与生产分离：**Python负责灵活脏数据清洗**，**Java负责稳定增量数据生产**，分工贴近工业场景；
- 标准数仓分层：ODS‑DWS‑DWT分层设计，指标口径清晰、可维护性强；
- 离线+实时双链路：离线打底历史基线，实时刷新增量，完整覆盖数仓常见更新模式；
- 代码结构规范：SpringBoot标准分层、Spark Streaming独立任务、SQL脚本版本化管理；
- 全链路可验证：从数据集、建表脚本、生产代码、流式任务、后端服务到运行截图完整可追溯。
