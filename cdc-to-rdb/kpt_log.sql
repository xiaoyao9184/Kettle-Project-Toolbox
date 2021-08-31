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
-- Name: kpt_log; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA kpt_log;


ALTER SCHEMA kpt_log OWNER TO postgres;

--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA kpt_log; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA kpt_log IS 'KPT kettle log';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 540 (class 1259 OID 52326)
-- Name: kafka_to_stream__channel; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.kafka_to_stream__channel (
    id_batch integer,
    channel_id character varying(255),
    log_date timestamp without time zone,
    logging_object_type character varying(255),
    object_name character varying(255),
    object_copy character varying(255),
    repository_directory character varying(255),
    filename character varying(255),
    object_id character varying(255),
    object_revision character varying(255),
    parent_channel_id character varying(255),
    root_channel_id character varying(255)
);


ALTER TABLE kpt_log.kafka_to_stream__channel OWNER TO postgres;

--
-- TOC entry 541 (class 1259 OID 52332)
-- Name: kafka_to_stream__ktr; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.kafka_to_stream__ktr (
    id_batch integer,
    channel_id character varying(255),
    transname character varying(255),
    status character varying(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    logdate timestamp without time zone,
    depdate timestamp without time zone,
    replaydate timestamp without time zone,
    log_field text,
    executing_server character varying(255),
    executing_user character varying(255),
    client character varying(255)
);


ALTER TABLE kpt_log.kafka_to_stream__ktr OWNER TO postgres;

--
-- TOC entry 542 (class 1259 OID 52338)
-- Name: kafka_to_stream__metrics; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.kafka_to_stream__metrics (
    id_batch integer,
    channel_id character varying(255),
    log_date timestamp without time zone,
    metrics_date timestamp without time zone,
    metrics_code character varying(255),
    metrics_description character varying(255),
    metrics_subject character varying(255),
    metrics_type character varying(255),
    metrics_value bigint
);


ALTER TABLE kpt_log.kafka_to_stream__metrics OWNER TO postgres;

--
-- TOC entry 543 (class 1259 OID 52344)
-- Name: kafka_to_stream__seq; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.kafka_to_stream__seq (
    id_batch integer,
    seq_nr integer,
    logdate timestamp without time zone,
    transname character varying(255),
    stepname character varying(255),
    step_copy integer,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    input_buffer_rows bigint,
    output_buffer_rows bigint
);


ALTER TABLE kpt_log.kafka_to_stream__seq OWNER TO postgres;

--
-- TOC entry 544 (class 1259 OID 52350)
-- Name: kafka_to_stream__step; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.kafka_to_stream__step (
    id_batch integer,
    transname character varying(255),
    stepname character varying(255),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    channel_id character varying(255),
    log_date timestamp without time zone,
    log_field text,
    step_copy smallint
);


ALTER TABLE kpt_log.kafka_to_stream__step OWNER TO postgres;

--
-- TOC entry 545 (class 1259 OID 52356)
-- Name: stream_parse_to_each_table__channel; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.stream_parse_to_each_table__channel (
    id_batch integer,
    channel_id character varying(255),
    log_date timestamp without time zone,
    logging_object_type character varying(255),
    object_name character varying(255),
    object_copy character varying(255),
    repository_directory character varying(255),
    filename character varying(255),
    object_id character varying(255),
    object_revision character varying(255),
    parent_channel_id character varying(255),
    root_channel_id character varying(255)
);


ALTER TABLE kpt_log.stream_parse_to_each_table__channel OWNER TO postgres;

--
-- TOC entry 546 (class 1259 OID 52362)
-- Name: stream_parse_to_each_table__ktr; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.stream_parse_to_each_table__ktr (
    id_batch integer,
    channel_id character varying(255),
    transname character varying(255),
    status character varying(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    logdate timestamp without time zone,
    depdate timestamp without time zone,
    replaydate timestamp without time zone,
    log_field text,
    executing_server character varying(255),
    executing_user character varying(255),
    client character varying(255)
);


ALTER TABLE kpt_log.stream_parse_to_each_table__ktr OWNER TO postgres;

--
-- TOC entry 547 (class 1259 OID 52368)
-- Name: stream_parse_to_each_table__metrics; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.stream_parse_to_each_table__metrics (
    id_batch integer,
    channel_id character varying(255),
    log_date timestamp without time zone,
    metrics_date timestamp without time zone,
    metrics_code character varying(255),
    metrics_description character varying(255),
    metrics_subject character varying(255),
    metrics_type character varying(255),
    metrics_value bigint
);


ALTER TABLE kpt_log.stream_parse_to_each_table__metrics OWNER TO postgres;

--
-- TOC entry 548 (class 1259 OID 52374)
-- Name: stream_parse_to_each_table__seq; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.stream_parse_to_each_table__seq (
    id_batch integer,
    seq_nr integer,
    logdate timestamp without time zone,
    transname character varying(255),
    stepname character varying(255),
    step_copy integer,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    input_buffer_rows bigint,
    output_buffer_rows bigint
);


ALTER TABLE kpt_log.stream_parse_to_each_table__seq OWNER TO postgres;

--
-- TOC entry 549 (class 1259 OID 52380)
-- Name: stream_parse_to_each_table__step; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.stream_parse_to_each_table__step (
    id_batch integer,
    transname character varying(255),
    stepname character varying(255),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    channel_id character varying(255),
    log_date timestamp without time zone,
    log_field text,
    step_copy smallint
);


ALTER TABLE kpt_log.stream_parse_to_each_table__step OWNER TO postgres;

--
-- TOC entry 575 (class 1259 OID 52536)
-- Name: table_log_to_specify_table__channel; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.table_log_to_specify_table__channel (
    id_batch integer,
    channel_id character varying(255),
    log_date timestamp without time zone,
    logging_object_type character varying(255),
    object_name character varying(255),
    object_copy character varying(255),
    repository_directory character varying(255),
    filename character varying(255),
    object_id character varying(255),
    object_revision character varying(255),
    parent_channel_id character varying(255),
    root_channel_id character varying(255)
);


ALTER TABLE kpt_log.table_log_to_specify_table__channel OWNER TO postgres;

--
-- TOC entry 576 (class 1259 OID 52542)
-- Name: table_log_to_specify_table__ktr; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.table_log_to_specify_table__ktr (
    id_batch integer,
    channel_id character varying(255),
    transname character varying(255),
    status character varying(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    logdate timestamp without time zone,
    depdate timestamp without time zone,
    replaydate timestamp without time zone,
    log_field text,
    executing_server character varying(255),
    executing_user character varying(255),
    client character varying(255)
);


ALTER TABLE kpt_log.table_log_to_specify_table__ktr OWNER TO postgres;

--
-- TOC entry 577 (class 1259 OID 52548)
-- Name: table_log_to_specify_table__metrics; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.table_log_to_specify_table__metrics (
    id_batch integer,
    channel_id character varying(255),
    log_date timestamp without time zone,
    metrics_date timestamp without time zone,
    metrics_code character varying(255),
    metrics_description character varying(255),
    metrics_subject character varying(255),
    metrics_type character varying(255),
    metrics_value bigint
);


ALTER TABLE kpt_log.table_log_to_specify_table__metrics OWNER TO postgres;

--
-- TOC entry 578 (class 1259 OID 52554)
-- Name: table_log_to_specify_table__seq; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.table_log_to_specify_table__seq (
    id_batch integer,
    seq_nr integer,
    logdate timestamp without time zone,
    transname character varying(255),
    stepname character varying(255),
    step_copy integer,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    input_buffer_rows bigint,
    output_buffer_rows bigint
);


ALTER TABLE kpt_log.table_log_to_specify_table__seq OWNER TO postgres;

--
-- TOC entry 579 (class 1259 OID 52560)
-- Name: table_log_to_specify_table__step; Type: TABLE; Schema: kpt_log; Owner: postgres
--

CREATE TABLE kpt_log.table_log_to_specify_table__step (
    id_batch integer,
    transname character varying(255),
    stepname character varying(255),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    channel_id character varying(255),
    log_date timestamp without time zone,
    log_field text,
    step_copy smallint
);


ALTER TABLE kpt_log.table_log_to_specify_table__step OWNER TO postgres;

--
-- TOC entry 4265 (class 1259 OID 52566)
-- Name: idx_log__kafka_to_stream__ktr_1; Type: INDEX; Schema: kpt_log; Owner: postgres
--

CREATE INDEX idx_log__kafka_to_stream__ktr_1 ON kpt_log.kafka_to_stream__ktr USING btree (id_batch);


--
-- TOC entry 4266 (class 1259 OID 52567)
-- Name: idx_log__kafka_to_stream__ktr_2; Type: INDEX; Schema: kpt_log; Owner: postgres
--

CREATE INDEX idx_log__kafka_to_stream__ktr_2 ON kpt_log.kafka_to_stream__ktr USING btree (errors, status, transname);


--
-- TOC entry 4267 (class 1259 OID 52568)
-- Name: idx_log__stream_parse_to_each_table__ktr_1; Type: INDEX; Schema: kpt_log; Owner: postgres
--

CREATE INDEX idx_log__stream_parse_to_each_table__ktr_1 ON kpt_log.stream_parse_to_each_table__ktr USING btree (id_batch);


--
-- TOC entry 4268 (class 1259 OID 52569)
-- Name: idx_log__stream_parse_to_each_table__ktr_2; Type: INDEX; Schema: kpt_log; Owner: postgres
--

CREATE INDEX idx_log__stream_parse_to_each_table__ktr_2 ON kpt_log.stream_parse_to_each_table__ktr USING btree (errors, status, transname);


--
-- TOC entry 4279 (class 1259 OID 52580)
-- Name: idx_log__table_log_to_specify_table__ktr_1; Type: INDEX; Schema: kpt_log; Owner: postgres
--

CREATE INDEX idx_log__table_log_to_specify_table__ktr_1 ON kpt_log.table_log_to_specify_table__ktr USING btree (id_batch);


--
-- TOC entry 4280 (class 1259 OID 52581)
-- Name: idx_log__table_log_to_specify_table__ktr_2; Type: INDEX; Schema: kpt_log; Owner: postgres
--

CREATE INDEX idx_log__table_log_to_specify_table__ktr_2 ON kpt_log.table_log_to_specify_table__ktr USING btree (errors, status, transname);


--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA kpt_log; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA kpt_log TO kpt;


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 540
-- Name: TABLE kafka_to_stream__channel; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.kafka_to_stream__channel TO kpt;


--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 541
-- Name: TABLE kafka_to_stream__ktr; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.kafka_to_stream__ktr TO kpt;


--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 542
-- Name: TABLE kafka_to_stream__metrics; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.kafka_to_stream__metrics TO kpt;


--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 543
-- Name: TABLE kafka_to_stream__seq; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.kafka_to_stream__seq TO kpt;


--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 544
-- Name: TABLE kafka_to_stream__step; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.kafka_to_stream__step TO kpt;


--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 545
-- Name: TABLE stream_parse_to_each_table__channel; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.stream_parse_to_each_table__channel TO kpt;


--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 546
-- Name: TABLE stream_parse_to_each_table__ktr; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.stream_parse_to_each_table__ktr TO kpt;


--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 547
-- Name: TABLE stream_parse_to_each_table__metrics; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.stream_parse_to_each_table__metrics TO kpt;


--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 548
-- Name: TABLE stream_parse_to_each_table__seq; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.stream_parse_to_each_table__seq TO kpt;


--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 549
-- Name: TABLE stream_parse_to_each_table__step; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.stream_parse_to_each_table__step TO kpt;


--
-- TOC entry 4453 (class 0 OID 0)
-- Dependencies: 575
-- Name: TABLE table_log_to_specify_table__channel; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.table_log_to_specify_table__channel TO kpt;


--
-- TOC entry 4454 (class 0 OID 0)
-- Dependencies: 576
-- Name: TABLE table_log_to_specify_table__ktr; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.table_log_to_specify_table__ktr TO kpt;


--
-- TOC entry 4455 (class 0 OID 0)
-- Dependencies: 577
-- Name: TABLE table_log_to_specify_table__metrics; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.table_log_to_specify_table__metrics TO kpt;


--
-- TOC entry 4456 (class 0 OID 0)
-- Dependencies: 578
-- Name: TABLE table_log_to_specify_table__seq; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.table_log_to_specify_table__seq TO kpt;


--
-- TOC entry 4457 (class 0 OID 0)
-- Dependencies: 579
-- Name: TABLE table_log_to_specify_table__step; Type: ACL; Schema: kpt_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_log.table_log_to_specify_table__step TO kpt;


--
-- TOC entry 3130 (class 826 OID 52582)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: kpt_log; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log REVOKE ALL ON SEQUENCES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log GRANT ALL ON SEQUENCES  TO kpt;


--
-- TOC entry 3131 (class 826 OID 52583)
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: kpt_log; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log REVOKE ALL ON TYPES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log REVOKE ALL ON TYPES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log GRANT ALL ON TYPES  TO kpt;


--
-- TOC entry 3132 (class 826 OID 52584)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: kpt_log; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log REVOKE ALL ON FUNCTIONS  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log GRANT ALL ON FUNCTIONS  TO kpt;


--
-- TOC entry 3133 (class 826 OID 52585)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: kpt_log; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_log GRANT ALL ON TABLES  TO kpt;


-- Completed on 2021-07-30 09:53:29 UTC

--
-- PostgreSQL database dump complete
--

