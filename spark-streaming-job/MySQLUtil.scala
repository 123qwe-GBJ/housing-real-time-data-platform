package c2

import java.sql.{Connection, DriverManager, PreparedStatement, ResultSet}

object MySQLUtil {
  // MySQL连接配置（保持你的配置）
  private val url = "jdbc:mysql://localhost:3306/housing_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai"
  private val username = "root"
  private val password = "123456"
  private val driver = "com.mysql.cj.jdbc.Driver"

  // 连接池配置
  private val connectionPool = new java.util.concurrent.LinkedBlockingQueue[Connection](10)

  // 初始化连接池
  try {
    Class.forName(driver)
    for (i <- 1 to 5) {
      connectionPool.put(createConnection())
    }
    println("MySQL连接池初始化成功，连接数：5")
  } catch {
    case e: Exception =>
      println(s"MySQL连接池初始化失败: ${e.getMessage}")
      e.printStackTrace()
  }

  // 创建新连接
  private def createConnection(): Connection = {
    DriverManager.getConnection(url, username, password)
  }

  // 获取连接
  def getConnection(): Connection = {
    if (connectionPool.isEmpty) {
      createConnection()
    } else {
      connectionPool.take()
    }
  }

  // 归还连接
  def returnConnection(conn: Connection): Unit = {
    if (conn != null && !conn.isClosed) {
      connectionPool.put(conn)
    }
  }

  // 关闭连接池
  def closePool(): Unit = {
    while (!connectionPool.isEmpty) {
      try {
        val conn = connectionPool.take()
        if (conn != null && !conn.isClosed) {
          conn.close()
        }
      } catch {
        case e: Exception => e.printStackTrace()
      }
    }
  }
  // 补充：查询最新插入的数据（适配自增id）
  def queryHousingData(limit: Int = 10): List[Map[String, Any]] = {
    var connection: Connection = null
    var pstmt: PreparedStatement = null
    var rs: ResultSet = null

    // 查询自增id和核心业务字段，验证插入结果
    val querySQL = "SELECT id, med_inc, med_house_val FROM ods_housing_info ORDER BY id DESC LIMIT ?"

    try {
      connection = getConnection()
      pstmt = connection.prepareStatement(querySQL)
      pstmt.setInt(1, limit)
      rs = pstmt.executeQuery()

      val result = scala.collection.mutable.ListBuffer[Map[String, Any]]()
      while (rs.next()) {
        val row = Map(
          "id" -> rs.getInt("id"),
          "med_inc" -> rs.getDouble("med_inc"),
          "med_house_val" -> rs.getDouble("med_house_val")
        )
        result += row
      }

      result.toList
    } catch {
      case e: Exception =>
        println(s"查询数据失败: ${e.getMessage}")
        List.empty
    } finally {
      if (rs != null) rs.close()
      if (pstmt != null) pstmt.close()
      if (connection != null) returnConnection(connection)
    }
  }
  // 批量插入数据（适配数据库id自增，移除id字段）
  def batchInsertHousingData(data: List[Map[String, Any]]): Unit = {
    var connection: Connection = null
    var pstmt: PreparedStatement = null

    // 核心修改2：移除INSERT字段列表中的id字段，数据库自动生成自增id
    val insertSQL = """
    INSERT IGNORE INTO ods_housing_info (
      med_inc, house_age, ave_rooms, ave_bedrms,
      population, ave_occup, latitude, longitude, med_house_val
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  """

    try {
      connection = getConnection()
      connection.setAutoCommit(false)
      pstmt = connection.prepareStatement(insertSQL)

      data.foreach { record =>
        // 核心修改3：移除id对应的参数绑定，后续参数索引对应调整
        pstmt.setDouble(1, record.getOrElse("med_inc", 0.0).asInstanceOf[Double])
        pstmt.setDouble(2, record.getOrElse("house_age", 0.0).asInstanceOf[Double])
        pstmt.setDouble(3, record.getOrElse("ave_rooms", 0.0).asInstanceOf[Double])
        pstmt.setDouble(4, record.getOrElse("ave_bedrms", 0.0).asInstanceOf[Double])
        pstmt.setDouble(5, record.getOrElse("population", 0.0).asInstanceOf[Double])
        pstmt.setDouble(6, record.getOrElse("ave_occup", 0.0).asInstanceOf[Double])
        pstmt.setDouble(7, record.getOrElse("latitude", 0.0).asInstanceOf[Double])
        pstmt.setDouble(8, record.getOrElse("longitude", 0.0).asInstanceOf[Double])
        pstmt.setDouble(9, record.getOrElse("med_house_val", 0.0).asInstanceOf[Double])

        pstmt.addBatch()
      }

      val result = pstmt.executeBatch()
      connection.commit()

      // 统计实际插入成功的条数（排除被忽略的重复数据）
      val insertedCount = result.count(_ > 0)
      println(s"成功插入 ${insertedCount} 条数据（忽略 ${data.size - insertedCount} 条重复数据）")

    } catch {
      case e: Exception =>
        if (connection != null) {
          connection.rollback()
        }
        println(s"批量插入数据失败: ${e.getMessage}")
        e.printStackTrace()
    } finally {
      if (pstmt != null) pstmt.close()
      if (connection != null) returnConnection(connection)
    }
  }
}