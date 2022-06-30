package com.github.xiaoyao9184;

import org.junit.Test;

import java.io.*;
import java.util.stream.Collectors;

import static com.jayway.jsonpath.matchers.JsonPathMatchers.hasJsonPath;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class JsonSchemaConverterTest {

    public String readSchemaJson(int schemaId) throws IOException {
        InputStream is = this.getClass().getClassLoader()
                .getResourceAsStream("schema_registry/schemas/ids/" + schemaId + ".json");
        Reader in = new InputStreamReader(is);
        return new BufferedReader(in)
                .lines()
                .collect(Collectors.joining("\n"));
    }

    @Test
    public void testDDL_Key() throws IOException {
        String schema = readSchemaJson(1);

        JsonSchemaConverter converter = new JsonSchemaConverter(10);
        String json = converter.toConnectJson(schema,true);

        assertThat(json, hasJsonPath("$.type"));
        assertThat(json, hasJsonPath("$.fields"));
        assertThat(json, hasJsonPath("$.optional"));
        assertThat(json, hasJsonPath("$.name"));

        assertThat(json, hasJsonPath("$.type", equalTo("struct")));
        assertThat(json, hasJsonPath("$.optional", equalTo(false)));
        assertThat(json, hasJsonPath("$.name", equalTo("test_debezium_mysql_test_kpt_cdc_json.data_changes.Key")));

        assertThat(json, hasJsonPath("$.fields[0].type", equalTo("string")));
        assertThat(json, hasJsonPath("$.fields[0].optional", equalTo(false)));
        assertThat(json, hasJsonPath("$.fields[0].field", equalTo("databaseName")));
    }
}