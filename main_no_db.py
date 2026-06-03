from fastapi import FastAPI
from product_model import Product

app = FastAPI()

@app.get('/')
def greeting():
    return "Hello from Local server no DB"


productsList = [
    Product(id=1, name= "watch", des= "gold watch", price= 2222.9),
    Product(id=2, name="Tshirt", des= "demin tshirt", price=300),
    Product(id=3, name="Flower", des= "rose flower", price=45.99),
]

@app.get("/allProducts")
def getAllProducts():
    return productsList

@app.get("/productById")
def fetchProductById(id: int):
    for product in productsList:
        if(product.id == id):
            return product
    
    return "No product found"

@app.get("/product/{id:int}")
def fetchProductById(id):
    for product in productsList:
        if(product.id == id):
            return product
    
    return "No product found ID in url"


@app.post("/product")
def addProduct(product: Product):
    productsList.append(product)
    return "product added"


@app.patch("/product")
def updateProduct(id:int, product: Product):
    for i in range(len(productsList)):
        if(productsList[i].id == id):
            productsList[i] = product
            return "product updated"
    
    return "no matching product found"


@app.delete("/product")
def deleteProduct(id:int):
    for i in range(len(productsList)):
        if(productsList[i].id == id):
            del productsList[i]
            return "product deleted"
    
    return "no matching product found"