package com.zyg.pojo;



public class JobInfo {
    private Integer ranking;          // 排名
    private Integer regionId;         // 区域ID
    private Double houseValue;        // 房屋价值
    private Double medianIncome;      // 居民收入中位数
    private Integer avgHouseAge;      // 房屋平均年龄

    private Integer highValue;   // 高价值区数量
    private Integer midValue;    // 中价值区数量
    private Integer lowValue;    // 低价值区数量

    private String level;       //负担等级
    private Integer count;      //区域数

    private String ageLevel;       // 房屋年龄分段
    private Integer regionCount;   // 区域数
    private Integer levelOrder;    // 排序序号

    private String indicatorName;   // 指标名称
    private Integer score;          // 评分
    private Double actualValue;     // 实际值
    private String desc;            // 指标描述
    private Integer indicatorOrder; // 排序序号

    private String latitudeZone;    // 纬度区域
    private Double avgHouseValue;   // 平均房屋价值
    private Double avgIncome;       // 平均居民收入

    private String latitudeGroup;   // 纬度带
    private Double avgHouseAgee;     // 平均房龄
    private Double avgRooms;        // 平均房间数
    private Double avgOccupancy;    // 平均居住人数

    private String ageRange;        // 房龄区间
    private Double avgHouseValuee;   // 平均房屋价值
    private Double avgIncomee;       // 平均居民收入
    private Double avgRoomss;        // 每户平均房间数

    private String roomSize;        // 户型名称
    private Double avgHousePrice;   // 平均房价
    private Double avgIncomeee;       // 平均收入
    private Integer regionCountt;    // 区域数量

    private String englishName;  // 县英文名称
    private Double price;        // 平均收入

    private String populationSize;// 对应规模的区域数量
    private Integer regionCounttt;// 对应规模的区域数量

    private String regionIdd;          // 区域ID
    private Double currentHouseValue; // 当前房屋价值
    private Double residentIncome;    // 居民收入
    private Integer houseAge;         // 房屋年龄
    private Double investmentScore;   // 投资评分
    private String geographicArea;    // 地理区域
    //房屋价值TOP10
    public Integer getRanking() {return ranking;}
    public void setRanking(Integer ranking) {this.ranking = ranking;}
    public Integer getRegionId() {return regionId;}
    public void setRegionId(Integer regionId) {this.regionId = regionId;}
    public Double getHouseValue() {return houseValue;}
    public void setHouseValue(Double houseValue) {this.houseValue = houseValue;}
    public Double getMedianIncome() {return medianIncome;}
    public void setMedianIncome(Double medianIncome) {this.medianIncome = medianIncome;}
    public Integer getAvgHouseAge() {return avgHouseAge;}
    public void setAvgHouseAge(Integer avgHouseAge) {this.avgHouseAge = avgHouseAge;}

    //房屋价值TOP10 右侧区域
    public Integer getHighValue() { return highValue; }
    public void setHighValue(Integer highValue) { this.highValue = highValue; }
    public Integer getMidValue() {return midValue;}
    public void setMidValue(Integer midValue) {this.midValue = midValue;}
    public Integer getLowValue() {return lowValue;}
    public void setLowValue(Integer lowValue) {this.lowValue = lowValue;}

    //房价收入比分布
    public String getLevel() {return level;}
    public void setLevel(String level) {this.level = level;}
    public Integer getCount() {return count;}
    public void setCount(Integer count) {this.count = count;}

    //房屋年龄分布
    public String getAgeLevel() {return ageLevel;}
    public void setAgeLevel(String ageLevel) {this.ageLevel = ageLevel;}
    public Integer getRegionCount() {return regionCount;}
    public void setRegionCount(Integer regionCount) {this.regionCount = regionCount;}
    public Integer getLevelOrder() {return levelOrder;}
    public void setLevelOrder(Integer levelOrder) {this.levelOrder = levelOrder;}

    //房屋市场综合评分仪表盘
    public String getIndicatorName() {return indicatorName;}
    public void setIndicatorName(String indicatorName) {this.indicatorName = indicatorName;}
    public Integer getScore() {return score;}
    public void setScore(Integer score) {this.score = score;}
    public Double getActualValue() {return actualValue;}
    public void setActualValue(Double actualValue) {this.actualValue = actualValue;}
    public String getDesc() {return desc;}
    public void setDesc(String desc) {this.desc = desc;}
    public Integer getIndicatorOrder() {return indicatorOrder;}
    public void setIndicatorOrder(Integer indicatorOrder) {this.indicatorOrder = indicatorOrder;}

