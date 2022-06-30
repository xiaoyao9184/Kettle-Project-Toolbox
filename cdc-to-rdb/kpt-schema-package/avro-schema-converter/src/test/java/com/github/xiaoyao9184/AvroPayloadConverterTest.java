package com.github.xiaoyao9184;

import io.confluent.kafka.schemaregistry.avro.AvroSchema;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;
import org.apache.kafka.common.errors.SerializationException;
import org.junit.Test;

import java.io.*;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.jayway.jsonpath.matchers.JsonPathMatchers.hasJsonPath;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class AvroPayloadConverterTest {

    public List<Map<String,String>> readTopicCVS(String topic) throws IOException {
        InputStream is = this.getClass().getClassLoader()
                .getResourceAsStream("kafka/topics/" + topic + ".csv");
        Reader in = new InputStreamReader(is);
        Iterable<CSVRecord> records = CSVFormat.DEFAULT.builder()
                .setHeader()
                .setDelimiter(';').build().parse(in);

        List<Map<String,String>> listOfMaps = new ArrayList<>();
        for (CSVRecord record : records) {
            listOfMaps.add(record.toMap());
        }
        return listOfMaps;
    }

    public String readSchemaJson(int schemaId) throws IOException {
        InputStream is = this.getClass().getClassLoader()
                .getResourceAsStream("schema_registry/schemas/ids/" + schemaId + ".json");
        Reader in = new InputStreamReader(is);
        return new BufferedReader(in)
                .lines()
                .collect(Collectors.joining("\n"));
    }

    @Test
    public void testDDL_Key_RealSchemaRegistry() throws IOException {
        Hex hex = new Hex();
        byte[] payload = readTopicCVS("test_debezium_mysql-test_kpt_cdc-avro.data-changes")
                .stream()
                .filter(map -> "0".equals(map.get("kafka_offset")))
                .map(map -> map.get("kafka_key"))
                .findFirst()
                .map(msg -> {
                    try {
                        return hex.decode(msg.getBytes());
                    } catch (DecoderException e) {
                        throw new RuntimeException(e);
                    }
                })
                .get();

        AvroPayloadConverter converter = new AvroPayloadConverter("http://me:58081");
        String json = converter.toConnectJson(payload, false, null);

        assertThat(json, hasJsonPath("$.databaseName"));
        assertThat(json, hasJsonPath("$.__dbz__physicalTableIdentifier"));

        assertThat(json, hasJsonPath("$.databaseName", equalTo("")));
        assertThat(json, hasJsonPath("$.__dbz__physicalTableIdentifier", equalTo("test_debezium_mysql-test_kpt_cdc-avro")));
    }

    @Test
    public void testDDL_Key_MockSchemaRegistry() throws IOException {
        Hex hex = new Hex();
        byte[] payload = readTopicCVS("test_debezium_mysql-test_kpt_cdc-avro.data-changes")
                .stream()
                .filter(map -> "0".equals(map.get("kafka_offset")))
                .map(map -> map.get("kafka_key"))
                .findFirst()
                .map(msg -> {
                    try {
                        return hex.decode(msg.getBytes());
                    } catch (DecoderException e) {
                        throw new RuntimeException(e);
                    }
                })
                .get();
        ByteBuffer buffer = ByteBuffer.wrap(payload);
        if (buffer.get() != 0) {
            throw new SerializationException("Unknown magic byte!");
        }
        int schemaId = buffer.getInt();
        String schema = readSchemaJson(schemaId);
        AvroSchema avroSchema = new AvroSchema(schema);

        AvroPayloadConverter converter = new AvroPayloadConverter("mock://me:58081");
        String json = converter.toConnectJson(payload, false, avroSchema);

        assertThat(json, hasJsonPath("$.databaseName"));
        assertThat(json, hasJsonPath("$.__dbz__physicalTableIdentifier"));

        assertThat(json, hasJsonPath("$.databaseName", equalTo("")));
        assertThat(json, hasJsonPath("$.__dbz__physicalTableIdentifier", equalTo("test_debezium_mysql-test_kpt_cdc-avro")));
    }

    @Test
    public void testDML_Message_RealSchemaRegistry() throws IOException {
        Hex hex = new Hex();
        byte[] payload = readTopicCVS("test_debezium_mysql-test_kpt_cdc-avro.data-changes")
                .stream()
                .filter(map -> "12".equals(map.get("kafka_offset")))
                .map(map -> map.get("kafka_message"))
                .findFirst()
                .map(msg -> {
                    try {
                        return hex.decode(msg.getBytes());
                    } catch (DecoderException e) {
                        throw new RuntimeException(e);
                    }
                })
                .get();

        AvroPayloadConverter converter = new AvroPayloadConverter("http://me:58081");
        String json = converter.toConnectJson(payload,false,null);

        assertThat(json, hasJsonPath("$.before"));
        assertThat(json, hasJsonPath("$.after"));
        assertThat(json, hasJsonPath("$.source"));
        assertThat(json, hasJsonPath("$.op"));
        assertThat(json, hasJsonPath("$.ts_ms"));
        assertThat(json, hasJsonPath("$.transaction"));

        assertThat(json, hasJsonPath("$.before", equalTo(null)));
        assertThat(json, hasJsonPath("$.transaction", equalTo(null)));
        assertThat(json, hasJsonPath("$.op", equalTo("r")));
        assertThat(json, hasJsonPath("$.ts_ms", equalTo(1655947193835L)));

        assertThat(json, hasJsonPath("$.source.table", equalTo("debezium_types")));
        assertThat(json, hasJsonPath("$.after._id", equalTo("0")));
        assertThat(json, hasJsonPath("$.after.BOOLEAN", equalTo(false)));
        assertThat(json, hasJsonPath("$.after.INT", equalTo(8)));
        assertThat(json, hasJsonPath("$.after.DOUBLE", equalTo(13.34)));
        assertThat(json, hasJsonPath("$.after.CHAR", equalTo("14")));
        assertThat(json, hasJsonPath("$.after.TINYBLOB", equalTo("\u0018")));
        assertThat(json, hasJsonPath("$.after.DATE", equalTo(18881)));
        assertThat(json, hasJsonPath("$.after.TIMESTAMP", equalTo("2021-09-11T11:59:00Z")));
        assertThat(json, hasJsonPath("$.after.TIME", equalTo(42660000000L)));
        assertThat(json, hasJsonPath("$.after.DATETIME_3", equalTo(1631318400000L)));
        assertThat(json, hasJsonPath("$.after.NUMERIC", equalTo("z")));
        assertThat(json, hasJsonPath("$.after.GEOMETRY.wkb"));
        assertThat(json, hasJsonPath("$.after.GEOMETRY.wkb", equalTo("\u0001\u0001\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000ð?\u0000\u0000\u0000\u0000\u0000\u0000ð?")));
    }

    @Test
    public void testDML_Message_MockSchemaRegistry() throws IOException {
        Hex hex = new Hex();
        byte[] payload = readTopicCVS("test_debezium_mysql-test_kpt_cdc-avro.data-changes")
                .stream()
                .filter(map -> "12".equals(map.get("kafka_offset")))
                .map(map -> map.get("kafka_message"))
                .findFirst()
                .map(msg -> {
                    try {
                        return hex.decode(msg.getBytes());
                    } catch (DecoderException e) {
                        throw new RuntimeException(e);
                    }
                })
                .get();
        ByteBuffer buffer = ByteBuffer.wrap(payload);
        if (buffer.get() != 0) {
            throw new SerializationException("Unknown magic byte!");
        }
        int schemaId = buffer.getInt();
        String schema = readSchemaJson(schemaId);
        AvroSchema avroSchema = new AvroSchema(schema);

        AvroPayloadConverter converter = new AvroPayloadConverter("mock://me:58081");
        String json = converter.toConnectJson(payload,false,avroSchema);

        assertThat(json, hasJsonPath("$.before"));
        assertThat(json, hasJsonPath("$.after"));
        assertThat(json, hasJsonPath("$.source"));
        assertThat(json, hasJsonPath("$.op"));
        assertThat(json, hasJsonPath("$.ts_ms"));
        assertThat(json, hasJsonPath("$.transaction"));

        assertThat(json, hasJsonPath("$.before", equalTo(null)));
        assertThat(json, hasJsonPath("$.transaction", equalTo(null)));
        assertThat(json, hasJsonPath("$.op", equalTo("r")));
        assertThat(json, hasJsonPath("$.ts_ms", equalTo(1655947193835L)));

        assertThat(json, hasJsonPath("$.source.table", equalTo("debezium_types")));
        assertThat(json, hasJsonPath("$.after._id", equalTo("0")));
        assertThat(json, hasJsonPath("$.after.BOOLEAN", equalTo(false)));
        assertThat(json, hasJsonPath("$.after.INT", equalTo(8)));
        assertThat(json, hasJsonPath("$.after.DOUBLE", equalTo(13.34)));
        assertThat(json, hasJsonPath("$.after.CHAR", equalTo("14")));
        assertThat(json, hasJsonPath("$.after.TINYBLOB", equalTo("\u0018")));
        assertThat(json, hasJsonPath("$.after.DATE", equalTo(18881)));
        assertThat(json, hasJsonPath("$.after.TIMESTAMP", equalTo("2021-09-11T11:59:00Z")));
        assertThat(json, hasJsonPath("$.after.TIME", equalTo(42660000000L)));
        assertThat(json, hasJsonPath("$.after.DATETIME_3", equalTo(1631318400000L)));
        assertThat(json, hasJsonPath("$.after.NUMERIC", equalTo("z")));
        assertThat(json, hasJsonPath("$.after.GEOMETRY.wkb"));
        assertThat(json, hasJsonPath("$.after.GEOMETRY.wkb", equalTo("\u0001\u0001\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000ð?\u0000\u0000\u0000\u0000\u0000\u0000ð?")));
    }
}