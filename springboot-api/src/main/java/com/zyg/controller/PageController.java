package com.zyg.controller;


import com.zyg.pojo.JobInfo;
import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import com.zyg.service.JobInfoService;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/page")
public class PageController {
    @Autowired
    private JobInfoService jobInfoService;

    @RequestMapping("/toIndex")
    public String toIndexPage(){
        System.out.println(123456);
        return "index";
    }
    @RequestMapping("/toLogin")
    public String toLogin(){
        System.out.println(123456);
        return "login";
    }

    @RequestMapping("/api/houseTop10")
    @ResponseBody
    public List<JobInfo> getHouseTop10Data() {return jobInfoService.getHouseTop10Data();}

    @RequestMapping("/api/houseValue")
    @ResponseBody
    public JobInfo getHouseValue() {
        return jobInfoService.getHouseValueData();
    }

    @RequestMapping("/api/houseBurden")
    @ResponseBody
    public List<JobInfo> getHouseBurden() {return jobInfoService.getBurdenData();}

    @RequestMapping("/api/houseAge")
    @ResponseBody
    public List<JobInfo> getHouseAgeData() {return jobInfoService.getHouseAgeData();}

    @RequestMapping("/api/marketScore")
    @ResponseBody
    public List<JobInfo> getMarketScoreData() {return jobInfoService.getMarketScoreData();}

    @RequestMapping("/api/latitudePrice")
    @ResponseBody
    public List<JobInfo> getLatitudePriceData() {return jobInfoService.getLatitudePriceData();}

    @RequestMapping("/api/latitudeFeature")
    @ResponseBody
    public List<JobInfo> getLatitudeFeatureData() {return jobInfoService.getLatitudeFeatureData();}

    @RequestMapping("/api/ageValue")
    @ResponseBody
    public List<JobInfo> getAgeValueData() {return jobInfoService.getAgeValueData();}

    @RequestMapping("/api/roomPrice")
    @ResponseBody
    public List<JobInfo> getRoomPriceData() {return jobInfoService.getRoomPriceData();}

    @RequestMapping("/api/countyIncome")
    @ResponseBody
    public List<JobInfo> getCountyIncomeData() {return jobInfoService.getCountyIncomeData();}

    @RequestMapping("/api/populationSize")
    @ResponseBody
    public List<JobInfo> getPopulationSizeData() {return jobInfoService.getPopulationSizeData();}

    @RequestMapping("/api/investRecommend")
    @ResponseBody
    public List<JobInfo> getInvestRecommendData() {return jobInfoService.getInvestRecommendData();}
}
