# Pythonベースイメージ
FROM python:3.9-slim

# 作業ディレクトリ
WORKDIR /app

# アプリケーションのコピー
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

# アプリケーションの起動
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]

# uvicorn main:app --host 0.0.0.0 --port 8000


# docker build . -t gcs_fuse_test         
# docker run -p 8080:8080 -t gcs_fuse_test

# gcloud builds submit . -t us-central1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME