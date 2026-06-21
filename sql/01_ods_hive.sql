/*
  分层：ODS 原始数据层
  功能：创建县域地理信息维度原始表，用于后续多维度数据关联分析
*/
-- . 创建county_geo_info表
DROP TABLE IF EXISTS county_geo_info;
CREATE TABLE county_geo_info (
    county_name STRING COMMENT '县名称',
    center_longitude DECIMAL(10, 6) COMMENT '中心经度',
    center_latitude DECIMAL(10, 6) COMMENT '中心纬度',
    bounds_sw_longitude DECIMAL(10, 6) COMMENT '西南边界经度',
    bounds_sw_latitude DECIMAL(10, 6) COMMENT '西南边界纬度',
    bounds_ne_longitude DECIMAL(10, 6) COMMENT '东北边界经度',
    bounds_ne_latitude DECIMAL(10, 6) COMMENT '东北边界纬度',
    region_group STRING COMMENT '区域组'
)
COMMENT '加州各县市地理坐标信息表'
STORED AS ORC;

INSERT INTO county_geo_info VALUES
    -- 旧金山湾区（10个）
    ('San Francisco', -122.4194, 37.7749, -122.52, 37.70, -122.35, 37.82, 'Bay Area'),
    ('Alameda', -121.9216, 37.6467, -122.35, 37.45, -121.60, 37.85, 'Bay Area'),
    ('Santa Clara', -121.9552, 37.2795, -122.20, 37.15, -121.65, 37.45, 'Bay Area'),
    ('San Mateo', -122.3239, 37.4969, -122.52, 37.40, -122.10, 37.65, 'Bay Area'),
    ('Contra Costa', -121.9269, 37.9190, -122.45, 37.75, -121.60, 38.10, 'Bay Area'),
    ('Marin', -122.6084, 38.0834, -122.95, 37.85, -122.40, 38.35, 'Bay Area'),
    ('Sonoma', -122.8945, 38.5272, -123.50, 38.15, -122.40, 38.90, 'Bay Area'),
    ('Napa', -122.2871, 38.5025, -122.65, 38.15, -122.00, 38.85, 'Bay Area'),
    ('Solano', -121.9446, 38.2739, -122.40, 38.00, -121.60, 38.55, 'Bay Area'),
    ('Sacramento', -121.4944, 38.5816, -121.85, 38.25, -121.10, 38.90, 'Bay Area'),
    
    -- 洛杉矶地区（7个）
    ('Los Angeles', -118.2437, 34.0522, -118.95, 33.70, -117.65, 34.85, 'Los Angeles Area'),
    ('Orange', -117.8531, 33.7879, -118.20, 33.55, -117.50, 33.95, 'Los Angeles Area'),
    ('San Diego', -117.1611, 32.7157, -117.60, 32.53, -116.08, 33.51, 'Los Angeles Area'),
    ('Riverside', -117.3962, 33.9806, -117.67, 33.42, -114.43, 34.08, 'Los Angeles Area'),
    ('San Bernardino', -117.2898, 34.1083, -117.80, 33.82, -114.13, 35.81, 'Los Angeles Area'),
    ('Ventura', -119.1391, 34.3705, -119.48, 33.85, -118.63, 34.90, 'Los Angeles Area'),
    ('Santa Barbara', -120.0359, 34.6544, -120.67, 33.88, -119.00, 35.11, 'Los Angeles Area'),
    
    -- 中央山谷地区（8个）
    ('Fresno', -119.7726, 36.7468, -120.70, 35.90, -118.50, 37.60, 'Central Valley'),
    ('Kern', -118.7278, 35.3433, -120.25, 34.85, -117.40, 36.00, 'Central Valley'),
    ('Tulare', -118.8056, 36.2077, -119.70, 35.80, -118.00, 36.70, 'Central Valley'),
    ('Kings', -119.8913, 36.0754, -120.30, 35.75, -119.40, 36.55, 'Central Valley'),
    ('Merced', -120.7180, 37.1841, -121.20, 36.70, -120.00, 37.70, 'Central Valley'),
    ('Madera', -119.7085, 37.1841, -120.55, 36.70, -119.00, 37.80, 'Central Valley'),
    ('San Joaquin', -121.2719, 37.9341, -121.60, 37.50, -120.85, 38.30, 'Central Valley'),
    ('Stanislaus', -120.9967, 37.5591, -121.50, 37.10, -120.50, 38.00, 'Central Valley'),
    
    -- 北加州地区（21个）
    ('Mendocino', -123.6995, 39.3072, -123.85, 38.65, -123.00, 40.00, 'Northern California'),
    ('Humboldt', -123.9577, 40.6977, -124.50, 39.80, -123.40, 41.50, 'Northern California'),
    ('Del Norte', -123.9273, 41.7151, -124.50, 41.40, -123.50, 42.00, 'Northern California'),
    ('Siskiyou', -122.4666, 41.5925, -123.70, 40.80, -121.00, 42.50, 'Northern California'),
    ('Trinity', -122.9907, 40.6507, -123.70, 39.80, -122.50, 41.30, 'Northern California'),
    ('Shasta', -122.2411, 40.7639, -122.80, 40.20, -121.50, 41.30, 'Northern California'),
    ('Lassen', -120.5052, 40.6457, -121.50, 39.90, -119.50, 41.50, 'Northern California'),
    ('Modoc', -120.7683, 41.5897, -121.50, 41.00, -119.50, 42.00, 'Northern California'),
    ('Plumas', -120.8031, 39.9776, -121.50, 39.50, -120.00, 40.50, 'Northern California'),
    ('Butte', -121.6193, 39.6669, -121.80, 39.20, -121.00, 40.20, 'Northern California'),
    ('Glenn', -122.4229, 39.5983, -122.80, 39.20, -122.00, 40.00, 'Northern California'),
    ('Tehama', -122.4034, 40.1256, -122.80, 39.70, -121.70, 40.50, 'Northern California'),
    ('Colusa', -122.1976, 39.1782, -122.50, 38.90, -121.80, 39.50, 'Northern California'),
    ('Sutter', -121.7484, 39.0347, -121.90, 38.70, -121.50, 39.40, 'Northern California'),
    ('Yuba', -121.4036, 39.2694, -121.70, 38.90, -121.00, 39.70, 'Northern California'),
    ('Nevada', -120.9993, 39.3016, -121.40, 39.00, -120.50, 39.60, 'Northern California'),
    ('Placer', -121.0771, 39.0639, -121.50, 38.70, -120.00, 39.50, 'Northern California'),
    ('El Dorado', -120.6733, 38.7786, -121.00, 38.50, -119.80, 39.20, 'Northern California'),
    ('Yolo', -121.9706, 38.6845, -122.30, 38.30, -121.50, 39.00, 'Northern California'),
    ('Lake', -122.7849, 39.1003, -123.10, 38.70, -122.30, 39.50, 'Northern California'),
    ('Sierra', -120.5171, 39.5803, -121.00, 39.30, -120.00, 39.90, 'Northern California'),
    
    -- 中部海岸地区（5个）
    ('Monterey', -121.6165, 36.2397, -122.00, 35.70, -120.30, 36.90, 'Central Coast'),
    ('San Benito', -121.1652, 36.6059, -121.50, 36.10, -120.60, 37.10, 'Central Coast'),
    ('San Luis Obispo', -120.6596, 35.3102, -121.50, 34.90, -119.50, 35.90, 'Central Coast'),
    ('Santa Cruz', -122.0308, 36.9741, -122.30, 36.80, -121.60, 37.30, 'Central Coast'),
    ('San Luis Rey', -117.3231, 33.3014, -117.60, 33.10, -117.00, 33.50, 'Central Coast'),
    
    -- 内陆地区（7个）
    ('Inyo', -118.1100, 36.5552, -118.70, 35.70, -117.00, 37.70, 'Inland Empire'),
    ('Mono', -118.9501, 37.9390, -119.50, 37.50, -118.20, 38.50, 'Inland Empire'),
    ('Alpine', -119.8189, 38.5974, -120.00, 38.40, -119.50, 38.80, 'Inland Empire'),
    ('Calaveras', -120.6681, 38.2046, -121.00, 37.90, -120.20, 38.50, 'Inland Empire'),
    ('Amador', -120.7221, 38.4464, -121.00, 38.20, -120.30, 38.70, 'Inland Empire'),
    ('Tuolumne', -119.8875, 38.0276, -120.50, 37.70, -119.00, 38.50, 'Inland Empire'),
    ('Mariposa', -119.9652, 37.4922, -120.50, 37.20, -119.00, 37.80, 'Inland Empire');



