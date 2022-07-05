package com.github.xiaoyao9184;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.confluent.connect.avro.AvroData;
import io.confluent.connect.avro.AvroDataConfig;
import io.confluent.kafka.schemaregistry.avro.AvroSchema;
import io.confluent.kafka.schemaregistry.json.jackson.Jackson;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.json.JsonConverter;

import java.util.HashMap;
import java.util.Map;

public class AvroSchemaConverter {

    private AvroData avroData;

    private Map<String, Object> config;
    private JsonConverter jsonConverterKey;
    private JsonConverter jsonConverterMsg;

    private ObjectMapper objectMapper;

    public AvroSchemaConverter(int cacheSize) {
        AvroDataConfig dc = new AvroDataConfig.Builder()
                .with("schemas.cache.config", cacheSize)
                .build();
        this.avroData = new AvroData(dc);

        this.config = new HashMap<String, Object>();
        this.config.put("schemas.enable", Boolean.TRUE.toString());
        this.config.put("schemas.cache.size", String.valueOf(cacheSize));

        this.jsonConverterKey = new JsonConverter();
        this.jsonConverterKey.configure(config,true);

        this.jsonConverterMsg = new JsonConverter();
        this.jsonConverterMsg.configure(config,false);

        this.objectMapper = Jackson.newObjectMapper();
    }

    public String toConnectJson(String schema, boolean isKey){
        if (schema == null) {
            return null;
        }
        AvroSchema avroSchema = new AvroSchema(schema);
        return this.toConnectJson(avroSchema,isKey);
    }

    public String toConnectJson(AvroSchema avroSchema, boolean isKey){
        if (avroSchema == null) {
            return null;
        }
        Schema actual = this.avroData.toConnectSchema(avroSchema.rawSchema());

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