    //海拔与房价关系
    public String getLatitudeZone() {return latitudeZone;}
    public void setLatitudeZone(String latitudeZone) {this.latitudeZone = latitudeZone;}
    public Double getAvgHouseValue() {return avgHouseValue;}
    public void setAvgHouseValue(Double avgHouseValue) {this.avgHouseValue = avgHouseValue;}
    public Double getAvgIncome() {return avgIncome;}
    public void setAvgIncome(Double avgIncome) {this.avgIncome = avgIncome;}

    //各纬度带房屋特征对比分析
    public String getLatitudeGroup() {return latitudeGroup;}
    public void setLatitudeGroup(String latitudeGroup) {this.latitudeGroup = latitudeGroup;}
    public Double getAvgHouseAgee() {return avgHouseAgee;}
    public void setAvgHouseAgee(Double avgHouseAgee) {this.avgHouseAgee = avgHouseAgee;}
    public Double getAvgRooms() {return avgRooms;}
    public void setAvgRooms(Double avgRooms) {this.avgRooms = avgRooms;}
    public Double getAvgOccupancy() {return avgOccupancy;}
    public void setAvgOccupancy(Double avgOccupancy) {this.avgOccupancy = avgOccupancy;}

    //房龄-价值衰减曲线
    public String getAgeRange() {return ageRange;}
    public void setAgeRange(String ageRange) {this.ageRange = ageRange;}
    public Double getAvgHouseValuee() {return avgHouseValuee;}
    public void setAvgHouseValuee(Double avgHouseValuee) {this.avgHouseValuee = avgHouseValuee;}
    public Double getAvgIncomee() {return avgIncomee;}
    public void setAvgIncomee(Double avgIncomee) {this.avgIncomee = avgIncomee;}
    public Double getAvgRoomss() {return avgRoomss;}
    public void setAvgRoomss(Double avgRoomss) {this.avgRoomss = avgRoomss;}

    //每户平均房间数与房价关系趋势
    public String getRoomSize() {return roomSize;}
    public void setRoomSize(String roomSize) {this.roomSize = roomSize;}
    public Double getAvgHousePrice() {return avgHousePrice;}
    public void setAvgHousePrice(Double avgHousePrice) {this.avgHousePrice = avgHousePrice;}
    public Double getAvgIncomeee() {return avgIncomeee;}
    public void setAvgIncomeee(Double avgIncomeee) {this.avgIncomeee = avgIncomeee;}
    public Integer getRegionCountt() {return regionCountt;}
    public void setRegionCountt(Integer regionCountt) {this.regionCountt = regionCountt;}

    //加州各县房价
    public String getEnglishName() {return englishName;}
    public void setEnglishName(String englishName) {this.englishName = englishName;}
    public Double getPrice() {return price;}
    public void setPrice(Double price) {this.price = price;}

    //区域人口规模分级
    public String getPopulationSize() {return populationSize;}
    public void setPopulationSize(String populationSize) {this.populationSize = populationSize;}
    public Integer getRegionCounttt() {return regionCounttt;}
    public void setRegionCounttt(Integer regionCounttt) {this.regionCounttt = regionCounttt;}

    //高价值投资推荐区域
    public String getRegionIdd() {return regionIdd;}
    public void setRegionIdd(String regionIdd) {this.regionIdd = regionIdd;}
    public Double getCurrentHouseValue() {return currentHouseValue;}
    public void setCurrentHouseValue(Double currentHouseValue) {this.currentHouseValue = currentHouseValue;}
    public Double getResidentIncome() {return residentIncome;}
    public void setResidentIncome(Double residentIncome) {this.residentIncome = residentIncome;}
    public Integer getHouseAge() {return houseAge;}
    public void setHouseAge(Integer houseAge) {this.houseAge = houseAge;}
    public Double getInvestmentScore() {return investmentScore;}
    public void setInvestmentScore(Double investmentScore) {this.investmentScore = investmentScore;}
    public String getGeographicArea() {return geographicArea;}
    public void setGeographicArea(String geographicArea) {this.geographicArea = geographicArea;}
}
