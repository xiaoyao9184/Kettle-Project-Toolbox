INSERT INTO test_kpt_cdc.debezium_signal (id, type, data) 
VALUES(UUID(), 'execute-snapshot', '{"data-collections": ["test_kpt_cdc.debezium_types"]}');