package com.github.xiaoyao9184;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.confluent.connect.json.JsonSchemaData;
import io.confluent.connect.json.JsonSchemaDataConfig;
import io.confluent.kafka.schemaregistry.json.JsonSchema;
import io.confluent.kafka.schemaregistry.json.jackson.Jackson;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.json.JsonConverter;

import java.util.HashMap;
import java.util.Map;

public class JsonSchemaConverter {

    private JsonSchemaData jsonSchemaData;

    private Map<String, Object> config;
    private JsonConverter jsonConverterKey;
    private JsonConverter jsonConverterMsg;

    private ObjectMapper objectMapper;

    public JsonSchemaConverter(int cacheSize) {
        JsonSchemaDataConfig dc = new JsonSchemaDataConfig.Builder()
                .with("schemas.cache.size", cacheSize)
                .build();
        this.jsonSchemaData = new JsonSchemaData(dc);

        this.config = new HashMap<String, Object>();
        config.put("schemas.enable", Boolean.TRUE.toString());
        config.put("schemas.cache.size", String.valueOf(cacheSize));

        this.jsonConverterKey = new JsonConverter();
        this.jsonConverterKey.configure(config,true);

        this.jsonConverterMsg = new JsonConverter();
        this.jsonConverterKey.configure(config,false);

        this.objectMapper = Jackson.newObjectMapper();
    }

    public String toConnectJson(String schema, boolean isKey) {
        if(schema == null){
            return null;
        }
        JsonSchema jsonSchema = new JsonSchema(schema);
        Schema actual = this.jsonSchemaData.toConnectSchema(jsonSchema);

        JsonConverter jsonConverter = isKey ? this.jsonConverterKey : this.jsonConverterMsg;
        ObjectNode jsonNodes = jsonConverter.asJsonSchema(actual);

        String canonicalString = null;
        try {
            canonicalString = this.objectMapper.writeValueAsString(jsonNodes);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        return canonicalString;
    }
}
