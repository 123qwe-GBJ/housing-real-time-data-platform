# 加州房产数据分析与可视化系统
基于 Hadoop‑Spark 生态实现**离线+实时双链路**房产数据分析，完成数据预处理、数仓分层建模、指标计算、数据同步与可视化展示。

## 项目概述
本项目以加州房产公开数据集为数据源，搭建一套贴近生产思路的数据分析平台：
- 离线链路：使用 Python 完成前置清洗，再经 Hive 三层数仓建模、SparkSQL 全量计算，DataX 同步指标库，形成历史基线；
- 实时链路：通过 Python 脚本仿真增量数据，推送到 Kafka，Spark Streaming 消费并增量更新指标；
- 最终通过 SpringBoot + MyBatis + ECharts 实现多维度可视化大屏，支持房价分布、区域价值、投资潜力等分析。

>设计思路：**离线打底保证历史完整、口径统一；实时跟进增量数据刷新**。

## 技术栈
- 预处理：Python（pandas）
- 存储&计算：Hadoop(HDFS)、Hive、Spark、Spark Streaming
- 消息队列：Kafka
- 数据同步：DataX
- 后端：SpringBoot、MyBatis
- 前端可视化：ECharts

## 整体流程说明
原始数据集 → Python清洗（去重、缺失/异常值处理、衍生字段） → 上传虚拟机本地 → 上传HDFS → Hive ODS‑DWS‑DWT分层建模 + SparkSQL指标计算 → DataX同步指标至MySQL；
增量数据由Java仿真生成 → Kafka → Spark Streaming流式ETL → 更新MySQL指标；
MySQL指标库 → SpringBoot后端接口 → ECharts可视化大屏。

>详细离线流程：
<img width="715" height="285" alt="mmexport1791076686147" src="https://github.com/user-attachments/assets/22a28f77-90d3-466a-8da9-da727f4310b1" />


>DataX Hive→MySQL同步运行验证：
<img width="1212" height="487" alt="mmexport1791079726258" src="https://github.com/user-attachments/assets/a11fd1d4-4cb0-47f3-b854-f43265f2b467" />

*注：该截图为链路功能验证；完整全量任务逻辑与脚本见仓库代码。*

>Kafka实时JSON数据流（仿真增量输入）：
<img width="1900" height="759" alt="mmexport1791079728667" src="https://github.com/user-attachments/assets/761599fe-de97-4616-be99-933b232a6e6e" />


>最终可视化大屏效果：
<img width="1427" height="750" alt="mmexport1791076683650" src="https://github.com/user-attachments/assets/22273e0d-1e61-4410-b265-0fb1d1260a76" />


## 模块说明
1. **Python数据预处理**
使用 pandas 对原始数据集清洗：去重、填充/过滤缺失值、剔除不合理异常房价、计算 `price_per_room`、`income_to_price_ratio` 等衍生字段，保证进入数仓的数据质量。
>清洗脚本：`scripts/data_clean.py`

2. **离线数仓模块**
清洗后文件上传 HDFS；基于 Hive 搭建 ODS‑DWS‑DWT 三层分层；使用 SparkSQL 完成区域统计、房价分档、价值衰减等指标预计算；通过 DataX 将汇总指标同步到 MySQL，供前端查询。

3. **实时增量模块**
编写 Java 仿真生成器模拟新增房产数据，以 JSON 格式发送至 Kafka；Spark Streaming 消费消息、完成流式清洗与转换，增量写入 Hive 并刷新 MySQL 指标，实现动态更新。
>仿真源码：`src/main/java/com/generator/DataProducer.java`

4. **可视化模块**
SpringBoot + MyBatis 读取 MySQL 指标库，提供 REST 接口；ECharts 绘制热力图、TOP排行、饼图、趋势曲线、仪表盘等图表，完成房产市场动态分析与投资区域推荐。

## 运行步骤
1. 将原始数据集放入 `data/`，执行 `scripts/data_clean.py` 完成清洗；
2. 将清洗后文件上传虚拟机本地，再上传至 HDFS；
3. 执行 Hive 建表 SQL（`sql/hive_ddl.sql`），加载数据并运行 SparkSQL 指标计算；
4. 配置并启动 DataX 同步任务，将汇总指标同步至 MySQL；
5. 启动 Kafka，运行 `scripts/data_generator.py` 发送仿真数据；
6. 提交 Spark Streaming 任务；
7. 启动 SpringBoot 后端，访问前端页面查看大屏。

## 项目亮点
- 完整包含**Python前置清洗**环节，从源头控制数据质量；
- 采用 Hive 分层数仓设计，层次清晰、指标口径统一；
- 离线+实时双链路架构，离线生成基线、实时增量刷新，贴近工业常见思路；
- 所有链路均有可验证运行记录，代码可复现；
- 多维度可视化，支持区域房价、收入比、房龄价值衰减、投资评分等分析。
