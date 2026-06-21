package com.zyg.service.impl;


import com.zyg.mapper.JobInfoMapper;
import com.zyg.pojo.JobInfo;
import com.zyg.service.JobInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class JobInfoServiceImpl implements JobInfoService {
    @Autowired
    private JobInfoMapper jobInfoMapper;
    @Override
    public List<JobInfo> getHouseTop10Data() {return jobInfoMapper.getHouseTop10Data();}
    @Override
    public JobInfo getHouseValueData() {
        return jobInfoMapper.getHouseValueData();
    }

    @Override
    public List<JobInfo> getBurdenData() {return jobInfoMapper.getBurdenData();}

    @Override
    public List<JobInfo> getHouseAgeData() {return jobInfoMapper.getHouseAgeData();}

    @Override
    public List<JobInfo> getMarketScoreData() {return jobInfoMapper.getMarketScoreData();}

    @Override
    public List<JobInfo> getLatitudePriceData() {return jobInfoMapper.getLatitudePriceData();}

    @Override
    public List<JobInfo> getLatitudeFeatureData() {return jobInfoMapper.getLatitudeFeatureData();}

    @Override
    public List<JobInfo> getAgeValueData() {return jobInfoMapper.getAgeValueData();}

    @Override
    public List<JobInfo> getRoomPriceData() {return jobInfoMapper.getRoomPriceData();}

    @Override
    public List<JobInfo> getCountyIncomeData() {return jobInfoMapper.getCountyIncomeData();}

    @Override
    public List<JobInfo> getPopulationSizeData() {return jobInfoMapper.getPopulationSizeData();}

    @Override
    public List<JobInfo> getInvestRecommendData() {return jobInfoMapper.getInvestRecommendData();}
}