-- 1. 创建income_range_analysis表
DROP TABLE IF EXISTS income_range_analysis;
CREATE TABLE income_range_analysis (
    income_range STRING COMMENT '收入区间',
    house_value_avg DECIMAL(12,2) COMMENT '平均房屋价值',
    income_avg DECIMAL(10,2) COMMENT '平均居民收入',
    house_age_avg DECIMAL(5,1) COMMENT '平均房屋年龄',
    house_count INT COMMENT '房屋数量',
    total_population BIGINT COMMENT '总人口',
    avg_rooms DECIMAL(5,1) COMMENT '平均房间数',
    avg_bedrooms DECIMAL(5,1) COMMENT '平均卧室数',
    county_count INT COMMENT '涉及的县数量',
    region_list STRING COMMENT '涉及的区域列表'
)
COMMENT '收入区间房屋价值分析表'
STORED AS ORC;

INSERT OVERWRITE TABLE income_range_analysis
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
    CONCAT_WS(',', COLLECT_SET(DISTINCT c.region_group)) AS region_list
FROM housing_info hi
LEFT JOIN county_geo_info c ON 
    hi.longitude BETWEEN c.bounds_sw_longitude AND c.bounds_ne_longitude 
    AND hi.latitude BETWEEN c.bounds_sw_latitude AND c.bounds_ne_latitude
