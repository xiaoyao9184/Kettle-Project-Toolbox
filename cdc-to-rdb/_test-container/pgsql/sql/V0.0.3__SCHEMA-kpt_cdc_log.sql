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
-- Name: kpt_cdc_log; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA kpt_cdc_log;


ALTER SCHEMA kpt_cdc_log OWNER TO postgres;

--
-- Name: SCHEMA kpt_cdc_log; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA kpt_cdc_log IS 'KPT CDC log(kettle log)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cdc_to_batch__channel; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.cdc_to_batch__channel (
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


ALTER TABLE kpt_cdc_log.cdc_to_batch__channel OWNER TO postgres;

--
-- Name: cdc_to_batch__metrics; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.cdc_to_batch__metrics (
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


ALTER TABLE kpt_cdc_log.cdc_to_batch__metrics OWNER TO postgres;

--
-- Name: cdc_to_batch__seq; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.cdc_to_batch__seq (
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


ALTER TABLE kpt_cdc_log.cdc_to_batch__seq OWNER TO postgres;

--
-- Name: cdc_to_batch__step; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.cdc_to_batch__step (
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


ALTER TABLE kpt_cdc_log.cdc_to_batch__step OWNER TO postgres;

--
-- Name: cdc_to_batch__trans; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.cdc_to_batch__trans (
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


ALTER TABLE kpt_cdc_log.cdc_to_batch__trans OWNER TO postgres;

--
-- Name: log_environment_to_logtable__channel; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.log_environment_to_logtable__channel (
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


ALTER TABLE kpt_cdc_log.log_environment_to_logtable__channel OWNER TO postgres;

--
-- Name: log_environment_to_logtable__metrics; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.log_environment_to_logtable__metrics (
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


ALTER TABLE kpt_cdc_log.log_environment_to_logtable__metrics OWNER TO postgres;

--
-- Name: log_environment_to_logtable__seq; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.log_environment_to_logtable__seq (
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


ALTER TABLE kpt_cdc_log.log_environment_to_logtable__seq OWNER TO postgres;

--
-- Name: log_environment_to_logtable__step; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.log_environment_to_logtable__step (
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


ALTER TABLE kpt_cdc_log.log_environment_to_logtable__step OWNER TO postgres;

--
-- Name: log_environment_to_logtable__trans; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.log_environment_to_logtable__trans (
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


ALTER TABLE kpt_cdc_log.log_environment_to_logtable__trans OWNER TO postgres;

--
-- Name: batch_to_group.stream__channel; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.batch_to_group.stream__channel (
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


ALTER TABLE kpt_cdc_log.batch_to_group.stream__channel OWNER TO postgres;

--
-- Name: batch_to_group.stream__metrics; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.batch_to_group.stream__metrics (
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


ALTER TABLE kpt_cdc_log.batch_to_group.stream__metrics OWNER TO postgres;

--
-- Name: batch_to_group.stream__seq; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.batch_to_group.stream__seq (
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


ALTER TABLE kpt_cdc_log.batch_to_group.stream__seq OWNER TO postgres;

--
-- Name: batch_to_group.stream__step; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.batch_to_group.stream__step (
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


ALTER TABLE kpt_cdc_log.batch_to_group.stream__step OWNER TO postgres;

--
-- Name: batch_to_group.stream__trans; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.batch_to_group.stream__trans (
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


ALTER TABLE kpt_cdc_log.batch_to_group.stream__trans OWNER TO postgres;

--
-- Name: group_to_table.result__channel; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.group_to_table.result__channel (
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


ALTER TABLE kpt_cdc_log.group_to_table.result__channel OWNER TO postgres;

--
-- Name: group_to_table.result__metrics; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.group_to_table.result__metrics (
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


ALTER TABLE kpt_cdc_log.group_to_table.result__metrics OWNER TO postgres;

--
-- Name: group_to_table.result__seq; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.group_to_table.result__seq (
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


ALTER TABLE kpt_cdc_log.group_to_table.result__seq OWNER TO postgres;

--
-- Name: group_to_table.result__step; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.group_to_table.result__step (
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


ALTER TABLE kpt_cdc_log.group_to_table.result__step OWNER TO postgres;

--
-- Name: group_to_table.result__trans; Type: TABLE; Schema: kpt_cdc_log; Owner: postgres
--

CREATE TABLE kpt_cdc_log.group_to_table.result__trans (
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


ALTER TABLE kpt_cdc_log.group_to_table.result__trans OWNER TO postgres;

--
-- Name: idx_kpt_cdc_log__log_environment_to_logtable__channel_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log__log_environment_to_logtable__channel_0 ON kpt_cdc_log.log_environment_to_logtable__channel USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log__log_environment_to_logtable__step_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log__log_environment_to_logtable__step_0 ON kpt_cdc_log.log_environment_to_logtable__step USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log__log_environment_to_logtable__step_1; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log__log_environment_to_logtable__step_1 ON kpt_cdc_log.log_environment_to_logtable__step USING btree (id_batch);


--
-- Name: idx_kpt_cdc_log__log_environment_to_logtable__step_2; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log__log_environment_to_logtable__step_2 ON kpt_cdc_log.log_environment_to_logtable__step USING btree (transname);


--
-- Name: idx_kpt_cdc_log__log_environment_to_logtable__trans_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log__log_environment_to_logtable__trans_0 ON kpt_cdc_log.log_environment_to_logtable__trans USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log__log_environment_to_logtable__trans_1; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log__log_environment_to_logtable__trans_1 ON kpt_cdc_log.log_environment_to_logtable__trans USING btree (id_batch);


--
-- Name: idx_kpt_cdc_log__log_environment_to_logtable__trans_2; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log__log_environment_to_logtable__trans_2 ON kpt_cdc_log.log_environment_to_logtable__trans USING btree (errors, status, transname);


--
-- Name: idx_kpt_cdc_log_cdc_to_batch__channel_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_cdc_to_batch__channel_0 ON kpt_cdc_log.cdc_to_batch__channel USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_cdc_to_batch__step_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_cdc_to_batch__step_0 ON kpt_cdc_log.cdc_to_batch__step USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_cdc_to_batch__step_1; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_cdc_to_batch__step_1 ON kpt_cdc_log.cdc_to_batch__step USING btree (id_batch);


--
-- Name: idx_kpt_cdc_log_cdc_to_batch__step_2; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_cdc_to_batch__step_2 ON kpt_cdc_log.cdc_to_batch__step USING btree (transname);


--
-- Name: idx_kpt_cdc_log_cdc_to_batch__trans_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_cdc_to_batch__trans_0 ON kpt_cdc_log.cdc_to_batch__trans USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_cdc_to_batch__trans_1; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_cdc_to_batch__trans_1 ON kpt_cdc_log.cdc_to_batch__trans USING btree (id_batch);


--
-- Name: idx_kpt_cdc_log_cdc_to_batch__trans_2; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_cdc_to_batch__trans_2 ON kpt_cdc_log.cdc_to_batch__trans USING btree (errors, status, transname);


--
-- Name: idx_kpt_cdc_log_batch_to_group.stream__channel_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_batch_to_group.stream__channel_0 ON kpt_cdc_log.batch_to_group.stream__channel USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_batch_to_group.stream__step_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_batch_to_group.stream__step_0 ON kpt_cdc_log.batch_to_group.stream__step USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_batch_to_group.stream__step_1; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_batch_to_group.stream__step_1 ON kpt_cdc_log.batch_to_group.stream__step USING btree (id_batch);


--
-- Name: idx_kpt_cdc_log_batch_to_group.stream__step_2; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_batch_to_group.stream__step_2 ON kpt_cdc_log.batch_to_group.stream__step USING btree (transname);


--
-- Name: idx_kpt_cdc_log_batch_to_group.stream__trans_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_batch_to_group.stream__trans_0 ON kpt_cdc_log.batch_to_group.stream__trans USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_batch_to_group.stream__trans_1; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_batch_to_group.stream__trans_1 ON kpt_cdc_log.batch_to_group.stream__trans USING btree (id_batch);


--
-- Name: idx_kpt_cdc_log_batch_to_group.stream__trans_2; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_batch_to_group.stream__trans_2 ON kpt_cdc_log.batch_to_group.stream__trans USING btree (errors, status, transname);


--
-- Name: idx_kpt_cdc_log_group_to_table.result__channel_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_group_to_table.result__channel_0 ON kpt_cdc_log.group_to_table.result__channel USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_group_to_table.result__step_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_group_to_table.result__step_0 ON kpt_cdc_log.group_to_table.result__step USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_group_to_table.result__step_1; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_group_to_table.result__step_1 ON kpt_cdc_log.group_to_table.result__step USING btree (id_batch);


--
-- Name: idx_kpt_cdc_log_group_to_table.result__step_2; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_group_to_table.result__step_2 ON kpt_cdc_log.group_to_table.result__step USING btree (transname);


--
-- Name: idx_kpt_cdc_log_group_to_table.result__trans_0; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_group_to_table.result__trans_0 ON kpt_cdc_log.group_to_table.result__trans USING btree (channel_id);


--
-- Name: idx_kpt_cdc_log_group_to_table.result__trans_1; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_group_to_table.result__trans_1 ON kpt_cdc_log.group_to_table.result__trans USING btree (id_batch);


--
-- Name: idx_kpt_cdc_log_group_to_table.result__trans_2; Type: INDEX; Schema: kpt_cdc_log; Owner: postgres
--

CREATE INDEX idx_kpt_cdc_log_group_to_table.result__trans_2 ON kpt_cdc_log.group_to_table.result__trans USING btree (errors, status, transname);


--
-- Name: SCHEMA kpt_cdc_log; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA kpt_cdc_log TO kpt;


--
-- Name: TABLE cdc_to_batch__channel; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.cdc_to_batch__channel TO kpt;


--
-- Name: TABLE cdc_to_batch__metrics; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.cdc_to_batch__metrics TO kpt;


--
-- Name: TABLE cdc_to_batch__seq; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.cdc_to_batch__seq TO kpt;


--
-- Name: TABLE cdc_to_batch__step; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.cdc_to_batch__step TO kpt;


--
-- Name: TABLE cdc_to_batch__trans; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.cdc_to_batch__trans TO kpt;


--
-- Name: TABLE log_environment_to_logtable__channel; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.log_environment_to_logtable__channel TO kpt;


--
-- Name: TABLE log_environment_to_logtable__metrics; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.log_environment_to_logtable__metrics TO kpt;


--
-- Name: TABLE log_environment_to_logtable__seq; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.log_environment_to_logtable__seq TO kpt;


--
-- Name: TABLE log_environment_to_logtable__step; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.log_environment_to_logtable__step TO kpt;


--
-- Name: TABLE log_environment_to_logtable__trans; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.log_environment_to_logtable__trans TO kpt;


--
-- Name: TABLE batch_to_group.stream__channel; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.batch_to_group.stream__channel TO kpt;


--
-- Name: TABLE batch_to_group.stream__metrics; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.batch_to_group.stream__metrics TO kpt;


--
-- Name: TABLE batch_to_group.stream__seq; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.batch_to_group.stream__seq TO kpt;


--
-- Name: TABLE batch_to_group.stream__step; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.batch_to_group.stream__step TO kpt;


--
-- Name: TABLE batch_to_group.stream__trans; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.batch_to_group.stream__trans TO kpt;


--
-- Name: TABLE group_to_table.result__channel; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.group_to_table.result__channel TO kpt;


--
-- Name: TABLE group_to_table.result__metrics; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.group_to_table.result__metrics TO kpt;


--
-- Name: TABLE group_to_table.result__seq; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.group_to_table.result__seq TO kpt;


--
-- Name: TABLE group_to_table.result__step; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.group_to_table.result__step TO kpt;


--
-- Name: TABLE group_to_table.result__trans; Type: ACL; Schema: kpt_cdc_log; Owner: postgres
--

GRANT ALL ON TABLE kpt_cdc_log.group_to_table.result__trans TO kpt;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: kpt_cdc_log; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_log GRANT ALL ON SEQUENCES  TO kpt;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: kpt_cdc_log; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_log GRANT ALL ON TYPES  TO kpt;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: kpt_cdc_log; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_log GRANT ALL ON FUNCTIONS  TO kpt;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: kpt_cdc_log; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA kpt_cdc_log GRANT ALL ON TABLES  TO kpt;


--
-- PostgreSQL database dump complete
--

