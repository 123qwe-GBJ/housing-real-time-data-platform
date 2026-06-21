/*
文件：03_base_mysql.sql
分层：ODS原始层MySQL基础表
功能：业务原始housing房屋表、用户账号表、基础查询指标SQL、CSV导入配置
*/

-- 1、创建业务数据库
CREATE DATABASE IF NOT EXISTS housing_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE housing_db;

-- 2、原始房屋明细表 ODS底层原始数据
CREATE TABLE IF NOT EXISTS housing_info (
    id INT COMMENT '数据行唯一索引（对应CSV第一列）',
    med_inc DOUBLE NOT NULL COMMENT '区域居民收入中位数',
    house_age DOUBLE NOT NULL COMMENT '房屋平均年龄（年）',
    ave_rooms DOUBLE NOT NULL COMMENT '每户平均房间数',
    ave_bedrms DOUBLE NOT NULL COMMENT '每户平均卧室数',
    population DOUBLE NOT NULL COMMENT '区域人口数量',
    ave_occup DOUBLE NOT NULL COMMENT '每户平均居住人数',
    latitude DOUBLE NOT NULL COMMENT '区域纬度',
    longitude DOUBLE NOT NULL COMMENT '区域经度',
    med_house_val DOUBLE NOT NULL COMMENT '房屋价值中位数',
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '加州房屋属性原始明细表';

-- CSV本地导入语句（本地测试使用）
LOAD DATA LOCAL INFILE 'D:/IntelliJ IDEA 2023.3.4/workspace/spark/input/california_housing_prices.csv'
INTO TABLE housing_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- CSV导入权限开启配置
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = ON;
SHOW VARIABLES LIKE 'local_infile';

-- 3、后台用户表
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_username (username)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '后台登录用户表';

-- 插入测试账号
INSERT INTO users (username, password) VALUES 
('admin', 'admin123'),
('test', 'test1234');

-- ====================== 基础指标查询SQL（大屏接口使用）======================
-- 房屋价值TOP10 柱状图查询
-- 房屋价值 TOP10
SELECT 
    ROW_NUMBER() OVER (ORDER BY med_house_val DESC) AS ranking,
    CONCAT('第', ROW_NUMBER() OVER (ORDER BY med_house_val DESC), '名') AS 排名,
    id AS 区域ID,
    med_house_val AS 房屋价值,
    med_inc AS 居民收入中位数,
    house_age AS 房屋平均年龄
FROM housing_info
ORDER BY med_house_val DESC
LIMIT 10;

-- 顶部全局核心指标：最高/平均/最低房价、平均收入
SELECT
    MAX(t.med_house_val) AS max_house_val,
    AVG(t.med_house_val) AS avg_house_val,
    MIN(t.med_house_val) AS min_house_val,
    AVG(t.med_inc) AS avg_med_inc
FROM (
    SELECT med_house_val, med_inc
    FROM housing_info
    ORDER BY med_house_val DESC
    LIMIT 10
) AS t;

-- 房龄分区间房价、人口统计（房龄价值衰减分析）
SELECT 
    house_age_range,
    AVG(med_house_val) as avg_house_value,
    AVG(med_inc) as avg_income,
    AVG(ave_rooms) as avg_rooms,
    COUNT(*) as region_count
FROM (
    SELECT 
        *,
        CASE 
            WHEN house_age <= 5 THEN '0-5年'
            WHEN house_age <= 10 THEN '6-10年'
            WHEN house_age <= 20 THEN '11-20年'
            WHEN house_age <= 30 THEN '21-30年'
            WHEN house_age <= 40 THEN '31-40年'
            ELSE '40年以上'
        END as house_age_range
) t
GROUP BY house_age_range
ORDER BY MIN(house_age);

-- 房价收入比分层统计（负担分布饼图）
SELECT 
    affordability_level,
    COUNT(*) as region_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM housing_info), 1) as percentage,
    AVG(med_house_val) as avg_house_value,
    AVG(med_inc) as avg_income
FROM (
    SELECT 
        *,
        ROUND(med_house_val / med_inc, 1) as price_income_ratio,
        CASE 
            WHEN med_house_val / med_inc < 0.5 THEN '超轻负担(<0.5)'
            WHEN med_house_val / med_inc < 1.0 THEN '极轻负担(0.5-1.0)'
            WHEN med_house_val / med_inc < 1.5 THEN '轻度负担(1.0-1.5)'
            WHEN med_house_val / med_inc < 3.0 THEN '中度负担(1.5-3.0)'
            ELSE '重度负担(3.0+)'
        END as affordability_level
) t
GROUP BY affordability_level
ORDER BY MIN(price_income_ratio);