WHERE hi.med_inc IS NOT NULL AND hi.med_house_val IS NOT NULL
GROUP BY 
    CASE
        WHEN hi.med_inc < 2 THEN '0-2万'
        WHEN hi.med_inc < 4 THEN '2-4万'
        WHEN hi.med_inc < 6 THEN '4-6万'
        WHEN hi.med_inc < 8 THEN '6-8万'
        WHEN hi.med_inc < 10 THEN '8-10万'
        WHEN hi.med_inc < 12 THEN '10-12万'
        ELSE '12万以上'
    END
ORDER BY 
    CASE 
        WHEN CASE
            WHEN hi.med_inc < 2 THEN '0-2万'
            WHEN hi.med_inc < 4 THEN '2-4万'
            WHEN hi.med_inc < 6 THEN '4-6万'
            WHEN hi.med_inc < 8 THEN '6-8万'
            WHEN hi.med_inc < 10 THEN '8-10万'
            WHEN hi.med_inc < 12 THEN '10-12万'
            ELSE '12万以上'
        END = '0-2万' THEN 1
        WHEN CASE
            WHEN hi.med_inc < 2 THEN '0-2万'
            WHEN hi.med_inc < 4 THEN '2-4万'
            WHEN hi.med_inc < 6 THEN '4-6万'
            WHEN hi.med_inc < 8 THEN '6-8万'
            WHEN hi.med_inc < 10 THEN '8-10万'
            WHEN hi.med_inc < 12 THEN '10-12万'
            ELSE '12万以上'
        END = '2-4万' THEN 2
        WHEN CASE
            WHEN hi.med_inc < 2 THEN '0-2万'
            WHEN hi.med_inc < 4 THEN '2-4万'
            WHEN hi.med_inc < 6 THEN '4-6万'
            WHEN hi.med_inc < 8 THEN '6-8万'
            WHEN hi.med_inc < 10 THEN '8-10万'
            WHEN hi.med_inc < 12 THEN '10-12万'
            ELSE '12万以上'
        END = '4-6万' THEN 3
        WHEN CASE
            WHEN hi.med_inc < 2 THEN '0-2万'
            WHEN hi.med_inc < 4 THEN '2-4万'
            WHEN hi.med_inc < 6 THEN '4-6万'
            WHEN hi.med_inc < 8 THEN '6-8万'
            WHEN hi.med_inc < 10 THEN '8-10万'
            WHEN hi.med_inc < 12 THEN '10-12万'
            ELSE '12万以上'
        END = '6-8万' THEN 4
        WHEN CASE
            WHEN hi.med_inc < 2 THEN '0-2万'
            WHEN hi.med_inc < 4 THEN '2-4万'
            WHEN hi.med_inc < 6 THEN '4-6万'
            WHEN hi.med_inc < 8 THEN '6-8万'
            WHEN hi.med_inc < 10 THEN '8-10万'
            WHEN hi.med_inc < 12 THEN '10-12万'
            ELSE '12万以上'
        END = '8-10万' THEN 5
        WHEN CASE
            WHEN hi.med_inc < 2 THEN '0-2万'
            WHEN hi.med_inc < 4 THEN '2-4万'
            WHEN hi.med_inc < 6 THEN '4-6万'
            WHEN hi.med_inc < 8 THEN '6-8万'
            WHEN hi.med_inc < 10 THEN '8-10万'
            WHEN hi.med_inc < 12 THEN '10-12万'
            ELSE '12万以上'
        END = '10-12万' THEN 6
        ELSE 7
    END;



