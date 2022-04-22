from sqlalchemy import create_engine
from pandas import read_sql_query
from time import sleep
from datetime import datetime
import numpy as np
import pandas as pd
import os

USER_NAME = os.getenv('SFU_USERNAME')
PASSWORD = os.getenv('SFU_PASSWORD')

eng_dwh = create_engine(f'vertica+vertica_python://{USER_NAME}:{PASSWORD}@evertica.company.local:8888/dwh')

while True:
    df = read_sql_query(f'SELECT * FROM v_monitor.resource_queues', eng_dwh)
    if df.empty:
        col = ['node_name', 'transaction_id', 'statement_id', 'pool_name',
               'memory_requested_kb', 'priority', 'position_in_queue',
               'queue_entry_timestamp']
        my_null_row = [np.nan, np.nan, np.nan, np.nan, np.nan, np.nan, np.nan, np.nan]
        df = pd.DataFrame([my_null_row], columns=col)

    df['tech_load_ts'] = datetime.now().replace(microsecond=0)
    df.to_sql(name='RESOURCE_QUEUES_LOGS', con=eng_dwh, if_exists='append', schema='SCHEMA_NAME', index=False)
    sleep(300)