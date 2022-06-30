package com.github.xiaoyao9184;

import io.confluent.kafka.schemaregistry.avro.AvroSchema;
import io.confluent.kafka.schemaregistry.client.SchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.rest.exceptions.RestClientException;
import io.confluent.kafka.schemaregistry.testutil.MockSchemaRegistry;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;
import org.apache.avro.generic.GenericData;
import org.apache.kafka.common.errors.SerializationException;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class AvroPayloadConverter {

    private SchemaRegistryClient schemaRegistry = null;
    private String schemaRegistryUrl;
    private Map<String, Object> config;
    private KafkaAvroDeserializer deserializerKey;
    private KafkaAvroDeserializer deserializerMsg;

    public AvroPayloadConverter(String schemaRegistryUrl) {

        String mockScope = MockSchemaRegistry.validateAndMaybeGetMockScope(
                Collections.singletonList(schemaRegistryUrl));
        if (mockScope != null) {
            this.schemaRegistry = MockSchemaRegistry.getClientForScope(mockScope);
        }

        this.schemaRegistryUrl = schemaRegistryUrl;
        this.config = new HashMap<>();
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

    public String toConnectJson(byte[] payload, boolean isKey, AvroSchema schema){
        try {
            registerIfNeed(payload,schema);

            KafkaAvroDeserializer deserializer = isKey ? this.deserializerKey : this.deserializerMsg;
            Object obj = deserializer.deserialize("",payload);

            return GenericData.get().toString(obj);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