-- 2. 创建top10_house_value_analysis表
DROP TABLE IF EXISTS top10_house_value_analysis;
CREATE TABLE top10_house_value_analysis (
    id INT COMMENT 'ID',
    original_id INT COMMENT '原始房屋ID',
    med_house_val DECIMAL(12,2) COMMENT '房屋价值',
    med_inc DECIMAL(10,2) COMMENT '居民收入',
    house_age DECIMAL(5,1) COMMENT '房屋年龄',
    income_range STRING COMMENT '收入区间',
    county_name STRING COMMENT '所在县',
    region_group STRING COMMENT '所属区域',
    ave_rooms DECIMAL(5,1) COMMENT '房间数',
    ave_bedrms DECIMAL(5,1) COMMENT '卧室数',
    population DECIMAL(12,0) COMMENT '人口',
    latitude DECIMAL(10,6) COMMENT '纬度',
    longitude DECIMAL(10,6) COMMENT '经度',
    rank_position INT COMMENT '排名位置'
)
COMMENT '房屋价值TOP10详细分析表'
STORED AS ORC;


-- 清空表（如果需要重新加载）
TRUNCATE TABLE top10_house_value_analysis;

-- 插入TOP10数据（Hive兼容写法）
INSERT INTO TABLE top10_house_value_analysis
SELECT 
    rn AS id,
    original_id,
    med_house_val,
    med_inc,
    house_age,
    income_range,
    county_name,
    region_group,
    ave_rooms,
    ave_bedrms,
    population,
    latitude,
    longitude,
    rn AS rank_position
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY hi.med_house_val DESC) AS rn,
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
        COALESCE(c.county_name, '未知') AS county_name,
        COALESCE(c.region_group, '未知') AS region_group,
        hi.ave_rooms,
        hi.ave_bedrms,
        hi.population,
        hi.latitude,
        hi.longitude
    FROM housing_info hi
    LEFT JOIN county_geo_info c 
        ON hi.longitude BETWEEN c.bounds_sw_longitude AND c.bounds_ne_longitude 
        AND hi.latitude BETWEEN c.bounds_sw_latitude AND c.bounds_ne_latitude
    WHERE hi.med_house_val IS NOT NULL
) ranked_data
WHERE rn <= 10
ORDER BY rn;




-- 3. 创建simplified_age_value_analysis表
DROP TABLE IF EXISTS simplified_age_value_analysis;
CREATE TABLE simplified_age_value_analysis (
    age_range STRING COMMENT '房龄区间',
    min_age INT COMMENT '最小年龄',
    max_age INT COMMENT '最大年龄',
    house_count INT COMMENT '房屋数量',
    avg_house_value DECIMAL(12,2) COMMENT '平均房屋价值',
    avg_income DECIMAL(10,2) COMMENT '平均收入',
    avg_house_age DECIMAL(5,1) COMMENT '平均房龄',
    avg_rooms DECIMAL(5,1) COMMENT '平均房间数'
)
STORED AS ORC;


INSERT OVERWRITE TABLE simplified_age_value_analysis
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
GROUP BY 
    CASE 
        WHEN house_age <= 5 THEN '0-5年'
        WHEN house_age <= 10 THEN '6-10年'
        WHEN house_age <= 20 THEN '11-20年'
        WHEN house_age <= 30 THEN '21-30年'
        WHEN house_age <= 40 THEN '31-40年'
        ELSE '40年以上'
    END,
    CASE 
        WHEN house_age <= 5 THEN 0
        WHEN house_age <= 10 THEN 6
        WHEN house_age <= 20 THEN 11
        WHEN house_age <= 30 THEN 21
        WHEN house_age <= 40 THEN 31
        ELSE 41
    END,
    CASE 
        WHEN house_age <= 5 THEN 5
        WHEN house_age <= 10 THEN 10
        WHEN house_age <= 20 THEN 20
        WHEN house_age <= 30 THEN 30
        WHEN house_age <= 40 THEN 40
        ELSE 999
    END
ORDER BY min_age;



