# Use a base image with Python
FROM python:3.8-slim-buster

# Install dependencies for Chrome and ChromeDriver
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Get the Chrome version and store it in a temporary file
RUN dpkg -l | grep google-chrome-stable | awk '{print $3}' > /tmp/chrome_version.txt

# Download ChromeDriver for the specific Chrome version and set it up
RUN CHROME_VERSION=$(cat /tmp/chrome_version.txt) \
    && wget "https://chromedriver.storage.googleapis.com/$CHROME_VERSION/chromedriver_linux64.zip" \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chown root:root /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm chromedriver_linux64.zip

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
