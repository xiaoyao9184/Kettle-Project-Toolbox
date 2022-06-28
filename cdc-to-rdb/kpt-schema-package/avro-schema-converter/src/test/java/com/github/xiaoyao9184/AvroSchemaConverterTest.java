package com.github.xiaoyao9184;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.confluent.connect.avro.AvroData;
import io.confluent.connect.avro.AvroDataConfig;
import io.confluent.kafka.schemaregistry.avro.AvroSchema;
import io.confluent.kafka.schemaregistry.avro.AvroSchemaUtils;
import io.confluent.kafka.schemaregistry.json.jackson.Jackson;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.json.JsonConverter;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;


public class AvroSchemaConverterTest {

    @Test
    public void toConnect() throws JsonProcessingException {
        String schema = "{\n" +
                "   \"type\":\"record\",\n" +
                "   \"name\":\"Key\",\n" +
                "   \"namespace\":\"test_debezium_mysql_test_kpt_cdc_avro.data_changes\",\n" +
                "   \"fields\":[\n" +
                "      {\n" +
                "         \"name\":\"databaseName\",\n" +
                "         \"type\":\"string\"\n" +
                "      },\n" +
                "      {\n" +
                "         \"name\":\"__dbz__physicalTableIdentifier\",\n" +
                "         \"type\":\"string\"\n" +
                "      }\n" +
                "   ],\n" +
                "   \"connect.name\":\"test_debezium_mysql_test_kpt_cdc_avro.data_changes.Key\"\n" +
                "}";

//        JsonFea
//        com.fasterxml.jackson.core.util.Jacksonfeature
        org.apache.avro.Schema avroSchema1 = new org.apache.avro.Schema.Parser().parse(schema);

        AvroDataConfig avroDataConfig = new AvroDataConfig.Builder()
                .with(AvroDataConfig.CONNECT_META_DATA_CONFIG, false)
                .build();
        AvroData avroData = new AvroData(avroDataConfig);
        Schema actual = avroData.toConnectSchema(avroSchema1);

        JsonConverter jsonConverter = new JsonConverter();
        Map<String, Object> config = new HashMap<String, Object>();
        config.put("schemas.enable", Boolean.TRUE.toString());
        config.put("schemas.cache.size", String.valueOf(100));
        jsonConverter.configure(config,true);
        ObjectNode jsonNodes = jsonConverter.asJsonSchema(actual);

        ObjectMapper objectMapper = Jackson.newObjectMapper();
        String canonicalString = objectMapper.writeValueAsString(jsonNodes);
    }
}