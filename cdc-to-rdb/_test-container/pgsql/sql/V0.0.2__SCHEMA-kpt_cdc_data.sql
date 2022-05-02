--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.5

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
-- Name: kpt_cdc_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA kpt_cdc_data;


ALTER SCHEMA kpt_cdc_data OWNER TO postgres;

--
-- Name: SCHEMA kpt_cdc_data; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA kpt_cdc_data IS 'KPT CDC data';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: mapping_column; Type: TABLE; Schema: kpt_cdc_data; Owner: postgres
--

CREATE TABLE kpt_cdc_data.mapping_column (
    source_name text NOT NULL,
    source_schema text NOT NULL,
    source_table text NOT NULL,
    source_column text NOT NULL,
    target_schema text NOT NULL,
    target_table text NOT NULL,
    target_column text NOT NULL
);


ALTER TABLE kpt_cdc_data.mapping_column OWNER TO postgres;

--
-- Name: mapping_table; Type: TABLE; Schema: kpt_cdc_data; Owner: postgres
--

CREATE TABLE kpt_cdc_data.mapping_table (
    source_name text NOT NULL,
    source_schema text NOT NULL,
    source_table text NOT NULL,
    target_schema text NOT NULL,
    target_table text NOT NULL
);


ALTER TABLE kpt_cdc_data.mapping_table OWNER TO postgres;

--
-- Name: mapping_column mapping_column_pk; Type: CONSTRAINT; Schema: kpt_cdc_data; Owner: postgres
--

ALTER TABLE ONLY kpt_cdc_data.mapping_column
    ADD CONSTRAINT mapping_column_pk PRIMARY KEY (source_name, source_schema, source_table, source_column);


--
-- Name: mapping_table mapping_table_pk; Type: CONSTRAINT; Schema: kpt_cdc_data; Owner: postgres
--

ALTER TABLE ONLY kpt_cdc_data.mapping_table
    ADD CONSTRAINT mapping_table_pk PRIMARY KEY (source_name, source_schema, source_table);


--
-- Name: SCHEMA kpt_cdc_data; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA kpt_cdc_data TO kpt;


--
-- Name: TABLE mapping_column; Type: ACL; Schema: kpt_cdc_data; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_data.mapping_column TO kpt;


--
-- Name: TABLE mapping_table; Type: ACL; Schema: kpt_cdc_data; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_data.mapping_table TO kpt;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: kpt_cdc_data; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data GRANT ALL ON SEQUENCES  TO kpt;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: kpt_cdc_data; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data GRANT ALL ON TYPES  TO kpt;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: kpt_cdc_data; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data GRANT ALL ON FUNCTIONS  TO kpt;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: kpt_cdc_data; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data GRANT ALL ON TABLES  TO kpt;


--
-- PostgreSQL database dump complete
--

