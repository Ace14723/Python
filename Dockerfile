# Use a base image with Python
FROM python:3.8-slim-buster

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg2 \
    unzip \
    software-properties-common && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the requirements.txt and install the Python dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your Flask app
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["gunicorn", "email_search:app", "-b", "0.0.0.0:8080"]
