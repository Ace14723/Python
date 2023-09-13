# Use a base image with Python
FROM python:3.8-slim-buster

# Install dependencies for Microsoft Edge and Microsoft Edge Driver
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    unzip \
    curl \
    software-properties-common

# Install Microsoft Edge
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/debian/10/prod buster main" && \
    apt-get update && \
    apt-get install -y microsoft-edge-stable

# Fetch the latest stable version of Microsoft Edge Driver
RUN DRIVER_VERSION=$(curl -s "https://msedgewebdriverstorage.z22.web.core.windows.net/?restype=container&comp=list" | grep -oPm1 "(?<=<Name>edgedriver_)[^<]+" | sort -Vr | head -1) && \
    wget "https://msedgedriver.azureedge.net/$DRIVER_VERSION/edgedriver_linux64.zip" && \
    unzip edgedriver_linux64.zip && \
    mv msedgedriver /usr/bin/msedgedriver && \
    chown root:root /usr/bin/msedgedriver && \
    chmod +x /usr/bin/msedgedriver

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm *.zip

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
