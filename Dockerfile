FROM selenium/standalone-chrome:latest

USER root

# Set the working directory in the container
WORKDIR /usr/app

# Copy the current directory contents into the container at /usr/app
COPY . .

# Install Python and other dependencies
RUN apt-get update && apt-get install -y python3 python3-pip

# Install Python libraries
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Set Flask-specific environment variables
ENV FLASK_APP=Email_search.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

# Expose ports
EXPOSE 5000

# Command to run the Flask app
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]
