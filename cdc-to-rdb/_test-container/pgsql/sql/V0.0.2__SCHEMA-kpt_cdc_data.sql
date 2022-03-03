--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-07-30 09:53:29 UTC

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
-- TOC entry 6 (class 2615 OID 52325)
-- Name: kpt_cdc_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA kpt_cdc_data;


ALTER SCHEMA kpt_cdc_data OWNER TO postgres;

--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA kpt_cdc_data; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA kpt_cdc_data IS 'KPT kettle data';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 540 (class 1259 OID 52326)
-- Name: mapping_table; Type: TABLE; Schema: kpt_cdc_data; Owner: postgres
--

CREATE TABLE IF NOT EXISTS kpt_cdc_data.mapping_table (
	source_name text NOT NULL,
	source_schema text NOT NULL,
	source_table text NOT NULL,
	target_schema text NOT NULL,
	target_table text NOT NULL,
	CONSTRAINT mapping_table_pk PRIMARY KEY (source_name,source_schema,source_table)
);


ALTER TABLE kpt_cdc_data.mapping_table OWNER TO postgres;

--
-- TOC entry 541 (class 1259 OID 52332)
-- Name: mapping_column; Type: TABLE; Schema: kpt_cdc_data; Owner: postgres
--

CREATE TABLE IF NOT EXISTS kpt_cdc_data.mapping_column (
	source_name text NOT NULL,
	source_schema text NOT NULL,
	source_table text NOT NULL,
    source_column text NOT NULL,
	target_schema text NOT NULL,
	target_table text NOT NULL,
    target_column text NOT NULL,
	CONSTRAINT mapping_column_pk PRIMARY KEY (source_name,source_schema,source_table,source_column)
);


ALTER TABLE kpt_cdc_data.mapping_column OWNER TO postgres;


--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA kpt_cdc_data; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA kpt_cdc_data TO kpt;


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 540
-- Name: TABLE mapping_table; Type: ACL; Schema: kpt_cdc_data; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_data.mapping_table TO kpt;


--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 541
-- Name: TABLE mapping_column; Type: ACL; Schema: kpt_cdc_data; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_data.mapping_column TO kpt;


--
-- TOC entry 3130 (class 826 OID 52582)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: kpt_cdc_data; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data REVOKE ALL ON SEQUENCES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data GRANT ALL ON SEQUENCES  TO kpt;


--
-- TOC entry 3131 (class 826 OID 52583)
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: kpt_cdc_data; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data REVOKE ALL ON TYPES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data REVOKE ALL ON TYPES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data GRANT ALL ON TYPES  TO kpt;


--
-- TOC entry 3132 (class 826 OID 52584)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: kpt_cdc_data; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data REVOKE ALL ON FUNCTIONS  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data GRANT ALL ON FUNCTIONS  TO kpt;


--
-- TOC entry 3133 (class 826 OID 52585)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: kpt_cdc_data; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_data GRANT ALL ON TABLES  TO kpt;


-- Completed on 2021-07-30 09:53:29 UTC

--
-- PostgreSQL database dump complete
--

