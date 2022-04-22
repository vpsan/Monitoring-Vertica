# Monitoring-Vertica

This is a fast solution for monitoring Vertica:
* transactions queues from v_monitor.resource_queues
* execution time of the EXPORT_OBJECTS query


1. Define the tables with the Data Definition Language (DDL)
2. Put *.py files in a chosen dir
3. Execute batch files from your Windows machine

The result is a stream of EXPORT_OBJECTS() time duration and transactions queues. 

