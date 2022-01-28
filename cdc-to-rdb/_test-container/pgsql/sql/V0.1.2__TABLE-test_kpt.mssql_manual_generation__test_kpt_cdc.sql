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
-- Name: mssql_manual_generation__test_kpt_cdc; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA mssql_manual_generation__test_kpt_cdc;


ALTER SCHEMA mssql_manual_generation__test_kpt_cdc OWNER TO kpt;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 277 (class 1259 OID 599106)
-- Name: debezium_types; Type: TABLE; Schema: mssql_manual_generation__test_kpt_cdc; Owner: postgres
--

CREATE TABLE mssql_manual_generation__test_kpt_cdc.debezium_types (
    _id character varying(10) NOT NULL,
    "BIT" bit(1),
    "TINYINT" integer,
    "SMALLINT" smallint,
    "INT" integer,
    "BIGINT" bigint,
    "REAL" real,
    "FLOAT" double precision,
    "CHAR" character(10),
    "VARCHAR" character varying(50),
    "TEXT" text,
    "NCHAR" character varying(10),
    "NVARCHAR" character varying(50),
    "NTEXT" text,
    "XML" xml,
    "DATETIMEOFFSET" timestamp with time zone,
    "DATE" date,
    "TIME_3" time without time zone,
    "TIME_6" time without time zone,
    "TIME_7" time without time zone,
    "DATETIME" timestamp without time zone,
    "SMALLDATETIME" timestamp without time zone,
    "DATETIME2_3" timestamp without time zone,
    "DATETIME2_6" timestamp without time zone,
    "DATETIME2_7" timestamp without time zone,
    "NUMERIC" numeric(18,1),
    "DECIMAL" numeric(18,2),
    "SMALLMONEY" numeric(18,2),
    "MONEY" numeric(18,2)
);


ALTER TABLE mssql_manual_generation__test_kpt_cdc.debezium_types OWNER TO kpt;

--
-- TOC entry 278 (class 1259 OID 599956)
-- Name: change_pk__debezium_types; Type: TABLE; Schema: mssql_manual_generation__test_kpt_cdc; Owner: postgres
--

CREATE TABLE mssql_manual_generation__test_kpt_cdc.change_pk__debezium_types (
    _id character varying(10) NOT NULL,
    "BIT" bit(1),
    "TINYINT" integer,
    "SMALLINT" smallint,
    "INT" integer,
    "BIGINT" bigint,
    "REAL" real,
    "FLOAT" double precision,
    "CHAR" character(10),
    "VARCHAR" character varying(50),
    "TEXT" text,
    "NCHAR" character varying(10),
    "NVARCHAR" character varying(50),
    "NTEXT" text,
    "XML" xml,
    "DATETIMEOFFSET" timestamp with time zone,
    "DATE" date,
    "TIME_3" time without time zone,
    "TIME_6" time without time zone,
    "TIME_7" time without time zone,
    "DATETIME" timestamp without time zone,
    "SMALLDATETIME" timestamp without time zone,
    "DATETIME2_3" timestamp without time zone,
    "DATETIME2_6" timestamp without time zone,
    "DATETIME2_7" timestamp without time zone,
    "NUMERIC" numeric(18,1),
    "DECIMAL" numeric(18,2),
    "SMALLMONEY" numeric(18,2),
    "MONEY" numeric(18,2)
);


ALTER TABLE mssql_manual_generation__test_kpt_cdc.change_pk__debezium_types OWNER TO kpt;

--
-- TOC entry 3114 (class 2606 OID 599963)
-- Name: change_pk__debezium_types change_pk__debezium_types_pkey; Type: CONSTRAINT; Schema: mssql_manual_generation__test_kpt_cdc; Owner: postgres
--

ALTER TABLE ONLY mssql_manual_generation__test_kpt_cdc.change_pk__debezium_types
    ADD CONSTRAINT change_pk__debezium_types_pkey PRIMARY KEY ("VARCHAR", "DATETIME");


--
-- TOC entry 3112 (class 2606 OID 599948)
-- Name: debezium_types debezium_types_pkey; Type: CONSTRAINT; Schema: mssql_manual_generation__test_kpt_cdc; Owner: postgres
--

ALTER TABLE ONLY mssql_manual_generation__test_kpt_cdc.debezium_types
    ADD CONSTRAINT debezium_types_pkey PRIMARY KEY (_id);


--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA mssql_manual_generation__test_kpt_cdc; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA mssql_manual_generation__test_kpt_cdc TO kpt;


--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE debezium_types; Type: ACL; Schema: mssql_manual_generation__test_kpt_cdc; Owner: postgres
--

GRANT ALL ON TABLE mssql_manual_generation__test_kpt_cdc.debezium_types TO kpt;


-- Completed on 2021-09-23 07:51:54 UTC

--
-- PostgreSQL database dump complete
--

