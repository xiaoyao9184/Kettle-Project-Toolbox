--
-- Create table `no_key`
--
CREATE TABLE test_kpt_cdc.no_key (
  not_key varchar(50) NOT NULL DEFAULT '',
  `number` int(11) DEFAULT NULL
)
ENGINE = INNODB;

