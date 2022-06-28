package com.github.xiaoyao9184;

import io.confluent.kafka.schemaregistry.avro.AvroSchema;
import io.confluent.kafka.schemaregistry.avro.AvroSchemaUtils;
import io.confluent.kafka.schemaregistry.client.rest.exceptions.RestClientException;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.junit.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.Scanner;

import static org.junit.Assert.*;

public class AvroByteArrayConverterTest {

    @Test
    public void toConnect() throws DecoderException {
        String str = "0000000001004a746573745f646562657a69756d5f6d7973716c2d746573745f6b70745f6364632d6176726f";
        Hex hex = new Hex();
        byte[] bytes = hex.decode(str.getBytes());

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
        AvroSchema avroSchema = new AvroSchema(schema);

        AvroByteArrayConverter mockConverter = new AvroByteArrayConverter("mock://me:58081");
        Object obj = mockConverter.toConnectData(bytes,true,avroSchema);

        AvroByteArrayConverter converter = new AvroByteArrayConverter("http://me:58081");
        Object obj2 = converter.toConnectData(bytes,true,null);
    }
}