package com.github.xiaoyao9184;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.confluent.connect.avro.AvroData;
import io.confluent.kafka.schemaregistry.avro.AvroSchema;
import io.confluent.kafka.schemaregistry.json.jackson.Jackson;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.json.JsonConverter;

import java.util.HashMap;
import java.util.Map;

public class AvroSchemaConverter {

    public static String toConnect(String schema) {
        AvroSchema avroSchema = new AvroSchema(schema);
        AvroData avroData = new AvroData(10);
        Schema actual = avroData.toConnectSchema(avroSchema.rawSchema());

        JsonConverter jsonConverter = new JsonConverter();
        Map<String, Object> config = new HashMap<String, Object>();
        config.put("schemas.enable", Boolean.TRUE.toString());
        config.put("schemas.cache.size", String.valueOf(100));
        jsonConverter.configure(config,true);
        ObjectNode jsonNodes = jsonConverter.asJsonSchema(actual);

        ObjectMapper objectMapper = Jackson.newObjectMapper();
        String canonicalString = null;
        try {
            canonicalString = objectMapper.writeValueAsString(jsonNodes);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        return canonicalString;
    }
}
