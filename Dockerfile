# Use the selenium base image with standalone chrome
FROM selenium/standalone-chrome
# Set the working directory
WORKDIR /usr/app
# Copy the current directory contents into the container
COPY . .
# Ensure the startup script is executable
RUN chmod +x /usr/app/startup.sh
# Install system dependencies
USER root
RUN apt-get update && apt-get install -y python3 python3-pip
# Install Python libraries
RUN pip3 install --no-cache-dir -r requirements.txt
# Use the custom startup script as the default command
CMD ["/usr/app/startup.sh"]
