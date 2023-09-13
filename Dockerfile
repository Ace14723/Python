# Use a base image with Python
FROM python:3.8-buster

# Install necessary packages
RUN apt-get update && apt-get install -y wget unzip apt-transport-https curl

# Directly download and install Chrome version 93
RUN curl -O https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_93.0.4577.63.deb && \
    dpkg -i download-chrome.php?file=lnx%2Fchrome64_93.0.4577.63.deb || apt-get install -yf

# Install corresponding Chromedriver for Chrome version 93
RUN wget https://chromedriver.storage.googleapis.com/93.0.4577.63/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/bin/chromedriver && \
    chown root:root /usr/bin/chromedriver && \
    chmod +x /usr/bin/chromedriver

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