-- 4. 创建housing_affordability_distribution表
DROP TABLE IF EXISTS housing_affordability_distribution;
CREATE TABLE housing_affordability_distribution (
    affordability_level STRING COMMENT '负担水平',
    region_count INT COMMENT '区域数量',
    percentage DECIMAL(5,1) COMMENT '百分比',
    avg_house_value DECIMAL(12,2) COMMENT '平均房屋价值',
    avg_income DECIMAL(10,2) COMMENT '平均收入',
    min_ratio_threshold DECIMAL(5,2) COMMENT '最小比率阈值',
    max_ratio_threshold DECIMAL(5,2) COMMENT '最大比率阈值',
    level_order INT COMMENT '等级顺序'
)
STORED AS ORC;


INSERT OVERWRITE TABLE housing_affordability_distribution
SELECT 
    affordability_level,
    COUNT(*) as region_count,
    ROUND(COUNT(*) * 100.0 / total.total_regions, 1) as percentage,
    ROUND(AVG(med_house_val), 2) as avg_house_value,
    ROUND(AVG(med_inc), 2) as avg_income,
    CASE affordability_level
        WHEN '超轻负担(<0.5)' THEN 0.0
        WHEN '极轻负担(0.5-1.0)' THEN 0.5
        WHEN '轻度负担(1.0-1.5)' THEN 1.0
        WHEN '中度负担(1.5-3.0)' THEN 1.5
        WHEN '重度负担(3.0+)' THEN 3.0
        ELSE 0.0
    END as min_ratio_threshold,
    CASE affordability_level
        WHEN '超轻负担(<0.5)' THEN 0.5
        WHEN '极轻负担(0.5-1.0)' THEN 1.0
        WHEN '轻度负担(1.0-1.5)' THEN 1.5
        WHEN '中度负担(1.5-3.0)' THEN 3.0
        WHEN '重度负担(3.0+)' THEN NULL
        ELSE NULL
    END as max_ratio_threshold,
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
CROSS JOIN (
    SELECT COUNT(*) as total_regions 
    FROM housing_info 
    WHERE med_inc > 0
) total
WHERE affordability_level != '数据异常'
GROUP BY affordability_level, total.total_regions
ORDER BY level_order;



-- 5. 创建house_age_distribution表
DROP TABLE IF EXISTS house_age_distribution;
CREATE TABLE house_age_distribution (
    age_level STRING COMMENT '年龄等级',
    age_min INT COMMENT '最小房龄',
    age_max INT COMMENT '最大房龄',
    region_count INT COMMENT '区域数量',
    percentage DECIMAL(5,1) COMMENT '占比(%)',
    avg_house_value DECIMAL(12,2) COMMENT '平均房价',
    avg_income DECIMAL(10,2) COMMENT '平均收入',
    avg_rooms DECIMAL(5,1) COMMENT '平均房间数',
    level_order INT COMMENT '等级顺序'
)
COMMENT '房屋年龄分布分析表'
STORED AS ORC;


INSERT OVERWRITE TABLE house_age_distribution
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
    ROUND(COUNT(*) * 100.0 / total.total_regions, 1) as percentage,
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
CROSS JOIN (
    SELECT COUNT(*) as total_regions 
    FROM housing_info 
    WHERE house_age IS NOT NULL
) total
GROUP BY age_level, total.total_regions
ORDER BY level_order;

-- 6. 创建rooms_price_relationship表
DROP TABLE IF EXISTS rooms_price_relationship;
CREATE TABLE rooms_price_relationship (
    room_size STRING COMMENT '房间大小',
    room_category STRING COMMENT '户型类别',
    min_rooms DECIMAL(5,1) COMMENT '最小房间数',
    max_rooms DECIMAL(5,1) COMMENT '最大房间数',
    region_count INT COMMENT '区域数量',
    avg_house_price DECIMAL(12,0) COMMENT '平均房价',
    avg_income DECIMAL(10,0) COMMENT '平均收入',
    avg_rooms DECIMAL(5,2) COMMENT '平均房间数',
    price_per_room DECIMAL(10,2) COMMENT '每房间平均价格',
    income_ratio DECIMAL(5,2) COMMENT '房价收入比',
    category_order INT COMMENT '类别顺序'
)
COMMENT '房间数与房价关系分析表'
STORED AS ORC;

