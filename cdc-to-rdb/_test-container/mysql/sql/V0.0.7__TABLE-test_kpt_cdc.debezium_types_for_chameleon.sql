--
-- Create table `debezium_types_for_chameleon`
--
CREATE TABLE test_kpt_cdc.debezium_types_for_chameleon (
  `_id` varchar(255) NOT NULL DEFAULT '',
  `type_BOOLEAN` boolean DEFAULT NULL,
  `type_BOOL` bool DEFAULT NULL,
  `type_BIT_1` bit(1) DEFAULT NULL,
  `type_BIT_not_1` bit(2) DEFAULT NULL,
  `type_TINYINT` tinyint DEFAULT NULL,
  `type_SMALLINT` smallint DEFAULT NULL,
  `type_MEDIUMINT` mediumint DEFAULT NULL,
  `type_INT` int DEFAULT NULL,
  `type_INTEGER` integer DEFAULT NULL,
  `type_BIGINT` bigint DEFAULT NULL,
  `type_REAL` real DEFAULT NULL,
  `type_FLOAT` float DEFAULT NULL,
  `type_DOUBLE` double DEFAULT NULL,
  `type_CHAR` char(20) DEFAULT NULL,
  `type_VARCHAR` varchar(255) DEFAULT NULL,
  `type_BINARY` binary(20) DEFAULT NULL,
  `type_VARBINARY` varbinary(255) DEFAULT NULL,
  `type_TINYBLOB` tinyblob DEFAULT NULL,
  `type_TINYTEXT` tinytext DEFAULT NULL,
  `type_BLOB` blob DEFAULT NULL,
  `type_TEXT` text DEFAULT NULL,
  `type_MEDIUMBLOB` mediumblob DEFAULT NULL,
  `type_MEDIUMTEXT` mediumtext DEFAULT NULL,
  `type_LONGBLOB` longblob DEFAULT NULL,
  `type_LONGTEXT` longtext DEFAULT NULL,
  `type_JSON` json DEFAULT NULL,
  `type_ENUM` enum ('E1') DEFAULT NULL,
  `type_SET` set ('S1', 'S2') DEFAULT NULL,
  `type_YEAR` year DEFAULT NULL,
  `type_TIMESTAMP` timestamp NULL DEFAULT NULL,
  `type_DATE` date DEFAULT NULL,
  `type_TIME` time DEFAULT NULL,
  `type_DATETIME_3` datetime(3) DEFAULT NULL,
  `type_DATETIME_6` datetime(6) DEFAULT NULL,
  `type_NUMERIC` numeric(10, 1) DEFAULT NULL,
  `type_DECIMAL` decimal(10, 2) DEFAULT NULL,
  `type_GEOMETRY` geometry DEFAULT NULL,
  `type_LINESTRING` linestring DEFAULT NULL,
  `type_POLYGON` polygon DEFAULT NULL,
  `type_MULTIPOINT` multipoint DEFAULT NULL,
  `type_MULTILINESTRING` multilinestring DEFAULT NULL,
  `type_MULTIPOLYGON` multipolygon DEFAULT NULL,
  `type_GEOMETRYCOLLECTION` geometrycollection DEFAULT NULL,
  PRIMARY KEY (_id)
)
ENGINE = INNODB;

