package com.zyg.service;

import com.zyg.pojo.JobInfo;

import java.util.List;

public interface JobInfoService {
    List<JobInfo> getHouseTop10Data();
    JobInfo getHouseValueData();
    List<JobInfo> getBurdenData();
    List<JobInfo> getHouseAgeData();
    List<JobInfo> getMarketScoreData();
    List<JobInfo> getLatitudePriceData();
    List<JobInfo> getLatitudeFeatureData();
    List<JobInfo> getAgeValueData();
    List<JobInfo> getRoomPriceData();
    List<JobInfo> getCountyIncomeData();
    List<JobInfo> getPopulationSizeData();
    List<JobInfo> getInvestRecommendData();
}