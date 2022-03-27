from credentials import cred_dict
import psycopg2
import csv
from datetime import datetime

# setting up connection
connection = psycopg2.connect(
    host=cred_dict['host'],
    database=cred_dict['database'],
    user=cred_dict['user'],
    password=cred_dict['password'],
)
schema = 'vprok'
table_name = 'staging_ltv'

# commiting all transactions
connection.autocommit = True

# creating staging table
def create_staging_table(cursor):
    """Takes a cursor and a schema parameters and creates a predefined table in a db"""

    cursor.execute(f"""

        DROP TABLE IF EXISTS {schema}.{table_name};

        CREATE TABLE {schema}.{table_name} (

            "Customer"                        text,
            "State"                           text,
            "Customer Lifetime Value"         decimal,
            "Response"                        text,
            "Coverage"                        text,
            "Education"                       text,
            "Effective To Date"               date,
            "EmploymentStatus"                text,
            "Gender"                          text,
            "Income"                          integer,
            "Location Code"                   text,
            "Marital Status"                  text,
            "Monthly Premium Auto"            integer,
            "Months Since Last Claim"         integer,
            "Months Since Policy Inception"   integer,
            "Number of Open Complaints"       integer,
            "Number of Policies"              integer,
            "Policy Type"                     text,
            "Policy"                          text,
            "Renew Offer Type"                text,
            "Sales Channel"                   text,
            "Total Claim Amount"              decimal,
            "Vehicle Class"                   text,
            "Vehicle Size"                    text,
            "load_date"                       date
        );
    """)

# opening csv file and inserting row by row to the table in db
with connection.cursor() as cursor:
    create_staging_table(cursor)
    with open('LTV.csv', 'r') as file:
        csv_f = csv.reader(file)
        next(csv_f)
        for row in csv_f:
            cursor.execute(f"""
                INSERT INTO {schema}.{table_name} VALUES (
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    to_date(%s, 'm/dd/yy'),
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    current_date
                )""",
                row
            )
    cursor.execute(f"select count(1) from {schema}.{table_name};")
    result = cursor.fetchone()[0]
    print(f"В таблицу {schema}.{table_name} добавлено {result} строк")

    

