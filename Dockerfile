# Use an official Python image as the base image
FROM python:3.9

# Set the maintainer label
LABEL maintainer="dpatters@amfam.com"

# Set the working directory in the container
WORKDIR /usr/app

# Update and upgrade
RUN apt-get update && apt-get upgrade -y

# Install essential tools
RUN apt-get install -y wget unzip curl

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver
RUN wget -N http://chromedriver.storage.googleapis.com/$(curl http://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/local/bin/
RUN chmod +x /usr/local/bin/chromedriver
RUN rm chromedriver_linux64.zip

# Clean up
RUN apt-get purge --auto-remove -y curl unzip wget
RUN rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /usr/app
COPY . .

# Install Python libraries
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set Flask-specific environment variables
ENV FLASK_APP=Email_search.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=4444
ENV CHROME_BIN=/usr/bin/google-chrome-stable

# Expose port
EXPOSE 4444

# Define the command to run the app using CMD
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]
