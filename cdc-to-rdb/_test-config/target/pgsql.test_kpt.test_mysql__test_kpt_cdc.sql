--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.4

-- Started on 2021-09-23 07:51:54 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 9 (class 2615 OID 599055)
-- Name: test_mysql__test_kpt_cdc; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA test_mysql__test_kpt_cdc;


ALTER SCHEMA test_mysql__test_kpt_cdc OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 277 (class 1259 OID 599106)
-- Name: debezium_types; Type: TABLE; Schema: test_mysql__test_kpt_cdc; Owner: postgres
--

CREATE TABLE test_mysql__test_kpt_cdc.debezium_types (
    _id bit varying(10) NOT NULL,
    "BOOLEAN" boolean,
    "BOOL" boolean,
    "BIT_1" bit(1),
    "BIT_not_1" bit(500)[],
    "TINYINT" integer,
    "SMALLINT" smallint,
    "MEDIUMINT" integer,
    "INT" integer,
    "INTEGER" integer,
    "BIGINT" bigint,
    "REAL" real,
    "FLOAT" double precision,
    "DOUBLE" double precision,
    "CHAR" character(1),
    "VARCHAR" character varying(500),
    "BINARY" bit varying(500),
    "VARBINARY" bit varying(500),
    "TINYBLOB" bit varying(500),
    "TINYTEXT" text,
    "BLOB" bit varying(500),
    "TEXT" text,
    "MEDIUMBLOB" bit varying(500),
    "MEDIUMTEXT" text,
    "LONGBLOB" bit varying(500),
    "LONGTEXT" text,
    "JSON" json,
    "ENUM" character varying(10),
    "SET" bit varying(10),
    "YEAR" integer,
    "TIMESTAMP" timestamp with time zone,
    "DATE" date,
    "TIME" time without time zone,
    "DATETIME_3" timestamp without time zone,
    "DATETIME_6" timestamp without time zone,
    "NUMERIC" numeric(10,1),
    "DECIMAL" numeric(10,2),
    "GEOMETRY" character varying,
    "LINESTRING" character varying,
    "POLYGON" character varying,
    "MULTIPOINT" character varying,
    "MULTILINESTRING" character varying,
    "MULTIPOLYGON" character varying,
    "GEOMETRYCOLLECTION" character varying
);


ALTER TABLE test_mysql__test_kpt_cdc.debezium_types OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 599956)
-- Name: change_pk__debezium_types; Type: TABLE; Schema: test_mysql__test_kpt_cdc; Owner: postgres
--

CREATE TABLE test_mysql__test_kpt_cdc.change_pk__debezium_types (
    _id bit varying(10) NOT NULL,
    "BOOLEAN" boolean,
    "BOOL" boolean,
    "BIT_1" bit(1),
    "BIT_not_1" bit(500)[],
    "TINYINT" integer,
    "SMALLINT" smallint,
    "MEDIUMINT" integer,
    "INT" integer,
    "INTEGER" integer,
    "BIGINT" bigint,
    "REAL" real,
    "FLOAT" double precision,
    "DOUBLE" double precision,
    "CHAR" character(1),
    "VARCHAR" character varying(500) NOT NULL,
    "BINARY" bit varying(500),
    "VARBINARY" bit varying(500),
    "TINYBLOB" bit varying(500),
    "TINYTEXT" text,
    "BLOB" bit varying(500),
    "TEXT" text,
    "MEDIUMBLOB" bit varying(500),
    "MEDIUMTEXT" text,
    "LONGBLOB" bit varying(500),
    "LONGTEXT" text,
    "JSON" json,
    "ENUM" character varying(10),
    "SET" bit varying(10),
    "YEAR" integer,
    "TIMESTAMP" timestamp with time zone NOT NULL,
    "DATE" date,
    "TIME" time without time zone,
    "DATETIME_3" timestamp without time zone,
    "DATETIME_6" timestamp without time zone,
    "NUMERIC" numeric(10,1),
    "DECIMAL" numeric(10,2),
    "GEOMETRY" character varying,
    "LINESTRING" character varying,
    "POLYGON" character varying,
    "MULTIPOINT" character varying,
    "MULTILINESTRING" character varying,
    "MULTIPOLYGON" character varying,
    "GEOMETRYCOLLECTION" character varying
);


ALTER TABLE test_mysql__test_kpt_cdc.change_pk__debezium_types OWNER TO postgres;

--
-- TOC entry 3114 (class 2606 OID 599963)
-- Name: change_pk__debezium_types change_pk__debezium_types_pkey; Type: CONSTRAINT; Schema: test_mysql__test_kpt_cdc; Owner: postgres
--

ALTER TABLE ONLY test_mysql__test_kpt_cdc.change_pk__debezium_types
    ADD CONSTRAINT change_pk__debezium_types_pkey PRIMARY KEY ("VARCHAR", "TIMESTAMP");


--
-- TOC entry 3112 (class 2606 OID 599948)
-- Name: debezium_types debezium_types_pkey; Type: CONSTRAINT; Schema: test_mysql__test_kpt_cdc; Owner: postgres
--

ALTER TABLE ONLY test_mysql__test_kpt_cdc.debezium_types
    ADD CONSTRAINT debezium_types_pkey PRIMARY KEY (_id);


--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA test_mysql__test_kpt_cdc; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA test_mysql__test_kpt_cdc TO edata_kpt;


--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE debezium_types; Type: ACL; Schema: test_mysql__test_kpt_cdc; Owner: postgres
--

GRANT ALL ON TABLE test_mysql__test_kpt_cdc.debezium_types TO edata_kpt;


-- Completed on 2021-09-23 07:51:54 UTC

--
-- PostgreSQL database dump complete
--

