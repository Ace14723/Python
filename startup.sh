#!/bin/bash
# Start the Selenium standalone server in the background
/opt/bin/start-xvfb.sh &
/opt/bin/start-selenium-standalone.sh &
# Give it a moment to start
sleep 5
# Start the Flask application
python ./Email_search.py