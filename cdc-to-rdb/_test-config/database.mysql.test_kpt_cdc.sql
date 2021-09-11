--
-- Create user `kpt`
--
CREATE USER 'kpt'@'%' IDENTIFIED WITH mysql_native_password BY 'kpt.123' PASSWORD EXPIRE DEFAULT;
GRANT USAGE ON *.* TO 'kpt'@'%'
WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'kpt'@'%';

--
-- Create db `test_kpt_cdc`
--
CREATE DATABASE test_kpt_cdc
CHARACTER SET utf8
COLLATE utf8_unicode_ci;

--
-- Create table `debezium_types`
--
CREATE TABLE test_kpt_cdc.debezium_types (
  _id varchar(255) NOT NULL DEFAULT '',
  BOOLEAN boolean DEFAULT NULL,
  BOOL bool DEFAULT NULL,
  BIT_1 bit(1) DEFAULT NULL,
  BIT_not_1 bit(2) DEFAULT NULL,
  `TINYINT` tinyint(4) DEFAULT NULL,
  `SMALLINT` smallint(6) DEFAULT NULL,
  `MEDIUMINT` mediumint(9) DEFAULT NULL,
  `INT` int(11) DEFAULT NULL,
  `INTEGER` integer(11) DEFAULT NULL,
  `BIGINT` bigint(20) DEFAULT NULL,
  `REAL` real DEFAULT NULL,
  `FLOAT` float DEFAULT NULL,
  `DOUBLE` double DEFAULT NULL,
  `CHAR` char(20) DEFAULT NULL,
  `VARCHAR` varchar(255) DEFAULT NULL,
  `BINARY` binary(20) DEFAULT NULL,
  `VARBINARY` varbinary(255) DEFAULT NULL,
  `TINYBLOB` tinyblob DEFAULT NULL,
  `TINYTEXT` tinytext DEFAULT NULL,
  `BLOB` blob DEFAULT NULL,
  TEXT text DEFAULT NULL,
  `MEDIUMBLOB` mediumblob DEFAULT NULL,
  `MEDIUMTEXT` mediumtext DEFAULT NULL,
  `LONGBLOB` longblob DEFAULT NULL,
  `LONGTEXT` longtext DEFAULT NULL,
  JSON json DEFAULT NULL,
  ENUM enum ('E1') DEFAULT NULL,
  `SET` set ('S1', 'S2') DEFAULT NULL,
  YEAR year(4) DEFAULT NULL,
  TIMESTAMP timestamp NULL DEFAULT NULL,
  DATE date DEFAULT NULL,
  TIME time DEFAULT NULL,
  DATETIME_3 datetime(3) DEFAULT NULL,
  DATETIME_6 datetime(6) DEFAULT NULL,
  `NUMERIC` numeric(10, 1) DEFAULT NULL,
  `DECIMAL` decimal(10, 2) DEFAULT NULL,
  GEOMETRY geometry DEFAULT NULL,
  LINESTRING linestring DEFAULT NULL,
  POLYGON polygon DEFAULT NULL,
  MULTIPOINT multipoint DEFAULT NULL,
  MULTILINESTRING multilinestring DEFAULT NULL,
  MULTIPOLYGON multipolygon DEFAULT NULL,
  GEOMETRYCOLLECTION geometrycollection DEFAULT NULL,
  PRIMARY KEY (_id)
)
ENGINE = INNODB;