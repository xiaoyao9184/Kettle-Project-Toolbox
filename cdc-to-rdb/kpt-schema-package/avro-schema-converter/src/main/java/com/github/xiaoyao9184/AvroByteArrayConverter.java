package com.github.xiaoyao9184;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.confluent.connect.avro.AvroData;
import io.confluent.kafka.schemaregistry.SchemaProvider;
import io.confluent.kafka.schemaregistry.avro.AvroSchema;
import io.confluent.kafka.schemaregistry.avro.AvroSchemaUtils;
import io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.SchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.rest.exceptions.RestClientException;
import io.confluent.kafka.schemaregistry.json.jackson.Jackson;
import io.confluent.kafka.schemaregistry.testutil.MockSchemaRegistry;
import io.confluent.kafka.serializers.KafkaAvroDecoder;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;
import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.json.JsonConverter;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.*;
import java.util.stream.Stream;

public class AvroByteArrayConverter {

    private SchemaRegistryClient schemaRegistry = null;
    private String schemaRegistryUrl = null;
    private Map<String, Object> config = null;
    private KafkaAvroDeserializer deserializerKey = null;
    private KafkaAvroDeserializer deserializerMsg = null;

    public AvroByteArrayConverter(String schemaRegistryUrl) {

        String mockScope = MockSchemaRegistry.validateAndMaybeGetMockScope(
                Collections.singletonList(schemaRegistryUrl));
        if (mockScope != null) {
            this.schemaRegistry = MockSchemaRegistry.getClientForScope(mockScope);
        }

        this.schemaRegistryUrl = schemaRegistryUrl;
        this.config = new HashMap<String, Object>();
        this.config.put("schema.registry.url",schemaRegistryUrl);

        this.deserializerKey = new KafkaAvroDeserializer(this.schemaRegistry);
        this.deserializerKey.configure(config,true);

        this.deserializerMsg = new KafkaAvroDeserializer(this.schemaRegistry);
        this.deserializerMsg.configure(config,false);
    }

    public void registerIfNeed(byte[] payload, AvroSchema schema) throws RestClientException, IOException {
        if(schema == null && this.schemaRegistry == null) {
            return;
        }

        ByteBuffer buffer = ByteBuffer.wrap(payload);
        if (buffer.get() != 0) {
            throw new SerializationException("Unknown magic byte!");
        }
        int schemaId = buffer.getInt();
        this.schemaRegistry.register(":.:",schema,0,schemaId);
    }

    public String toConnectData(byte[] payload, boolean isKey, AvroSchema schema){
        try {
            registerIfNeed(payload,schema);

            KafkaAvroDeserializer deserializer = isKey ? this.deserializerKey : this.deserializerMsg;
            Object obj = deserializer.deserialize("",payload);
            byte[] bytes = AvroSchemaUtils.toJson(obj);
            String json = new String(bytes);
            return json;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


}