-- 房屋年龄分层占比查询
SELECT 
    age_level,
    COUNT(*) as region_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM housing_info), 1) as percentage
FROM (
    SELECT 
        *,
        CASE 
            WHEN house_age <= 10 THEN '新房(0-10年)'
            WHEN house_age <= 20 THEN '次新房(11-20年)'
            WHEN house_age <= 30 THEN '成熟房(21-30年)'
            WHEN house_age <= 40 THEN '旧房(31-40年)'
            ELSE '老房(40年以上)'
        END as age_level
) t
GROUP BY age_level
ORDER BY 
    CASE age_level
        WHEN '新房(0-10年)' THEN 1
        WHEN '次新房(11-20年)' THEN 2
        WHEN '成熟房(21-30年)' THEN 3
        WHEN '旧房(31-40年)' THEN 4
        ELSE 5
    END;

-- 户型房间数与房价关联查询
SELECT 
    CASE 
        WHEN ave_rooms < 4 THEN '小户型(少于4间)'
        WHEN ave_rooms < 6 THEN '中等户型(4-6间)'
        WHEN ave_rooms < 8 THEN '大户型(6-8间)'
        WHEN ave_rooms < 10 THEN '豪华户型(8-10间)'
        ELSE '超大型(10间以上)'
    END as room_size,
    COUNT(*) as 区域数量,
    ROUND(AVG(med_house_val), 0) as 平均房价,
    ROUND(AVG(med_inc), 0) as 平均收入,
    ROUND(AVG(ave_rooms), 2) as 平均房间数
FROM housing_info
GROUP BY 
    CASE 
        WHEN ave_rooms < 4 THEN '小户型(少于4间)'
        WHEN ave_rooms < 6 THEN '中等户型(4-6间)'
        WHEN ave_rooms < 8 THEN '大户型(6-8间)'
        WHEN ave_rooms < 10 THEN '豪华户型(8-10间)'
        ELSE '超大型(10间以上)'
    END
ORDER BY AVG(ave_rooms);

-- 纬度地理分区房价收入分析
SELECT 
    latitude_zone,
    AVG(med_house_val) as avg_house_value,
    AVG(med_inc) as avg_income,
    AVG(med_house_val) / AVG(med_inc) as price_income_ratio,
    COUNT(*) as region_count
FROM (
    SELECT 
        *,
        CASE 
            WHEN latitude >= 40.0 THEN '北加州北部(40°+)'
            WHEN latitude >= 38.5 THEN '北加州湾区(38.5-40)'
            WHEN latitude >= 36.5 THEN '中加州(36.5-38.5)'
            WHEN latitude >= 34.5 THEN '南加州北部(34.5-36.5)'
            WHEN latitude >= 33.0 THEN '洛杉矶区(33-34.5)'
            WHEN latitude >= 32.5 THEN '圣地亚哥区(32.5-33)'
            ELSE '南加州南部(<32.5)'
        END as latitude_zone
) t
GROUP BY latitude_zone
ORDER BY 
    CASE latitude_zone
        WHEN '北加州北部(40°+)' THEN 1
        WHEN '北加州湾区(38.5-40)' THEN 2
        WHEN '中加州(36.5-38.5)' THEN 3
        WHEN '南加州北部(34.5-36.5)' THEN 4
        WHEN '洛杉矶区(33-34.5)' THEN 5
        WHEN '圣地亚哥区(32.5-33)' THEN 6
        ELSE 7
    END;

-- 房价分档统计
SELECT
    SUM(CASE WHEN med_house_val >= 4 THEN 1 ELSE 0 END) AS highValue,
    SUM(CASE WHEN med_house_val BETWEEN 2 AND 3 THEN 1 ELSE 0 END) AS midValue,
    SUM(CASE WHEN med_house_val BETWEEN 0 AND 1 THEN 1 ELSE 0 END) AS lowValue
FROM housing_info
WHERE med_house_val IS NOT NULL;

