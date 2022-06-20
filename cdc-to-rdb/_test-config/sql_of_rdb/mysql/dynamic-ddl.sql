

CREATE TABLE test_kpt_cdc.dynamic_ddl (
  `_id` varchar(255) NOT NULL DEFAULT '',
  `time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (_id)
)
ENGINE = INNODB;

INSERT INTO test_kpt_cdc.dynamic_ddl 
(_id, `time`) VALUES
(UUID(), NOW());

DROP TABLE test_kpt_cdc.dynamic_ddl;