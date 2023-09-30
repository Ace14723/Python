# Use selenium/standalone-chrome as the base image
FROM selenium/standalone-chrome
# Set the working directory in the container
WORKDIR /usr/src/app
# Copy the current directory contents into the container at /usr/src/app
COPY . .
# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
# Set Python 3 as the default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
# Install Python libraries
RUN pip install --no-cache-dir Flask-Cors
RUN pip install --no-cache-dir -r requirements.txt
# Expose port 8080 for the Flask app to listen on
EXPOSE 8080
# Command to run the application
CMD ["python", "./Email_search.py"]
