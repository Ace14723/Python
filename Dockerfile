# Use an official Python image as the base image
FROM python:3.9-slim
# Set the maintainer label
LABEL maintainer="dpatters@amfam.com"
# Set the working directory in the container
WORKDIR /usr/app
# Copy the current directory contents into the container at /usr/app
COPY . .
# Install Python libraries
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
# Set Flask-specific environment variables
ENV FLASK_APP=Email_search.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
# Expose port
EXPOSE 5000
# Define the command to run the app using CMD
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]
