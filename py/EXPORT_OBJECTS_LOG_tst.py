from sqlalchemy import create_engine
from pandas import read_sql_query
from time import sleep
from datetime import datetime
import pandas as pd
import os

USER_NAME = os.getenv('SFU_USERNAME')
PASSWORD = os.getenv('SFU_PASSWORD')

eng_tst = create_engine(f'vertica+vertica_python://{USER_NAME}:{PASSWORD}@vertica-tst.company.local:8888/testdb')

tst_schema_tablea_name_lst = ['SCHEMA_NAME_1.TABLE_1', 'SCHEMA_NAME_2.TABLE_2']

while True:
    df_list = []
    for schema_table in tst_schema_tablea_name_lst:
        query_start_ts = datetime.now().replace(microsecond=0)
        df = read_sql_query(f'''SELECT EXPORT_OBJECTS('', '{schema_table}')''', eng_tst)
        query_end_ts = datetime.now().replace(microsecond=0)

        df['schema_tablea_name'] = schema_table
        df['query_start_ts'] = query_start_ts
        df['query_end_ts'] = query_end_ts
        df = df.rename(columns={'EXPORT_OBJECTS':'export_objects_result'})
        df_list.append(df)

    df_to_push = pd.concat(df_list)
    df_to_push['tech_load_ts'] = datetime.now().replace(microsecond=0)
    df_to_push.to_sql(name='EXPORT_OBJECTS_LOG', con=eng_tst, if_exists='append', schema='SCHEMA_NAME', index=False)
    sleep(900)