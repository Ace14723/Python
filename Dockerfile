# Use the official Python image for Windows
FROM python:3.8-windowsservercore

# Download and install Google Chrome
RUN Invoke-WebRequest -Uri https://dl.google.com/chrome/install/latest/chrome_installer.exe -OutFile C:\chrome_installer.exe
RUN Start-Process -FilePath C:\chrome_installer.exe -ArgumentList "/install", "/silent" -Wait
RUN Remove-Item C:\chrome_installer.exe

# Download and install Chrome WebDriver
RUN Invoke-WebRequest -Uri https://chromedriver.storage.googleapis.com/LATEST_RELEASE -OutFile C:\chromedriver_version.txt
RUN $chromeDriverVersion = Get-Content -Path C:\chromedriver_version.txt
RUN Invoke-WebRequest -Uri "https://chromedriver.storage.googleapis.com/$chromeDriverVersion/chromedriver_win32.zip" -OutFile C:\chromedriver.zip
RUN Expand-Archive -Path C:\chromedriver.zip -DestinationPath C:\chromedriver
RUN Remove-Item C:\chromedriver.zip
RUN Move-Item -Path C:\chromedriver\chromedriver.exe -Destination C:\chromedriver.exe
RUN Remove-Item -Path C:\chromedriver -Force

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
