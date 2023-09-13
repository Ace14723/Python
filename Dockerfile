# Use a base image with Python
FROM python:3.8-slim-buster

# Install necessary packages and Chrome
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg2 \
    unzip \
    software-properties-common && \
    curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d'.' -f1) && \
    
    # Adjusted to download Windows version of ChromeDriver
    wget https://chromedriver.storage.googleapis.com/${CHROME_VERSION}.0.0/chromedriver_win32.zip && \
    unzip chromedriver_win32.zip && \
    mv chromedriver.exe /usr/bin/chromedriver && \  # Renamed to chromedriver.exe
    chown root:root /usr/bin/chromedriver && \
    chmod +x /usr/bin/chromedriver && \
    
    apt-get clean && rm -rf /var/lib/apt/lists/* && rm *.zip

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
