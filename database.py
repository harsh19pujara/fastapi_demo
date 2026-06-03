from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# db_url = "postgresql://postgres:harsh1972@127.0.0.1:5432/harshdb"
db_url = "postgresql://demo_postgres_yfjp_user:GGJy2BDT4t8YZKd438IOJrnDQaiu6HEd@dpg-d8g7akog4nts73bdbpdg-a/demo_postgres_yfjp"
engine = create_engine(db_url)
session = sessionmaker(autoflush = False, bind = engine)