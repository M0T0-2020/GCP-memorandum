import os
from pathlib import Path

from fastapi import FastAPI

app = FastAPI()


# GCSバケットのファイルを一覧する関数
def list_files():
    bucket_path = Path(os.environ.get("MOUNTPATH", "./"))
    if os.path.exists(bucket_path):
        files = os.listdir(bucket_path)
        return files
    return []


@app.get("/")
def index():
    files = list_files()
    return {"files_in_gcs": files}


@app.post("/upload/{string:str}")
def upload(string: str):
    bucket_path = Path(os.environ.get("MOUNTPATH", "./"))
    with open(bucket_path / f"{string}.txt", "w") as f:
        f.write(string)
        return f"{string}.txt"
