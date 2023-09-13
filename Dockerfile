# Use a base image with Python
FROM python:3.8-slim-buster

# Install necessary packages
RUN apt-get update && apt-get install -y wget unzip apt-transport-https

# Install Chrome version 93
RUN wget https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_93.0.4577.63-1_amd64.deb
RUN apt install -y ./google-chrome-stable_93.0.4577.63-1_amd64.deb

# Install Chromedriver for Chrome version 93
RUN wget https://chromedriver.storage.googleapis.com/93.0.4577.63/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver

# Set the display port to avoid crash
ENV DISPLAY=:99

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
CMD ["gunicorn", "Email_search:app", "-b", "0.0.0.0:8080"]
