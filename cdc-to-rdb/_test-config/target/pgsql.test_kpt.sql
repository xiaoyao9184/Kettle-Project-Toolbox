-- Database: test_kpt

-- DROP DATABASE test_kpt;

CREATE DATABASE test_kpt
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf-8'
    LC_CTYPE = 'en_US.utf-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

GRANT ALL ON DATABASE test_kpt TO edata_kpt;

GRANT ALL ON DATABASE test_kpt TO postgres;

GRANT TEMPORARY, CONNECT ON DATABASE test_kpt TO PUBLIC;

