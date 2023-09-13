FROM selenium/standalone-chrome

# Set working directory
WORKDIR /app

# Install pip
RUN apt-get update && apt-get install -y python3-pip

# Copy the requirements.txt and install the Python dependencies
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of your Flask app
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["gunicorn", "Email_search:app", "-b", "0.0.0.0:8080"]
