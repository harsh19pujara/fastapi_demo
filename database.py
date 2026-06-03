from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

db_url = "postgresql://postgres:harsh1972@127.0.0.1:5432/harshdb"
engine = create_engine(db_url)
session = sessionmaker(autoflush = False, bind = engine)