INSERT OVERWRITE TABLE rooms_price_relationship
SELECT 
    room_data.room_size,
    room_data.room_category,
    room_data.min_rooms,
    room_data.max_rooms,
    room_data.region_count,
    room_data.avg_house_price,
    room_data.avg_income,
    room_data.avg_rooms,
    ROUND(room_data.avg_house_price / room_data.avg_rooms, 2) as price_per_room,
    ROUND(room_data.avg_house_price / NULLIF(room_data.avg_income, 0), 2) as income_ratio,
    room_data.category_order
FROM (
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
) room_data
ORDER BY room_data.avg_rooms;



-- 7. 创建latitude_price_analysis表
DROP TABLE IF EXISTS latitude_price_analysis;
CREATE TABLE latitude_price_analysis (
    latitude_zone STRING COMMENT '纬度区域',
    zone_code STRING COMMENT '区域代码',
    min_latitude DECIMAL(5,1) COMMENT '最小纬度',
    max_latitude DECIMAL(5,1) COMMENT '最大纬度',
    region_description STRING COMMENT '区域描述',
    region_count INT COMMENT '区域数量',
    avg_house_value DECIMAL(12,0) COMMENT '平均房价',
    avg_income DECIMAL(10,0) COMMENT '平均收入',
    price_income_ratio DECIMAL(5,2) COMMENT '房价收入比',
    avg_latitude DECIMAL(7,3) COMMENT '平均纬度',
    avg_longitude DECIMAL(7,3) COMMENT '平均经度',
    avg_rooms DECIMAL(5,1) COMMENT '平均房间数',
    avg_house_age DECIMAL(5,1) COMMENT '平均房龄',
    county_count INT COMMENT '涉及县数量',
    region_list STRING COMMENT '涉及区域',
    major_county STRING COMMENT '主要县',
    zone_order INT COMMENT '区域顺序',
    climate_zone STRING COMMENT '气候带'
)
COMMENT '纬度梯度与房价关系分析表'
STORED AS ORC;


INSERT OVERWRITE TABLE latitude_price_analysis
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
    0 as county_count,
    '' as region_list,
    '' as major_county,
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


-- 8. 创建exact_market_scoreboard表
DROP TABLE IF EXISTS exact_market_scoreboard;
CREATE TABLE exact_market_scoreboard (
    id INT COMMENT 'ID',
    indicator_name STRING COMMENT '指标名称',
    score_value INT COMMENT '分数值',
    actual_value DECIMAL(10,2) COMMENT '实际值',
    description STRING COMMENT '描述',
    indicator_order INT COMMENT '指标顺序'
)
STORED AS ORC;



INSERT OVERWRITE TABLE exact_market_scoreboard
SELECT * FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY indicator_order) as id,
        indicator_name,
        ROUND(score_value, 0) as score_value,
        ROUND(actual_value, 2) as actual_value,
        description,
        indicator_order
    FROM (
        -- 指标1: 市场可负担性
        SELECT 
            1 as indicator_order,
            '市场可负担性' as indicator_name,
            CASE 
                WHEN AVG(med_house_val / med_inc) <= 4 THEN 85
                WHEN AVG(med_house_val / med_inc) <= 6 THEN 65
                ELSE 45
            END as score_value,
            AVG(med_house_val / med_inc) as actual_value,
            '房价收入比' as description
        FROM housing_info
        WHERE med_inc > 0
        
        UNION ALL
        
        -- 指标2: 房屋新旧程度
        SELECT 
            2 as indicator_order,
            '房屋新旧程度' as indicator_name,
            CASE 
                WHEN AVG(house_age) <= 20 THEN 90
                WHEN AVG(house_age) <= 35 THEN 70
                ELSE 50
            END as score_value,
            AVG(house_age) as actual_value,
            '平均房龄(年)' as description
        FROM housing_info
        WHERE house_age IS NOT NULL
        
        UNION ALL
        
        -- 指标3: 居住空间舒适度
        SELECT 
            3 as indicator_order,
            '居住空间舒适度' as indicator_name,
            CASE 
                WHEN AVG(ave_rooms) >= 5 THEN 95
                WHEN AVG(ave_rooms) >= 4 THEN 75
                ELSE 55
            END as score_value,
            AVG(ave_rooms) as actual_value,
            '每户平均房间数' as description
        FROM housing_info
        WHERE ave_rooms IS NOT NULL
    ) indicators
    
    UNION ALL
    
    -- 综合评分
    SELECT 
        4 as id,
        '综合评分' as indicator_name,
        ROUND(AVG(score_value), 0) as score_value,
        NULL as actual_value,
        '三项指标平均分' as description,
        4 as indicator_order
    FROM (
        SELECT 
            CASE 
                WHEN AVG(med_house_val / med_inc) <= 4 THEN 85
                WHEN AVG(med_house_val / med_inc) <= 6 THEN 65
                ELSE 45
            END as score_value
        FROM housing_info
        WHERE med_inc > 0
        
        UNION ALL
        
        SELECT 
            CASE 
                WHEN AVG(house_age) <= 20 THEN 90
                WHEN AVG(house_age) <= 35 THEN 70
                ELSE 50
            END as score_value
        FROM housing_info
        WHERE house_age IS NOT NULL
        
        UNION ALL
        
        SELECT 
            CASE 
                WHEN AVG(ave_rooms) >= 5 THEN 95
                WHEN AVG(ave_rooms) >= 4 THEN 75
                ELSE 55
            END as score_value
        FROM housing_info
        WHERE ave_rooms IS NOT NULL
    ) scores
) combined
ORDER BY indicator_order;




