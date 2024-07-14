# Use Python 3.11 slim as the base image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV JOBS_HOME=/jobs
# Set the working directory
WORKDIR $JOBS_HOME

# Copy requirements file and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the remaining application files
COPY . .

# Run the main Python script
CMD ["python", "main.py"]
