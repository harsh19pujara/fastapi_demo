from fastapi import Depends
from fastapi import FastAPI
from sqlalchemy.orm import Session
from product_model_pg import ProductPG, Base
from database import session, engine
from product_model import Product


app = FastAPI()

Base.metadata.create_all(bind = engine)

@app.get('/')
def greeting():
    return "Hello from Local server"


productsList = [
    Product(id=1, name= "watch", des= "gold watch", price= 2222.9),
    Product(id=2, name="Tshirt", des= "demin tshirt", price=300),
    Product(id=3, name="Flower", des= "rose flower", price=45.99),
]


def uploadProductList():
    db = session()
    count = db.query(ProductPG).count()
    print(count)
    if count == 0 :
        for product in productsList:
            db.add(ProductPG(**product.model_dump()))

        db.commit()
        print("added")
    else :
        print("all products already added")

uploadProductList()


def getDB() :
    db = session()
    try: 
        yield db
    finally : 
        db.close()

@app.get("/allProducts")
def getAllProducts(db: Session = Depends(getDB)):
    addData = db.query(ProductPG).all()
    
    return addData

@app.get("/productById")
def fetchProductById(userid: int, db : Session = Depends(getDB)):

    data = db.query(ProductPG).filter_by(id = userid).first()

    if data:
        return data
    return "No user found"


@app.post("/product")
def addProduct(product: Product, db: Session = Depends(getDB)):
    db.add(ProductPG(**product.model_dump()))
    db.commit()
    return "product added"


@app.patch("/product")
def updateProduct(userid:int, product: Product, db: Session = Depends(getDB)):
    data = db.query(ProductPG).filter_by(id = userid).first()

    if data:
        conv = ProductPG(**product.model_dump())
        data.name = conv.name
        data.des = conv.des
        data.price = conv.price

        db.commit()
        return "Data updated"

    return "no matching product found"


@app.delete("/product")
def deleteProduct(userid:int, db: Session = Depends(getDB)):
    data = db.query(ProductPG).filter_by(id = userid).first()
    
    if data :
        db.delete(data)
        db.commit()
        return "Data Delteted"

    return "no matching product found"