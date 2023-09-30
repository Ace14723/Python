# Use an official Selenium Python image as the base image
FROM selenium/standalone-chrome:latest
# Set the maintainer label
LABEL maintainer="dpatters@amfam.com"
# Set the working directory in the container
WORKDIR /usr/app
# Copy the current directory contents into the container at /usr/app
COPY . .
# Install system dependencies
USER root
RUN apt-get update && apt-get install -y python3 python3-pip
# Install Python libraries
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
# Switch back to the default user
USER seluser
# Set Flask-specific environment variables
ENV FLASK_APP=Email_search.py
ENV FLASK_RUN_HOST=0.0.0.0
# Expose port
EXPOSE 8080
# Define the command to run the app using CMD
CMD /opt/bin/start-xvfb.sh && /opt/bin/start-selenium-standalone.sh && sleep 5 && python3 ./Email_search.py












