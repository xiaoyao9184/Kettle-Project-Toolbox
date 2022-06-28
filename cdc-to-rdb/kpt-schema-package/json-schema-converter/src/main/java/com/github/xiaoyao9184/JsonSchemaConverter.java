package com.github.xiaoyao9184;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.confluent.connect.json.JsonSchemaData;
import io.confluent.kafka.schemaregistry.json.JsonSchema;
import io.confluent.kafka.schemaregistry.json.jackson.Jackson;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.json.JsonConverter;

import java.util.HashMap;
import java.util.Map;

public class JsonSchemaConverter {

    public static String toConnect(String schema) {
        JsonSchema jsonSchema = new JsonSchema(schema);
        JsonSchemaData jsonSchemaData = new JsonSchemaData();
        Schema actual = jsonSchemaData.toConnectSchema(jsonSchema);

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
