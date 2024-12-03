from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

@app.get("/data/{file_id}")
def read_file(file_id, line : str = None):
    if line is None:
        line = 1
    data_file = open("data_files/" + str(file_id) + ".txt", "r")
    all_data = data_file.read()
    return all_data.split("\n")[int(line) - 1]