package com.zyg.mapper;
import com.zyg.pojo.JobInfo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public  interface JobInfoMapper {
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
