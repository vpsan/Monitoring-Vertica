DROP TABLE IF EXISTS SCHEMA_NAME.EXPORT_OBJECTS_LOG;


CREATE TABLE SCHEMA_NAME.EXPORT_OBJECTS_LOG
(
    export_objects_result varchar(64000),
    schema_tablea_name varchar(128),
    query_start_ts timestamp,
    query_end_ts timestamp,
    tech_load_ts timestamp(6) DEFAULT statement_timestamp()
);


CREATE PROJECTION SCHEMA_NAME.EXPORT_OBJECTS_LOG /*+createtype(L)*/ 
(
 export_objects_result,
 schema_tablea_name,
 query_start_ts,
 query_end_ts,
 tech_load_ts
)
AS
 SELECT EXPORT_OBJECTS_LOG.export_objects_result,
        EXPORT_OBJECTS_LOG.schema_tablea_name,
        EXPORT_OBJECTS_LOG.query_start_ts,
        EXPORT_OBJECTS_LOG.query_end_ts,
        EXPORT_OBJECTS_LOG.tech_load_ts
 FROM SCHEMA_NAME.EXPORT_OBJECTS_LOG
 ORDER BY EXPORT_OBJECTS_LOG.export_objects_result,
          EXPORT_OBJECTS_LOG.schema_tablea_name,
          EXPORT_OBJECTS_LOG.query_start_ts,
          EXPORT_OBJECTS_LOG.query_end_ts,
          EXPORT_OBJECTS_LOG.tech_load_ts
SEGMENTED BY hash(EXPORT_OBJECTS_LOG.query_start_ts, EXPORT_OBJECTS_LOG.query_end_ts, EXPORT_OBJECTS_LOG.tech_load_ts, EXPORT_OBJECTS_LOG.schema_tablea_name, EXPORT_OBJECTS_LOG.export_objects_result) ALL NODES KSAFE 1;


SELECT MARK_DESIGN_KSAFE(1);
