DROP TABLE IF EXISTS SCHEMA_NAME.RESOURCE_QUEUES_LOGS;


CREATE TABLE SCHEMA_NAME.RESOURCE_QUEUES_LOGS
(
    node_name varchar(128),
    transaction_id int,
    statement_id int,
    pool_name varchar(128),
    memory_requested_kb int,
    priority int,
    position_in_queue int,
    queue_entry_timestamp timestamp,
    tech_load_ts timestamp(6) DEFAULT statement_timestamp()
);


CREATE PROJECTION SCHEMA_NAME.RESOURCE_QUEUES_LOGS /*+createtype(L)*/ 
(
 node_name,
 transaction_id,
 statement_id,
 pool_name,
 memory_requested_kb,
 priority,
 position_in_queue,
 queue_entry_timestamp,
 tech_load_ts
)
AS
 SELECT RESOURCE_QUEUES_LOGS.node_name,
        RESOURCE_QUEUES_LOGS.transaction_id,
        RESOURCE_QUEUES_LOGS.statement_id,
        RESOURCE_QUEUES_LOGS.pool_name,
        RESOURCE_QUEUES_LOGS.memory_requested_kb,
        RESOURCE_QUEUES_LOGS.priority,
        RESOURCE_QUEUES_LOGS.position_in_queue,
        RESOURCE_QUEUES_LOGS.queue_entry_timestamp,
        RESOURCE_QUEUES_LOGS.tech_load_ts
 FROM SCHEMA_NAME.RESOURCE_QUEUES_LOGS
 ORDER BY RESOURCE_QUEUES_LOGS.node_name,
          RESOURCE_QUEUES_LOGS.transaction_id,
          RESOURCE_QUEUES_LOGS.statement_id,
          RESOURCE_QUEUES_LOGS.pool_name,
          RESOURCE_QUEUES_LOGS.memory_requested_kb,
          RESOURCE_QUEUES_LOGS.priority,
          RESOURCE_QUEUES_LOGS.position_in_queue,
          RESOURCE_QUEUES_LOGS.queue_entry_timestamp
SEGMENTED BY hash(RESOURCE_QUEUES_LOGS.transaction_id, RESOURCE_QUEUES_LOGS.statement_id, RESOURCE_QUEUES_LOGS.memory_requested_kb, RESOURCE_QUEUES_LOGS.priority, RESOURCE_QUEUES_LOGS.position_in_queue, RESOURCE_QUEUES_LOGS.queue_entry_timestamp, RESOURCE_QUEUES_LOGS.tech_load_ts, RESOURCE_QUEUES_LOGS.node_name) ALL NODES KSAFE 1;


SELECT MARK_DESIGN_KSAFE(1);
