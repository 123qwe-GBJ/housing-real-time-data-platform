package c56;

import com.alibaba.fastjson.JSONObject;
import org.apache.kafka.clients.producer.*;

import java.util.Properties;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

public class HousingDataProducer {
    private static final String BOOTSTRAP_SERVERS = "192.168.17.150:9092";
    private static final String TOPIC = "housing-topic";

    private static final AtomicInteger dataCounter = new AtomicInteger(1);
    private static final Random random = new Random();

    public static void main(String[] args) {
        Properties props = new Properties();
        props.put("bootstrap.servers", BOOTSTRAP_SERVERS);
        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("acks", "all");

        try (Producer<String, String> producer = new KafkaProducer<>(props)) {
            while (true) {
                String housingData = generateHousingRecord();
                ProducerRecord<String, String> record =
                        new ProducerRecord<>(TOPIC, String.valueOf(dataCounter.get()), housingData);

                producer.send(record, (metadata, exception) -> {
                    if (exception == null) {
                        System.out.println("Sent housing data: " + housingData);
                    } else {
                        System.out.println("Error: " + exception.getMessage());
                    }
                });

                Thread.sleep(2000);

                if (dataCounter.get() % 10 == 0) {
                    System.out.println("已发送 " + dataCounter.get() + " 条房屋数据");
                    Thread.sleep(5000);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String generateHousingRecord() {
        JSONObject housing = new JSONObject();
        housing.put("med_inc", generateMedInc());
        housing.put("house_age", generateHouseAge());
        housing.put("ave_rooms", generateAveRooms());
        housing.put("ave_bedrms", generateAveBedrms());
        housing.put("population", generatePopulation());
        housing.put("ave_occup", generateAveOccup());
        housing.put("latitude", generateLatitude());
        housing.put("longitude", generateLongitude());
        housing.put("med_house_val", generateHouseValue());
        housing.put("timestamp", System.currentTimeMillis());
        housing.put("price_per_room",
                housing.getDouble("med_house_val") / housing.getDouble("ave_rooms"));
        housing.put("income_to_price_ratio",
                housing.getDouble("med_inc") * 1000 / housing.getDouble("med_house_val"));
        dataCounter.getAndIncrement();
        return housing.toString();
    }
    private static double generateMedInc() {return 1.5 + (random.nextDouble() * 10);}
    private static double generateHouseAge() {return 1 + (random.nextDouble() * 40);}

    private static double generateAveRooms() {return 2 + (random.nextDouble() * 6);}

    private static double generateAveBedrms() {return 1 + (random.nextDouble() * 4);}

    private static int generatePopulation() {return 100 + (random.nextInt(10) * 2000);}

    private static double generateAveOccup() {
        return 2 + (random.nextDouble() * 4);  // 2-6人/户
    }

    private static double generateLatitude() {
        return 32.0 + (random.nextDouble() * 4);  // 32-36度
    }

    private static double generateLongitude() {
        return -124.0 - (random.nextDouble() * 4);  // -124到-128度
    }

    private static double generateHouseValue() {
        return 50000 + (random.nextDouble() * 450000);  // 5万-50万美元
    }
}