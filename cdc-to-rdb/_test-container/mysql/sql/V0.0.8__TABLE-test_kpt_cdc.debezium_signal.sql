--
-- Create table `debezium_signal`
--
CREATE TABLE test_kpt_cdc.debezium_signal (
  id VARCHAR(42),
  type VARCHAR(32) NOT NULL, 
  data VARCHAR(2048) NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB;

