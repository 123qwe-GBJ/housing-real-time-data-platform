/*
分层：DWS 汇总层 MySQL脚本
功能：多维度房价主题汇总宽表，包含收入、房龄、户型、地理、投资评分各类聚合统计表
适配实时ETL业务，用于大屏可视化指标查询
*/
-- 1. 创建收入区间分析表
CREATE TABLE income_range_analysis (
    income_range VARCHAR(20) PRIMARY KEY COMMENT '收入区间',
    house_value_avg DECIMAL(12,2) NOT NULL COMMENT '平均房屋价值',
    income_avg DECIMAL(10,2) NOT NULL COMMENT '平均居民收入',
    house_age_avg DECIMAL(5,1) NOT NULL COMMENT '平均房屋年龄',
    house_count INT NOT NULL COMMENT '房屋数量',
    total_population BIGINT COMMENT '总人口',
    avg_rooms DECIMAL(5,1) COMMENT '平均房间数',
    avg_bedrooms DECIMAL(5,1) COMMENT '平均卧室数',
    county_count INT COMMENT '涉及的县数量',
    region_list TEXT COMMENT '涉及的区域列表',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收入区间房屋价值分析表';

-- 插入数据：全量收入区间分析
INSERT INTO income_range_analysis (
    income_range, 
    house_value_avg, 
    income_avg, 
    house_age_avg, 
    house_count,
    total_population,
    avg_rooms,
    avg_bedrooms,
    county_count,
    region_list
)
SELECT 
    CASE
        WHEN hi.med_inc < 2 THEN '0-2万'
        WHEN hi.med_inc < 4 THEN '2-4万'
        WHEN hi.med_inc < 6 THEN '4-6万'
        WHEN hi.med_inc < 8 THEN '6-8万'
        WHEN hi.med_inc < 10 THEN '8-10万'
        WHEN hi.med_inc < 12 THEN '10-12万'
        ELSE '12万以上'
    END AS income_range,
    ROUND(AVG(hi.med_house_val), 2) AS house_value_avg,
    ROUND(AVG(hi.med_inc), 2) AS income_avg,
    ROUND(AVG(hi.house_age), 1) AS house_age_avg,
    COUNT(*) AS house_count,
    SUM(hi.population) AS total_population,
    ROUND(AVG(hi.ave_rooms), 1) AS avg_rooms,
    ROUND(AVG(hi.ave_bedrms), 1) AS avg_bedrooms,
    COUNT(DISTINCT c.county_name) AS county_count,
    GROUP_CONCAT(DISTINCT c.region_group ORDER BY c.region_group) AS region_list
FROM housing_info hi
LEFT JOIN county_geo_info c ON 
    hi.longitude BETWEEN c.bounds_sw_longitude AND c.bounds_ne_longitude 
    AND hi.latitude BETWEEN c.bounds_sw_latitude AND c.bounds_ne_latitude
WHERE hi.med_inc IS NOT NULL AND hi.med_house_val IS NOT NULL
GROUP BY income_range
ORDER BY 
    CASE income_range
        WHEN '0-2万' THEN 1
        WHEN '2-4万' THEN 2
        WHEN '4-6万' THEN 3
        WHEN '6-8万' THEN 4
        WHEN '8-10万' THEN 5
        WHEN '10-12万' THEN 6
        ELSE 7
    END;

-- 2. 创建房屋价值TOP10详细分析表
CREATE TABLE top10_house_value_analysis (
    id INT PRIMARY KEY AUTO_INCREMENT,
    original_id INT NOT NULL COMMENT '原始房屋ID',
    med_house_val DECIMAL(12,2) NOT NULL COMMENT '房屋价值',
    med_inc DECIMAL(10,2) NOT NULL COMMENT '居民收入',
    house_age DECIMAL(5,1) NOT NULL COMMENT '房屋年龄',
    income_range VARCHAR(20) NOT NULL COMMENT '收入区间',
    county_name VARCHAR(50) COMMENT '所在县',
    region_group VARCHAR(20) COMMENT '所属区域',
    ave_rooms DECIMAL(5,1) COMMENT '房间数',
    ave_bedrms DECIMAL(5,1) COMMENT '卧室数',
    population DECIMAL(12,0) COMMENT '人口',
    latitude DECIMAL(10,6) COMMENT '纬度',
    longitude DECIMAL(10,6) COMMENT '经度',
    rank_position INT NOT NULL COMMENT '排名位置',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房屋价值TOP10详细分析表';

-- 插入TOP10房屋价值数据
INSERT INTO top10_house_value_analysis (
    original_id, med_house_val, med_inc, house_age, income_range,
    county_name, region_group, ave_rooms, ave_bedrms, population,
    latitude, longitude, rank_position
)
SELECT 
    hi.id AS original_id,
    hi.med_house_val,
    hi.med_inc,
    hi.house_age,
    CASE
        WHEN hi.med_inc < 2 THEN '0-2万'
        WHEN hi.med_inc < 4 THEN '2-4万'
        WHEN hi.med_inc < 8 THEN '4-8万'
        WHEN hi.med_inc < 12 THEN '8-12万'
        ELSE '12万以上'
    END AS income_range,
    c.county_name,
    c.region_group,
    hi.ave_rooms,
    hi.ave_bedrms,
    hi.population,
    hi.latitude,
    hi.longitude,
    ROW_NUMBER() OVER (ORDER BY hi.med_house_val DESC) AS rank_position
FROM housing_info hi
LEFT JOIN county_geo_info c ON 
    hi.longitude BETWEEN c.bounds_sw_longitude AND c.bounds_ne_longitude 
    AND hi.latitude BETWEEN c.bounds_sw_latitude AND c.bounds_ne_latitude
ORDER BY hi.med_house_val DESC
LIMIT 10;

-- 3.创建简化版房龄价值分析表
CREATE TABLE simplified_age_value_analysis (
    age_range VARCHAR(20) PRIMARY KEY,
    min_age INT NOT NULL,
    max_age INT NOT NULL,
    house_count INT NOT NULL,
    avg_house_value DECIMAL(12,2) NOT NULL,
    avg_income DECIMAL(10,2) NOT NULL,
    avg_house_age DECIMAL(5,1) NOT NULL,
    avg_rooms DECIMAL(5,1) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 插入房龄分组统计数据
INSERT INTO simplified_age_value_analysis (
    age_range, min_age, max_age, house_count, 
    avg_house_value, avg_income, avg_house_age, avg_rooms
)
SELECT 
    CASE 
        WHEN house_age <= 5 THEN '0-5年'
        WHEN house_age <= 10 THEN '6-10年'
        WHEN house_age <= 20 THEN '11-20年'
        WHEN house_age <= 30 THEN '21-30年'
        WHEN house_age <= 40 THEN '31-40年'
        ELSE '40年以上'
    END as age_range,
    CASE 
        WHEN house_age <= 5 THEN 0
        WHEN house_age <= 10 THEN 6
        WHEN house_age <= 20 THEN 11
        WHEN house_age <= 30 THEN 21
        WHEN house_age <= 40 THEN 31
        ELSE 41
    END as min_age,
    CASE 
        WHEN house_age <= 5 THEN 5
        WHEN house_age <= 10 THEN 10
        WHEN house_age <= 20 THEN 20
        WHEN house_age <= 30 THEN 30
        WHEN house_age <= 40 THEN 40
        ELSE 999
    END as max_age,
    COUNT(*) as house_count,
    ROUND(AVG(med_house_val), 2) as avg_house_value,
    ROUND(AVG(med_inc), 2) as avg_income,
    ROUND(AVG(house_age), 1) as avg_house_age,
    ROUND(AVG(ave_rooms), 1) as avg_rooms
FROM housing_info
WHERE house_age IS NOT NULL AND med_house_val IS NOT NULL
GROUP BY age_range, min_age, max_age
ORDER BY min_age;

-- 4. 创建房价负担分布表
DROP TABLE IF EXISTS housing_affordability_distribution;
CREATE TABLE housing_affordability_distribution (
    affordability_level VARCHAR(30) PRIMARY KEY,
    region_count INT NOT NULL,
    percentage DECIMAL(5,1) NOT NULL,
    avg_house_value DECIMAL(12,2) NOT NULL,
    avg_income DECIMAL(10,2) NOT NULL,
    min_ratio_threshold DECIMAL(5,2) NOT NULL,
    max_ratio_threshold DECIMAL(5,2),
    level_order INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO housing_affordability_distribution (
    affordability_level, region_count, percentage, 
    avg_house_value, avg_income, min_ratio_threshold, max_ratio_threshold, level_order
)
SELECT 
    affordability_level,
    COUNT(*) as region_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM housing_info WHERE med_inc > 0), 1) as percentage,
    ROUND(AVG(med_house_val), 2) as avg_house_value,
    ROUND(AVG(med_inc), 2) as avg_income,
    CASE affordability_level
        WHEN '超轻负担(<0.5)' THEN 0.0
        WHEN '极轻负担(0.5-1.0)' THEN 0.5
        WHEN '轻度负担(1.0-1.5)' THEN 1.0
        WHEN '中度负担(1.5-3.0)' THEN 1.5
        WHEN '重度负担(3.0+)' THEN 3.0
        ELSE 0.0
    END as min_ratio,
    CASE affordability_level
        WHEN '超轻负担(<0.5)' THEN 0.5
        WHEN '极轻负担(0.5-1.0)' THEN 1.0
        WHEN '轻度负担(1.0-1.5)' THEN 1.5
        WHEN '中度负担(1.5-3.0)' THEN 3.0
        WHEN '重度负担(3.0+)' THEN NULL
        ELSE NULL
    END as max_ratio,
    CASE affordability_level
        WHEN '超轻负担(<0.5)' THEN 1
        WHEN '极轻负担(0.5-1.0)' THEN 2
        WHEN '轻度负担(1.0-1.5)' THEN 3
        WHEN '中度负担(1.5-3.0)' THEN 4
        WHEN '重度负担(3.0+)' THEN 5
        ELSE 6
    END as level_order
FROM (
    SELECT 
        med_house_val,
        med_inc,
        CASE 
            WHEN med_inc > 0 AND med_house_val / med_inc < 0.5 THEN '超轻负担(<0.5)'
            WHEN med_inc > 0 AND med_house_val / med_inc < 1.0 THEN '极轻负担(0.5-1.0)'
            WHEN med_inc > 0 AND med_house_val / med_inc < 1.5 THEN '轻度负担(1.0-1.5)'
            WHEN med_inc > 0 AND med_house_val / med_inc < 3.0 THEN '中度负担(1.5-3.0)'
            WHEN med_inc > 0 THEN '重度负担(3.0+)'
            ELSE '数据异常'
        END as affordability_level
    FROM housing_info
    WHERE med_inc > 0 AND med_house_val IS NOT NULL
) t
WHERE affordability_level != '数据异常'
GROUP BY affordability_level
ORDER BY level_order;

-- 5.创建房屋年龄分布分析表
CREATE TABLE house_age_distribution (
    age_level VARCHAR(30) PRIMARY KEY,
    age_min INT NOT NULL COMMENT '最小房龄',
    age_max INT COMMENT '最大房龄',
    region_count INT NOT NULL COMMENT '区域数量',
    percentage DECIMAL(5,1) NOT NULL COMMENT '占比(%)',
    avg_house_value DECIMAL(12,2) COMMENT '平均房价',
    avg_income DECIMAL(10,2) COMMENT '平均收入',
    avg_rooms DECIMAL(5,1) COMMENT '平均房间数',
    level_order INT NOT NULL COMMENT '等级顺序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房屋年龄分布分析表';

INSERT INTO house_age_distribution (
    age_level, age_min, age_max, region_count, percentage, 
    avg_house_value, avg_income, avg_rooms, level_order
)
SELECT 
    age_level,
    CASE age_level
        WHEN '新房(0-10年)' THEN 0
        WHEN '次新房(11-20年)' THEN 11
        WHEN '成熟房(21-30年)' THEN 21
        WHEN '旧房(31-40年)' THEN 31
        WHEN '老房(40年以上)' THEN 41
        ELSE 0
    END as age_min,
    CASE age_level
        WHEN '新房(0-10年)' THEN 10
        WHEN '次新房(11-20年)' THEN 20
        WHEN '成熟房(21-30年)' THEN 30
        WHEN '旧房(31-40年)' THEN 40
        WHEN '老房(40年以上)' THEN NULL
        ELSE NULL
    END as age_max,
    COUNT(*) as region_count,
    ROUND(COUNT(*) * 100.0 / total_regions, 1) as percentage,
    ROUND(AVG(med_house_val), 2) as avg_house_value,
    ROUND(AVG(med_inc), 2) as avg_income,
    ROUND(AVG(ave_rooms), 1) as avg_rooms,
    CASE age_level
        WHEN '新房(0-10年)' THEN 1
        WHEN '次新房(11-20年)' THEN 2
        WHEN '成熟房(21-30年)' THEN 3
        WHEN '旧房(31-40年)' THEN 4
        WHEN '老房(40年以上)' THEN 5
        ELSE 6
    END as level_order
FROM (
    SELECT 
        hi.*,
        (SELECT COUNT(*) FROM housing_info WHERE house_age IS NOT NULL) as total_regions,
        CASE 
            WHEN hi.house_age <= 10 THEN '新房(0-10年)'
            WHEN hi.house_age <= 20 THEN '次新房(11-20年)'
            WHEN hi.house_age <= 30 THEN '成熟房(21-30年)'
            WHEN hi.house_age <= 40 THEN '旧房(31-40年)'
            ELSE '老房(40年以上)'
        END as age_level
    FROM housing_info hi
    WHERE hi.house_age IS NOT NULL
) t
GROUP BY age_level, total_regions
ORDER BY level_order;

-- 6.创建房间户型与房价关系表
CREATE TABLE rooms_price_relationship (
    room_size VARCHAR(30) PRIMARY KEY,
    room_category VARCHAR(20) NOT NULL COMMENT '户型类别',
    min_rooms DECIMAL(5,1) NOT NULL COMMENT '最小房间数',
    max_rooms DECIMAL(5,1) COMMENT '最大房间数',
    region_count INT NOT NULL COMMENT '区域数量',
    avg_house_price DECIMAL(12,0) NOT NULL COMMENT '平均房价',
    avg_income DECIMAL(10,0) NOT NULL COMMENT '平均收入',
    avg_rooms DECIMAL(5,2) NOT NULL COMMENT '平均房间数',
    price_per_room DECIMAL(10,2) COMMENT '每房间平均价格',
    income_ratio DECIMAL(5,2) COMMENT '房价收入比',
    category_order INT NOT NULL COMMENT '类别顺序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房间数与房价关系分析表';

INSERT INTO rooms_price_relationship (
    room_size, room_category, min_rooms, max_rooms, 
    region_count, avg_house_price, avg_income, avg_rooms,
    category_order
)
SELECT 
    room_size,
    CASE 
        WHEN room_size = '小户型(少于4间)' THEN '小户型'
        WHEN room_size = '中等户型(4-6间)' THEN '中等户型'
        WHEN room_size = '大户型(6-8间)' THEN '大户型'
        WHEN room_size = '豪华户型(8-10间)' THEN '豪华户型'
        ELSE '超大型'
    END as room_category,
    CASE room_size
        WHEN '小户型(少于4间)' THEN 0.0
        WHEN '中等户型(4-6间)' THEN 4.0
        WHEN '大户型(6-8间)' THEN 6.0
        WHEN '豪华户型(8-10间)' THEN 8.0
        ELSE 10.0
    END as min_rooms,
    CASE room_size
        WHEN '小户型(少于4间)' THEN 4.0
        WHEN '中等户型(4-6间)' THEN 6.0
        WHEN '大户型(6-8间)' THEN 8.0
        WHEN '豪华户型(8-10间)' THEN 10.0
        ELSE NULL
    END as max_rooms,
    COUNT(*) as region_count,
    ROUND(AVG(med_house_val), 0) as avg_house_price,
    ROUND(AVG(med_inc), 0) as avg_income,
    ROUND(AVG(ave_rooms), 2) as avg_rooms,
    CASE room_size
        WHEN '小户型(少于4间)' THEN 1
        WHEN '中等户型(4-6间)' THEN 2
        WHEN '大户型(6-8间)' THEN 3
        WHEN '豪华户型(8-10间)' THEN 4
        ELSE 5
    END as category_order
FROM (
    SELECT 
        *,
        CASE 
            WHEN ave_rooms < 4 THEN '小户型(少于4间)'
            WHEN ave_rooms < 6 THEN '中等户型(4-6间)'
            WHEN ave_rooms < 8 THEN '大户型(6-8间)'
            WHEN ave_rooms < 10 THEN '豪华户型(8-10间)'
            ELSE '超大型(10间以上)'
        END as room_size
    FROM housing_info
    WHERE ave_rooms IS NOT NULL AND med_house_val IS NOT NULL
) t
GROUP BY room_size
ORDER BY AVG(ave_rooms);

UPDATE rooms_price_relationship
SET 
    price_per_room = ROUND(avg_house_price / avg_rooms, 2),
    income_ratio = ROUND(avg_house_price / NULLIF(avg_income, 0), 2);

-- 7.纬度梯度房价分析表
CREATE TABLE latitude_price_analysis (
    latitude_zone VARCHAR(50) PRIMARY KEY,
    zone_code VARCHAR(20) NOT NULL COMMENT '区域代码',
    min_latitude DECIMAL(5,1) NOT NULL COMMENT '最小纬度',
    max_latitude DECIMAL(5,1) COMMENT '最大纬度',
    region_description VARCHAR(100) COMMENT '区域描述',
    region_count INT NOT NULL COMMENT '区域数量',
    avg_house_value DECIMAL(12,0) NOT NULL COMMENT '平均房价',
    avg_income DECIMAL(10,0) NOT NULL COMMENT '平均收入',
    price_income_ratio DECIMAL(5,2) NOT NULL COMMENT '房价收入比',
    avg_latitude DECIMAL(7,3) NOT NULL COMMENT '平均纬度',
    avg_longitude DECIMAL(7,3) COMMENT '平均经度',
    avg_rooms DECIMAL(5,1) COMMENT '平均房间数',
    avg_house_age DECIMAL(5,1) COMMENT '平均房龄',
    county_count INT COMMENT '涉及县数量',
    region_list TEXT COMMENT '涉及区域',
    major_county VARCHAR(50) COMMENT '主要县',
    zone_order INT NOT NULL COMMENT '区域顺序',
    climate_zone VARCHAR(30) COMMENT '气候带',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_zone_order (zone_order),
    INDEX idx_latitude (avg_latitude),
    INDEX idx_house_value (avg_house_value),
    INDEX idx_price_ratio (price_income_ratio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='纬度梯度与房价关系分析表';

INSERT INTO latitude_price_analysis (
    latitude_zone, zone_code, min_latitude, max_latitude, region_description,
    region_count, avg_house_value, avg_income, price_income_ratio,
    avg_latitude, avg_longitude, avg_rooms, avg_house_age,
    zone_order, climate_zone
)
SELECT 
    latitude_zone,
    CASE latitude_zone
        WHEN '北加州北部(40°+)' THEN 'NC_North'
        WHEN '北加州湾区(38.5-40)' THEN 'NC_Bay'
        WHEN '中加州(36.5-38.5)' THEN 'Central'
        WHEN '南加州北部(34.5-36.5)' THEN 'SC_North'
        WHEN '洛杉矶区(33-34.5)' THEN 'LA'
        WHEN '圣地亚哥区(32.5-33)' THEN 'SD'
        ELSE 'SC_South'
    END as zone_code,
    CASE latitude_zone
        WHEN '北加州北部(40°+)' THEN 40.0
        WHEN '北加州湾区(38.5-40)' THEN 38.5
        WHEN '中加州(36.5-38.5)' THEN 36.5
        WHEN '南加州北部(34.5-36.5)' THEN 34.5
        WHEN '洛杉矶区(33-34.5)' THEN 33.0
        WHEN '圣地亚哥区(32.5-33)' THEN 32.5
        ELSE 0.0
    END as min_latitude,
    CASE latitude_zone
        WHEN '北加州北部(40°+)' THEN NULL
        WHEN '北加州湾区(38.5-40)' THEN 40.0
        WHEN '中加州(36.5-38.5)' THEN 38.5
        WHEN '南加州北部(34.5-36.5)' THEN 36.5
        WHEN '洛杉矶区(33-34.5)' THEN 34.5
        WHEN '圣地亚哥区(32.5-33)' THEN 33.0
        ELSE 32.5
    END as max_latitude,
    CASE latitude_zone
        WHEN '北加州北部(40°+)' THEN '北加州最北部，靠近俄勒冈州'
        WHEN '北加州湾区(38.5-40)' THEN '旧金山湾区及周边'
        WHEN '中加州(36.5-38.5)' THEN '加州中部农业区和海岸'
        WHEN '南加州北部(34.5-36.5)' THEN '南加州北部内陆和海岸'
        WHEN '洛杉矶区(33-34.5)' THEN '大洛杉矶地区'
        WHEN '圣地亚哥区(32.5-33)' THEN '圣地亚哥及周边'
        ELSE '南加州最南部，靠近墨西哥边境'
    END as region_description,
    COUNT(*) as region_count,
    ROUND(AVG(med_house_val), 0) as avg_house_value,
    ROUND(AVG(med_inc), 0) as avg_income,
    ROUND(AVG(med_house_val) / AVG(med_inc), 2) as price_income_ratio,
    ROUND(AVG(latitude), 3) as avg_latitude,
    ROUND(AVG(longitude), 3) as avg_longitude,
    ROUND(AVG(ave_rooms), 1) as avg_rooms,
    ROUND(AVG(house_age), 1) as avg_house_age,
    CASE latitude_zone
        WHEN '北加州北部(40°+)' THEN 1
        WHEN '北加州湾区(38.5-40)' THEN 2
        WHEN '中加州(36.5-38.5)' THEN 3
        WHEN '南加州北部(34.5-36.5)' THEN 4
        WHEN '洛杉矶区(33-34.5)' THEN 5
        WHEN '圣地亚哥区(32.5-33)' THEN 6
        ELSE 7
    END as zone_order,
    CASE latitude_zone
        WHEN '北加州北部(40°+)' THEN '温带海洋性气候'
        WHEN '北加州湾区(38.5-40)' THEN '地中海气候'
        WHEN '中加州(36.5-38.5)' THEN '地中海气候'
        WHEN '南加州北部(34.5-36.5)' THEN '地中海气候'
        WHEN '洛杉矶区(33-34.5)' THEN '地中海气候'
        WHEN '圣地亚哥区(32.5-33)' THEN '地中海气候'
        ELSE '半干旱气候'
    END as climate_zone
FROM (
    SELECT 
        hi.*,
        CASE 
            WHEN hi.latitude >= 40.0 THEN '北加州北部(40°+)'
            WHEN hi.latitude >= 38.5 THEN '北加州湾区(38.5-40)'
            WHEN hi.latitude >= 36.5 THEN '中加州(36.5-38.5)'
            WHEN hi.latitude >= 34.5 THEN '南加州北部(34.5-36.5)'
            WHEN hi.latitude >= 33.0 THEN '洛杉矶区(33-34.5)'
            WHEN hi.latitude >= 32.5 THEN '圣地亚哥区(32.5-33)'
            ELSE '南加州南部(<32.5)'
        END as latitude_zone
    FROM housing_info hi
    WHERE hi.latitude IS NOT NULL AND hi.med_house_val IS NOT NULL
) t
GROUP BY latitude_zone
ORDER BY zone_order;

-- 8.市场综合评分表
DROP TABLE IF EXISTS exact_market_scoreboard;
CREATE TABLE exact_market_scoreboard (
    id INT PRIMARY KEY AUTO_INCREMENT,
    indicator_name VARCHAR(50) NOT NULL,
    score_value INT NOT NULL,
    actual_value DECIMAL(10,2),
    description VARCHAR(100) NOT NULL,
    indicator_order INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO exact_market_scoreboard (indicator_name, score_value, actual_value, description, indicator_order)
SELECT 
    CASE 
        WHEN indicator = 1 THEN '市场可负担性'
        WHEN indicator = 2 THEN '房屋新旧程度'
        WHEN indicator = 3 THEN '居住空间舒适度'
    END as indicator_name,
    ROUND(score, 0) as score_value,
    ROUND(actual_value, 2) as actual_value,
    description,
    indicator as indicator_order
FROM (
    SELECT 1 as indicator,
        CASE WHEN AVG(med_house_val / med_inc) <= 4 THEN 85
             WHEN AVG(med_house_val / med_inc) <= 6 THEN 65
             ELSE 45 END as score,
        AVG(med_house_val / med_inc) as actual_value,
        '房价收入比' as description
    FROM housing_info WHERE med_inc > 0
    UNION ALL
    SELECT 2 as indicator,
        CASE WHEN AVG(house_age) <= 20 THEN 90
             WHEN AVG(house_age) <= 35 THEN 70
             ELSE 50 END as score,
        AVG(house_age) as actual_value,
        '平均房龄(年)' as description
    FROM housing_info WHERE house_age IS NOT NULL
    UNION ALL
    SELECT 3 as indicator,
        CASE WHEN AVG(ave_rooms) >= 5 THEN 95
             WHEN AVG(ave_rooms) >= 4 THEN 75
             ELSE 55 END as score,
        AVG(ave_rooms) as actual_value,
        '每户平均房间数' as description
    FROM housing_info WHERE ave_rooms IS NOT NULL
) t
ORDER BY indicator;

INSERT INTO exact_market_scoreboard (indicator_name, score_value, actual_value, description, indicator_order)
SELECT 
    '综合评分' as indicator_name,
    ROUND(AVG(score_value), 0) as score_value,
    NULL as actual_value,
    '三项指标平均分' as description,
    4 as indicator_order
FROM exact_market_scoreboard
WHERE indicator_order <= 3;

-- 9.纬度带房屋特征对比表
CREATE TABLE latitude_zone_comparison (
    latitude_group VARCHAR(30) PRIMARY KEY COMMENT '纬度带',
    min_latitude DECIMAL(5,1) NOT NULL COMMENT '最小纬度',
    max_latitude DECIMAL(5,1) COMMENT '最大纬度',
    region_count INT NOT NULL COMMENT '区域数量',
    avg_house_age DECIMAL(5,1) NOT NULL COMMENT '平均房龄',
    avg_rooms DECIMAL(5,1) NOT NULL COMMENT '平均房间数',
    avg_population DECIMAL(12,0) NOT NULL COMMENT '平均人口',
    avg_occupancy DECIMAL(5,1) NOT NULL COMMENT '平均居住人数',
    avg_latitude DECIMAL(7,3) NOT NULL COMMENT '平均纬度',
    zone_order INT NOT NULL COMMENT '区域顺序',
    avg_house_value DECIMAL(12,0) COMMENT '平均房价',
    avg_income DECIMAL(10,0) COMMENT '平均收入',
    avg_bedrooms DECIMAL(5,1) COMMENT '平均卧室数',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_latitude_group (latitude_group),
    INDEX idx_zone_order (zone_order),
    INDEX idx_latitude (avg_latitude)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='纬度带房屋特征对比分析表';

INSERT INTO latitude_zone_comparison (
    latitude_group, min_latitude, max_latitude, region_count,
    avg_house_age, avg_rooms, avg_population, avg_occupancy,
    avg_latitude, zone_order,
    avg_house_value, avg_income, avg_bedrooms
)
SELECT 
    latitude_group,
    CASE latitude_group WHEN '北加州' THEN 38.0 WHEN '中加州' THEN 36.0 WHEN '南加州北部' THEN 34.0 ELSE 0.0 END as min_latitude,
    CASE latitude_group WHEN '北加州' THEN NULL WHEN '中加州' THEN 38.0 WHEN '南加州北部' THEN 36.0 ELSE 34.0 END as max_latitude,
    COUNT(*) as region_count,
    ROUND(AVG(house_age), 1) as avg_house_age,
    ROUND(AVG(ave_rooms), 1) as avg_rooms,
    ROUND(AVG(population), 0) as avg_population,
    ROUND(AVG(ave_occup), 1) as avg_occupancy,
    ROUND(AVG(latitude), 3) as avg_latitude,
    CASE latitude WHEN '北加州' THEN 1 WHEN '中加州' THEN 2 WHEN '南加州北部' THEN 3 ELSE 4 END as zone_order,
    ROUND(AVG(med_house_val), 0) as avg_house_value,
    ROUND(AVG(med_inc), 0) as avg_income,
    ROUND(AVG(ave_bedrms), 1) as avg_bedrooms
FROM (
    SELECT *,
        CASE 
            WHEN hi.latitude >= 38.0 THEN '北加州'
            WHEN hi.latitude >= 36.0 THEN '中加州'
            WHEN hi.latitude >= 34.0 THEN '南加州北部'
            ELSE '南加州南部'
        END as latitude_group
    FROM housing_info hi
    WHERE hi.latitude IS NOT NULL
) t
GROUP BY latitude_group
ORDER BY AVG(latitude) DESC;

-- 10.房屋价值分档统计表
CREATE TABLE house_value_zones AS
SELECT
    SUM(CASE WHEN med_house_val >= 4 THEN 1 ELSE 0 END) AS high_value,
    SUM(CASE WHEN med_house_val BETWEEN 2 AND 3 THEN 1 ELSE 0 END) AS mid_value,
    SUM(CASE WHEN med_house_val BETWEEN 0 AND 1 THEN 1 ELSE 0 END) AS low_value
FROM housing_info
WHERE med_house_val IS NOT NULL;

-- 人口规模统计表
CREATE TABLE IF NOT EXISTS housing_population_size_stats (
    population_size VARCHAR(20) NOT NULL COMMENT '人口规模分类（微型/小型/中型等）',
    region_count BIGINT NOT NULL COMMENT '对应人口规模的区域数量',
    percentage DECIMAL(5, 1) NOT NULL COMMENT '区域数量占比（%，保留1位小数）',
    avg_house_value DOUBLE NOT NULL COMMENT '对应人口规模区域房屋价值均值',
    avg_rooms DOUBLE NOT NULL COMMENT '对应人口区域平均房间数',
    PRIMARY KEY (population_size)
) ENGINE = InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '加州房屋区域人口规模分组统计表';

-- 高价值投资推荐表（中文字段全部改为英文）
CREATE TABLE IF NOT EXISTS housing_invest_recommend (
    region_id INT COMMENT '数据行唯一索引（对应原表housing_info的id）',
    house_value DOUBLE NOT NULL COMMENT '房屋价值中位数',
    median_income DOUBLE NOT NULL COMMENT '区域居民收入中位数',
    house_age DOUBLE NOT NULL COMMENT '房屋平均年龄（年）',
    invest_score DECIMAL(10, 2) NOT NULL COMMENT '区域房屋投资综合评分',
    geo_region VARCHAR(50) NOT NULL COMMENT '地理位置划分（北加州/中加州等）',
    PRIMARY KEY (region_id)
) ENGINE = InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '加州房屋高价值投资推荐区域表';