FROM python:3.11-slim

ENV PYTHONUNBUFFERED True

ENV APP_HOME /app
WORKDIR ${APP_HOME}

COPY . ./

RUN pip install -r requirements.txt

# VOLUME [ "/app/langflow-storage" ] GCP のストレージをマウントするので必要ない

EXPOSE 7860

CMD ["python3", "-m", "langflow", "run", "--host", "0.0.0.0", "--port", "7860", "--env-file", "./.env"]