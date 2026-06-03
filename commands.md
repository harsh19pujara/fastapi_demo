To run a FastAPI application using Uvicorn, execute the following command in your terminal:bash

=> "uvicorn main:app --reload"

Use code with caution.Command Breakdown

- main: The name of the Python file (main.py) containing your application.

- app: The specific variable inside that file where you assigned the FastAPI() instance (e.g., app = FastAPI()).

- --reload: An optional flag for development that automatically restarts the server every time you save changes to your code.


** After server is live by above command, look for 'http://localhost:8000/' this url in web browser to see the result, and for docs click on this link for exploring API: 'http://localhost:8000/docs' **


=> ctrl + c : close the server running in terminal

