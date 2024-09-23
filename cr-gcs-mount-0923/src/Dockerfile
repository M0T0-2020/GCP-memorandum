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