-- 9. 创建latitude_zone_comparison表
DROP TABLE IF EXISTS latitude_zone_comparison;
CREATE TABLE latitude_zone_comparison (
    latitude_group STRING COMMENT '纬度带',
    min_latitude DECIMAL(5,1) COMMENT '最小纬度',
    max_latitude DECIMAL(5,1) COMMENT '最大纬度',
    region_count INT COMMENT '区域数量',
    avg_house_age DECIMAL(5,1) COMMENT '平均房龄',
    avg_rooms DECIMAL(5,1) COMMENT '平均房间数',
    avg_population DECIMAL(12,0) COMMENT '平均人口',
    avg_occupancy DECIMAL(5,1) COMMENT '平均居住人数',
    avg_latitude DECIMAL(7,3) COMMENT '平均纬度',
    zone_order INT COMMENT '区域顺序',
    avg_house_value DECIMAL(12,0) COMMENT '平均房价',
    avg_income DECIMAL(10,0) COMMENT '平均收入',
    avg_bedrooms DECIMAL(5,1) COMMENT '平均卧室数'
)
COMMENT '纬度带房屋特征对比分析表'
STORED AS ORC;



INSERT OVERWRITE TABLE latitude_zone_comparison
SELECT 
    latitude_group,
    CASE latitude_group
        WHEN '北加州' THEN 38.0
        WHEN '中加州' THEN 36.0
        WHEN '南加州北部' THEN 34.0
        ELSE 0.0
    END as min_latitude,
    CASE latitude_group
        WHEN '北加州' THEN NULL
        WHEN '中加州' THEN 38.0
        WHEN '南加州北部' THEN 36.0
        ELSE 34.0
    END as max_latitude,
    COUNT(*) as region_count,
    ROUND(AVG(house_age), 1) as avg_house_age,
    ROUND(AVG(ave_rooms), 1) as avg_rooms,
    ROUND(AVG(population), 0) as avg_population,
    ROUND(AVG(ave_occup), 1) as avg_occupancy,
    ROUND(AVG(latitude), 3) as avg_latitude,
    CASE latitude_group
        WHEN '北加州' THEN 1
        WHEN '中加州' THEN 2
        WHEN '南加州北部' THEN 3
        ELSE 4
    END as zone_order,
    ROUND(AVG(med_house_val), 0) as avg_house_value,
    ROUND(AVG(med_inc), 0) as avg_income,
    ROUND(AVG(ave_bedrms), 1) as avg_bedrooms
FROM (
    SELECT 
        hi.*,
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



-- 10. 创建house_value_zones表
DROP TABLE IF EXISTS house_value_zones;
CREATE TABLE house_value_zones (
    high_value BIGINT COMMENT '高价值房屋数',
    mid_value BIGINT COMMENT '中价值房屋数',
    low_value BIGINT COMMENT '低价值房屋数'
)
STORED AS ORC;



INSERT OVERWRITE TABLE house_value_zones
SELECT
    SUM(CASE WHEN med_house_val >= 4 THEN 1 ELSE 0 END) AS high_value,
    SUM(CASE WHEN med_house_val BETWEEN 2 AND 3 THEN 1 ELSE 0 END) AS mid_value,
    SUM(CASE WHEN med_house_val BETWEEN 0 AND 1 THEN 1 ELSE 0 END) AS low_value
FROM housing_info
WHERE med_house_val IS NOT NULL;