-- 创建房价分档统计表
CREATE TABLE house_value_zones AS
SELECT
    SUM(CASE WHEN med_house_val >= 4 THEN 1 ELSE 0 END) AS high_value,
    SUM(CASE WHEN med_house_val BETWEEN 2 AND 3 THEN 1 ELSE 0 END) AS mid_value,
    SUM(CASE WHEN med_house_val BETWEEN 0 AND 1 THEN 1 ELSE 0 END) AS low_value
FROM housing_info
WHERE med_house_val IS NOT NULL;

-- 市场综合评分指标
SELECT 
    CASE 
        WHEN indicator = 1 THEN '市场可负担性'
        WHEN indicator = 2 THEN '房屋新旧程度'
        WHEN indicator = 3 THEN '居住空间舒适度'
    END as indicator_name,
    ROUND(score, 0) as score_value,
    ROUND(actual_value, 2) as actual_value,
    description
FROM (
    SELECT 
        1 as indicator,
        CASE 
            WHEN AVG(med_house_val / med_inc) <= 4 THEN 85
            WHEN AVG(med_house_val / med_inc) <= 6 THEN 65
            ELSE 45
        END as score,
        AVG(med_house_val / med_inc) as actual_value,
        '房价收入比' as description
    FROM housing_info
    WHERE med_inc > 0
    
    UNION ALL
    
    SELECT 
        2 as indicator,
        CASE 
            WHEN AVG(house_age) <= 20 THEN 90
            WHEN AVG(house_age) <= 35 THEN 70
            ELSE 50
        END as score,
        AVG(house_age) as actual_value,
        '平均房龄(年)' as description
    FROM housing_info
    
    UNION ALL
    
    SELECT 
        3 as indicator,
        CASE 
            WHEN AVG(ave_rooms) >= 5 THEN 95
            WHEN AVG(ave_rooms) >= 4 THEN 75
            ELSE 55
        END as score,
        AVG(ave_rooms) as actual_value,
        '每户平均房间数' as description
    FROM housing_info
) t
ORDER BY indicator;

-- 四大纬度带房屋特征对比
SELECT 
    latitude_group,
    COUNT(*) as 区域数量,
    ROUND(AVG(house_age), 1) as 平均房龄,
    ROUND(AVG(ave_rooms), 1) as 平均房间数,
    ROUND(AVG(population), 0) as 平均人口,
    ROUND(AVG(ave_occup), 1) as 平均居住人数
FROM (
    SELECT 
        *,
        CASE 
            WHEN latitude >= 38.0 THEN '北加州'
            WHEN latitude >= 36.0 THEN '中加州'
            WHEN latitude >= 34.0 THEN '南加州北部'
            ELSE '南加州南部'
        END as latitude_group
) t
GROUP BY latitude_group
ORDER BY AVG(latitude) DESC;

-- 区域人口规模分级统计
SELECT 
    population_size,
    COUNT(*) as region_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM housing_info), 1) as percentage,
    AVG(med_house_val) as avg_house_value,
    AVG(ave_rooms) as avg_rooms
FROM (
    SELECT 
        *,
        CASE 
            WHEN population < 1000 THEN '微型(<1k)'
            WHEN population < 5000 THEN '小型(1-5k)'
            WHEN population < 20000 THEN '中型(5-20k)'
            WHEN population < 50000 THEN '大型(20-50k)'
            ELSE '超大型(50k+)'
        END as population_size
) t
GROUP BY population_size
ORDER BY MIN(population);

-- 高投资价值区域推荐列表
SELECT 
    id AS 区域ID,
    med_house_val AS 当前房屋价值,
    med_inc AS 居民收入,
    house_age AS 房屋年龄,
    ROUND(
        (med_inc / 10000 * 0.3) +
        ((50 - house_age) / 50 * 0.3) +
        (ave_rooms * 0.2) +
        (1 / (ave_occup / ave_rooms) * 0.2)
    , 2) AS 投资评分,
    ROUND((med_inc / AVG(med_inc) OVER ()) * (1 / (med_house_val / AVG(med_house_val) OVER ())), 2) AS 增长潜力指数,
    CASE 
        WHEN latitude > 38.0 THEN '北加州'
        WHEN latitude > 36.0 THEN '中加州'
        WHEN latitude > 34.0 THEN '南加州北部'
        ELSE '南加州南部'
    END AS 地理区域
FROM housing_info
WHERE med_house_val > 0 AND med_inc > 0
ORDER BY 投资评分 DESC
LIMIT 100;