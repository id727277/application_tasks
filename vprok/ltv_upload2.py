###########################################
## option 2 using pandas and sql_alchemy ##
###########################################

from sqlalchemy import create_engine
from credentials import cred_url
import pandas as pd
from datetime import datetime

# setting up connection
engine = create_engine(cred_url)

schema = 'vprok'
table_name = 'staging_ltv'


def insert_data(path_to_csv):
    """ This function reads csv using pandas and uploads it to the table in db.

    Parameters
    ----------
    path_to_csv : str
        location to the source of csv_file

    Returns
    ----------
        Calculates the number of inserted rows in the table and returns it in formatted string
    """    
    df = pd.read_csv(path_to_csv, parse_dates=['Effective To Date'])
    df['load_date'] = datetime.now()
    df.to_sql(table_name,
                con=engine,
                schema=schema,
                index=False,
                if_exists='replace',
                chunksize=1000)
            
    query = f'select count(1) from {schema}.{table_name}' 
    result = pd.read_sql(query, con=engine)
    print(f"В таблицу {schema}.{table_name} добавлено {result['count'][0]} строк")

insert_data('LTV.csv')
