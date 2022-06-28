package com.github.xiaoyao9184;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.confluent.connect.json.JsonSchemaData;
import io.confluent.kafka.schemaregistry.json.JsonSchema;
import io.confluent.kafka.schemaregistry.json.jackson.Jackson;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.json.JsonConverter;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;

public class JsonSchemaConverterTest {

    @Test
    public void toConnect() throws JsonProcessingException {
        String schema = "{\n" +
                "             \"type\":\"object\",\n" +
                "             \"title\":\"test_debezium_mysql_test_kpt_cdc_json.data_changes.Key\",\n" +
                "             \"properties\":{\n" +
                "                \"databaseName\":{\n" +
                "                   \"type\":\"string\",\n" +
                "                   \"connect.index\":0\n" +
                "                },\n" +
                "                \"__dbz__physicalTableIdentifier\":{\n" +
                "                   \"type\":\"string\",\n" +
                "                   \"connect.index\":1\n" +
                "                }\n" +
                "             }\n" +
                "          }";

        JsonSchema jsonSchema = new JsonSchema(schema);
        JsonSchemaData jsonSchemaData = new JsonSchemaData();
        Schema actual = jsonSchemaData.toConnectSchema(jsonSchema);

        JsonConverter jsonConverter = new JsonConverter();
        Map<String, Object> config = new HashMap<>();
        config.put("schemas.enable", Boolean.TRUE.toString());
        config.put("schemas.cache.size", String.valueOf(100));
        jsonConverter.configure(config,true);
        ObjectNode jsonNodes = jsonConverter.asJsonSchema(actual);

        ObjectMapper objectMapper = Jackson.newObjectMapper();
        String canonicalString = objectMapper.writeValueAsString(jsonNodes);
    }
}