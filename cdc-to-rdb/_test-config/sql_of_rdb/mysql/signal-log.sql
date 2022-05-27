INSERT INTO test_kpt_cdc.debezium_signal (id, type, data) 
VALUES(UUID(), 'log', '{"message": "Signal message at offset {}"}');