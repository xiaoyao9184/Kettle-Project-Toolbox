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

CREATE SCHEMA "UPPERCASE";


ALTER SCHEMA "UPPERCASE" OWNER TO kpt;

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE "UPPERCASE"."UPPERCASE_table" (
    "UPPERCASE__id" character varying(255) NOT NULL
);

ALTER TABLE ONLY "UPPERCASE"."UPPERCASE_table"
    ADD CONSTRAINT uppercase__uppercase_table_pkey PRIMARY KEY ("UPPERCASE__id");


ALTER TABLE "UPPERCASE"."UPPERCASE_table" OWNER TO kpt;

GRANT ALL ON SCHEMA "UPPERCASE" TO kpt;

GRANT ALL ON TABLE "UPPERCASE"."UPPERCASE_table" TO kpt;
