package com.zyg.util;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import javax.sql.DataSource;

/**
 * @author cxiaoy
 * @Date 2024/12/31 9:17
 */
public class JdbcUtil {

    //准备一个数据库连接池
    private static DataSource dataSource;

    //首次加载jdbcUtil类时，就会生成这个数据库连接池
    static {
        dataSource = new ComboPooledDataSource("test1");
    }

    //获取数据库连接池
    public static DataSource getDataSource(){
        return dataSource;
    }
}
