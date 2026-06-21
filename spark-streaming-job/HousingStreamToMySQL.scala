package c2

import org.apache.spark.SparkConf
import org.apache.spark.streaming._
import org.apache.spark.streaming.kafka010._
import org.apache.kafka.common.serialization.StringDeserializer
import com.alibaba.fastjson.JSON

object HousingStreamToMySQL {
  def main(args: Array[String]): Unit = {
    println("=== 房屋数据实时处理并存储到MySQL ===")
    val conf = new SparkConf()
      .setAppName("HousingStreamToMySQL")
      .setMaster("local[2]")
      .set("spark.streaming.stopGracefullyOnShutdown", "true")
      .set("spark.local.dir", "C:/tmp/spark-local")
    val ssc = new StreamingContext(conf, Seconds(10))
    ssc.sparkContext.setLogLevel("WARN")
    println("Spark StreamingContext 创建成功")
    val kafkaParams = Map[String, Object](
      "bootstrap.servers" -> "192.168.17.150:9092",
      "key.deserializer" -> classOf[StringDeserializer],
      "value.deserializer" -> classOf[StringDeserializer],
      "group.id" -> "housing-mysql-group",
      "auto.offset.reset" -> "latest",
      "enable.auto.commit" -> (false: java.lang.Boolean)
    )

    val topics = Array("housing-topic")

    println(s"连接到Kafka: 192.168.17.150:9092, topic: housing-topic")
    val stream = KafkaUtils.createDirectStream[String, String](
      ssc,
      LocationStrategies.PreferConsistent,
      ConsumerStrategies.Subscribe[String, String](topics, kafkaParams)
    )
    stream.foreachRDD { rdd =>
      if (!rdd.isEmpty()) {
        println(s"\n=== 处理批次: ${new java.util.Date()} ===")
        val count = rdd.count()
        println(s"收到 $count 条消息")
        val housingData = rdd.map { record =>
          try {
            val jsonObj = JSON.parseObject(record.value())

            Map[String, Any](
              "id" -> jsonObj.getIntValue("id"),
              "med_inc" -> jsonObj.getDoubleValue("med_inc"),
              "house_age" -> jsonObj.getDoubleValue("house_age"),
              "ave_rooms" -> jsonObj.getDoubleValue("ave_rooms"),
              "ave_bedrms" -> jsonObj.getDoubleValue("ave_bedrms"),
              "population" -> jsonObj.getDoubleValue("population"),
              "ave_occup" -> jsonObj.getDoubleValue("ave_occup"),
              "latitude" -> jsonObj.getDoubleValue("latitude"),
              "longitude" -> jsonObj.getDoubleValue("longitude"),
              "med_house_val" -> jsonObj.getDoubleValue("med_house_val")
            )
          } catch {
            case e: Exception =>
              println(s"解析JSON失败: ${e.getMessage}, 原始数据: ${record.value()}")
              Map.empty[String, Any]
          }
        }.filter(_.nonEmpty)
        if (housingData.count() > 0) {
          val dataList = housingData.collect().toList
          println(s"准备插入 ${dataList.size} 条数据到MySQL...")
          dataList.take(3).foreach { record =>
            println(s"  示例数据: ID=${record("id")}, 房价=${record("med_house_val")}")
          }
          MySQLUtil.batchInsertHousingData(dataList)
          println(s"数据插入完成")
        } else {
          println("没有有效数据需要处理")
        }
        val latestData = MySQLUtil.queryHousingData(3)
        if (latestData.nonEmpty) {
          println("MySQL中最新的3条数据:")
          latestData.foreach { row =>
            println(s"  ID=${row("id")}, 房价=${row("med_house_val")}")
          }
        }
      } else {
        println("当前批次没有数据")
      }
    }
    println("启动流处理，等待数据...")
    ssc.start()
    sys.addShutdownHook {
      println("收到关闭信号，正在关闭...")
      ssc.stop(stopSparkContext = true, stopGracefully = true)
      MySQLUtil.closePool()
    }
    ssc.awaitTermination()
  }
}