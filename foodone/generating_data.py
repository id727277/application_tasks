from datetime import datetime, timedelta
from faker import Faker
from collections import defaultdict
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.schema import CreateSchema, DropSchema
from credentials import cred_url


fake = Faker()


faked_wh = defaultdict(list)
faked_tr = defaultdict(list)
faked_pr = defaultdict(list)
faked_or = defaultdict(list)


def generate_warehouses(size=30):

    for _ in range(size):
        faked_wh['warehouse_id'].append(fake.bothify(text='####'))
        faked_wh['warehouse_name'].append(fake.city())

    return pd.DataFrame(faked_wh)


def generate_transactions(warehouse_ids, size=5000):

    for _ in range(size):
        faked_tr['order_id'].append(fake.bothify(text='????-########'))
        faked_tr['created_at'].append(fake.date_time_between(start_date=datetime(2022,1,1, 00,00,00)))
        faked_tr['picked_at'].append(fake.date_time_between_dates(datetime_start=faked_tr['created_at'][_], datetime_end=faked_tr['created_at'][_]+timedelta(minutes=10)))
        faked_tr['delivered_at'].append(fake.date_time_between_dates(datetime_start=faked_tr['picked_at'][_], datetime_end=faked_tr['picked_at'][_]+timedelta(minutes=15)))
        faked_tr['user_id'].append(fake.uuid4())
        faked_tr['total'].append(fake.randomize_nb_elements(number = 300, min=200, max=500))
        faked_tr['warehouse_id'].append(fake.random_element(elements=warehouse_ids))

    return pd.DataFrame(faked_tr)

def generating_products():
    
    file = "work_test_tasks/foodone/Sample - Superstore.xls"
    pr_source = pd.read_excel(file, usecols="Q")
    pr_source.drop_duplicates(inplace=True)

    for _ in range(len(pr_source)):
        faked_pr['product_id'].append(1000 + _)
        faked_pr['product_name'].append(fake.random_element(elements=pr_source['Product Name']))
        faked_pr['cost'].append(fake.randomize_nb_elements(number = 50, min=20, max= 70))

    return pd.DataFrame(faked_pr)


def generate_orders(orders, products):
    for _ in range(len(orders)):
        faked_or['id'].append(100 + _)
        faked_or['order_id'].append(fake.random_element(orders))
        faked_or['product_id'].append(fake.random_element(products))
        faked_or['qty'].append(fake.random_number(digits=1, fix_len=True))
        faked_or['price_per_unit'].append(fake.randomize_nb_elements(number=30, min=5, max=50))

    return pd.DataFrame(faked_or)





def insert_data(dfs):
    
    engine = create_engine(cred_url)

    my_schema = 'foodone'
    engine.execute(DropSchema(my_schema, cascade=True))
    engine.execute(CreateSchema(my_schema))
    
    tables = ['warehouse', 'transactions', 'products', 'order_products']

    for _ in range(len(tables)):
        dfs[_].to_sql(tables[_], con=engine, schema=my_schema, index=False, if_exists='replace', chunksize=1000)
        query = f'select count(1) from {my_schema}.{tables[_]}' 
        result = pd.read_sql(query, con=engine)
        print(f"В таблицу {my_schema}.{tables[_]} добавлено {result['count'][0]} строк")


df_warehouse = generate_warehouses(30)
df_transactions = generate_transactions(df_warehouse['warehouse_id'], 10000)
df_products = generating_products()
df_orders = generate_orders(df_transactions['order_id'], df_products['product_id'])

insert_data([df_warehouse, df_transactions,  df_products, df_orders])