package com.github.xiaoyao9184;

import io.confluent.kafka.schemaregistry.avro.AvroSchema;
import io.confluent.kafka.schemaregistry.avro.AvroSchemaUtils;
import io.confluent.kafka.schemaregistry.client.SchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.rest.exceptions.RestClientException;
import io.confluent.kafka.schemaregistry.testutil.MockSchemaRegistry;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;
import org.apache.avro.Schema;
import org.apache.avro.generic.GenericData;
import org.apache.kafka.common.errors.SerializationException;
import scala.Tuple2;

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

    public Object toObject(boolean isKey, byte[] payload) {
        if (payload == null) {
            return null;
        }
        KafkaAvroDeserializer deserializer = isKey ? this.deserializerKey : this.deserializerMsg;
        return deserializer.deserialize("",payload);
    }

    public String toConnectJson(boolean isKey, byte[] payload) {
        if (payload == null) {
            return null;
        }
        try {
            Object obj = this.toObject(isKey, payload);

            return GenericData.get().toString(obj);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public String toConnectJson(boolean isKey, byte[] payload, AvroSchema schema) {
        if (payload == null) {
            return null;
        }
        if (schema == null) {
            return this.toConnectJson(isKey, payload);
        }
        try {
            registerIfNeed(payload,schema);

            return this.toConnectJson(isKey, payload);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public String toConnectJson(boolean isKey, byte[] payload, String schema) {
        if (payload == null) {
            return null;
        }
        if (schema == null) {
            return this.toConnectJson(isKey, payload);
        }
        AvroSchema avroSchema = new AvroSchema(schema);
        return this.toConnectJson(isKey, payload, avroSchema);
    }

    public Tuple2<String,AvroSchema> toConnectJsonWithSchema(boolean isKey, byte[] payload) {
        if (payload == null) {
            return null;
        }
        Object obj = this.toObject(isKey, payload);

        Schema schemaAvro = AvroSchemaUtils.getSchema(obj);
        AvroSchema avroSchema = new AvroSchema(schemaAvro);

        String payloadJson = GenericData.get().toString(obj);

        return Tuple2.apply(payloadJson,avroSchema);
    }

    public static AvroSchema getAvroSchema(Object obj) {
        Schema schemaAvro = AvroSchemaUtils.getSchema(obj);
        return new AvroSchema(schemaAvro);
    }

    public static String getPayloadJson(Object obj) {
        return GenericData.get().toString(obj);
    }

}
