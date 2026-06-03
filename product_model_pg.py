from sqlalchemy import Column, Integer, String, Float
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
class ProductPG(Base):
    __tablename__ = 'product'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    des = Column(String)
    price = Column(Float)

