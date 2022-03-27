from sqlalchemy import create_engine
from credentials import cred_url
import pandas as pd

# est. connection
engine = create_engine(cred_url)
schema_name = 'komarpp'
tables_list = ['sale', 'product', 'service', 'seller', 'department']


def insert_data():
    """This function iterates over each sheet of the source file and inserts data to already created tables in schema."""
    
    sheets_list = list(range(5)) # 
    tables_list = ['sale', 'product', 'service', 'seller', 'department'] # names of tables in db
    for sheet_num in sheets_list:
        df = pd.read_excel('/home/pasha/Projects/sql-assignment/Исходные данные.xlsx',
                             sheet_name=sheet_num,
                             engine='openpyxl')
        table_name = tables_list[sheet_num] # assigning table_name 

        df.to_sql(table_name,
                  con=engine,
                  schema=schema_name,
                  index=False,
                  if_exists='append')  # sending data to table
              
        query = f'select count(1) from {schema_name}.{table_name}' 
        result = pd.read_sql(query, con=engine)
        print(f"В таблице {table_name} добавлено {result['count'][0]} строк") # checking if row count has changed


insert_data()



