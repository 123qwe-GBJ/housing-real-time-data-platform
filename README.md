# 基于 Kafka + Spark Streaming 的实时房价数据仓库分析平台

> 基于 Spark 的加州房价数据分析及推荐系统 —— 融合大数据实时处理与智能推荐技术，实现多源房产数据的高效整合与深度分析。

## 📖 项目简介
本项目是一个**全链路实时大数据分析平台**。针对传统房产数据分析存在延迟高、维度单一、供需匹配低效等问题，本平台通过 Kafka 实时接入数据，利用 Spark Streaming 进行流式处理与数仓分层建模，最终结合 SpringBoot 提供 API 接口，并通过 ECharts 实现大屏可视化展示。此外，项目集成了 SparkML 线性回归算法，实现了对未来房价趋势的预测。

## 🏗️ 系统架构
<img width="715" height="285" alt="mmexport1791076686147" src="https://github.com/user-attachments/assets/96ba785e-f39c-40e8-ba49-bbf947b5756c" />


**数据流转链路**：
`数据库` -> `上传至虚拟机本地` -> `上传到HDFS` -> `Hive数仓建模及加载数据` -> `通过DataX将Hive数据传输到MySQL` -> `SpringBoot+MyBatis制作可视化大屏`

## 🛠️ 技术栈
*   **数据采集**：Kafka, Python (Data Generator)
*   **数据计算**：Spark Streaming, Spark SQL, Spark MLlib
*   **数据存储**：Hive, MySQL
*   **后端框架**：Java, SpringBoot, MyBatis
*   **前端可视化**：ECharts, HTML/CSS/JS
*   **开发工具**：IntelliJ IDEA, Maven, Git, Navicat, Xshell

## 📂 项目模块结构
*   `data-generator/`：数据模拟生成器，通过 Python 脚本模拟真实房产交易数据并实时推送到 Kafka。
*   `spark-streaming-job/`：Spark Streaming 核心计算模块，负责实时消费 Kafka 数据、数据清洗、数仓分层写入与预测模型调用。
*   `springboot-api/`：SpringBoot 后端服务，提供数据查询接口供前端大屏调用。
*   `sql/`：数仓建表语句及核心分析 SQL。
*   `dataset/`：项目所需的基础数据集。
*   `docs/`：项目架构设计文档与说明。

## 📊 数仓分层设计 (ODS -> DWS -> DWT)
*   **ODS层 (原始数据层)**：作为数据仓库的接入端口，直接存储 Kafka 接入的原始 JSON 格式数据。
*   **DWS层 (轻度汇总层)**：对 ODS 层数据进行清洗、去重、异常值过滤与标准化，并按照天、区域等维度进行轻度聚合。
*   **DWT层 (主题宽表层)**：面向业务主题进行深度聚合。本项目构建了**四大主题宽表**：
    1. **房屋价值主题表**：整合房价走势、学区评分、配套成熟度，用于高价值投资区域评估。
    2. **房屋年龄主题表**：挖掘房龄与价值衰减的内在关联。
    3. **地理维度主题表**：分析海拔、纬度与房价波动的关系。
    4. **人口统计主题表**：分析区域人口规模与住房需求特征。

## 📊 核心数据库表设计
基于 E-R 图设计了 10 个核心数据表，主要包括：
*   `simplified_age_value_analysis`：房龄与价值关系表
*   `housing_affordability_distribution_table`：房价收入比分布表
*   `latitude_price_analysis`：纬度房价分析表
*   `county_avg_income_table`：区域平均收入表
*   `house_value_zone_table`：房屋价值区域表
*   `top10_house_value_analysis`：房屋价值TOP10表

## 🚀 本地运行指南
1.  **环境准备**：启动 Hadoop (HDFS/YARN)、Hive、Kafka、MySQL 服务。
2.  **初始化数据库**：执行 `sql/` 目录下的脚本，创建数仓表及业务表。
3.  **启动数据生成器**：运行 `data-generator` 中的脚本，向 Kafka 发送测试数据。
4.  **提交 Spark 任务**：在 `spark-streaming-job` 模块中，打包并提交 Spark Streaming 任务，开始消费数据并进行清洗计算。
5.  **启动后端服务**：运行 `springboot-api` 项目，启动 RESTful API 服务。
6.  **展示大屏**：用浏览器打开前端页面，即可看到实时更新的房价数据分析大屏。

## 📊 项目成果与展示
<img width="1427" height="750" alt="mmexport1791076683650" src="https://github.com/user-attachments/assets/a9638157-d4d3-467f-ab77-f83c9eda974d" />


**大屏可视化核心看板**：
*   **市场宏观洞察**：房价热力图、区域房屋价值排行榜、房价收入比分布、房屋年龄分布。
*   **投资策略分析**：高价值投资区域推荐排行榜、房龄-价值衰减曲线、海拔与房价关系分析、各纬度带房屋特征对比。
*   **实时监控**：区域人口规模分级、市场综合评分仪表盘、实时数据动态更新。
*   **智能预测**：利用 Spark MLlib 构建线性回归模型，对未来房价趋势进行动态预测。

## 🔧 核心难点与解决方案
1.  **实时数据乱序与重复**：通过设置 Kafka 分区与 Spark Streaming 的水位线（Watermark）机制，处理了流数据中的乱序和重复问题，保障了数据的准确性。
2.  **数仓分层效率优化**：在 Spark SQL 中进行多维聚合时，通过调整并行度与合理使用缓存，避免了数据倾斜，提升了任务执行效率。

## 📝 后续优化方向
*   引入 Flink 替代 Spark Streaming，实现更低延迟的实时计算。
*   增加前端交互功能，支持用户自定义筛选条件查询历史数据。
*   丰富机器学习模型，尝试引入随机森林或 XGBoost 提升预测准确率。
