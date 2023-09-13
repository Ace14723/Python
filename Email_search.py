from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from flask_cors import CORS
from flask import Flask, render_template
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import os

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return render_template('Home.html')

@app.route('/search_email', methods=['POST'])
def search_email():
    email = request.json['email']
    
    # Use Remote WebDriver to connect to the Selenium standalone container
    driver = webdriver.Remote(
        command_executor="http://localhost:4444/wd/hub",
        desired_capabilities=DesiredCapabilities.CHROME
    )

    driver.get('https://pplsearch.amfam.com/pplsearch/')
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.ID, "optAttribute")))

    # Select the option for E-mail
    select_element = driver.find_element(By.ID, "optAttribute")
    select_element.click()
    email_option = driver.find_element(By.XPATH, "//option[@value='email']")
    email_option.click()

    # Input the email address
    input_element = driver.find_element(By.ID, "searchFor")
    input_element.click()
    input_element.send_keys(email)

    # Click the search button
    search_button = driver.find_element(By.XPATH, "//*[@id='idSearchOptions']/a[1]/img[1]")
    search_button.click()

    current_window = driver.current_window_handle
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, '//*[@id="page_content"]/table[3]/tbody[1]/tr[4]/td[2]/a[1]')))

    link_element = driver.find_element(By.XPATH, '//*[@id="page_content"]/table[3]/tbody[1]/tr[4]/td[2]/a[1]')
    link_element.click()
    
    # Switch to the new tab
    for window_handle in driver.window_handles:
        if window_handle != current_window:
            driver.switch_to.window(window_handle)
            break

    current_url = driver.current_url
    print(f'Code successfully completed: {current_url}')
    # Closing the browser
    driver.quit()

    # Return results
    return jsonify({"url": current_url})

@app.route('/search_PID', methods=['POST'])
def search_PID():

    producerID = request.json['producerID']

    # Use Remote WebDriver to connect to the Selenium standalone container
    driver = webdriver.Remote(
        command_executor="http://localhost:4444/wd/hub",
        desired_capabilities=DesiredCapabilities.CHROME
    )


    driver.get('https://pplsearch.amfam.com/pplsearch/')
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.ID, "optAttribute")))

    # Select the option for PID
    select_element = driver.find_element(By.ID, "optAttribute")
    select_element.click()
    email_option = driver.find_element(By.XPATH, "//option[@value='producerid']")
    email_option.click()

    # Input the email address
    input_element = driver.find_element(By.ID, "searchFor")
    input_element.click()
    input_element.send_keys(producerID)

    # Click the search button
    search_button = driver.find_element(By.XPATH, "//*[@id='idSearchOptions']/a[1]/img[1]")
    search_button.click()

    current_window = driver.current_window_handle
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, '//*[@id="page_content"]/table[3]/tbody[1]/tr[4]/td[2]/a[1]')))

    link_element = driver.find_element(By.XPATH, '//*[@id="page_content"]/table[3]/tbody[1]/tr[4]/td[2]/a[1]')
    link_element.click()
    
    # Switch to the new tab
    for window_handle in driver.window_handles:
        if window_handle != current_window:
            driver.switch_to.window(window_handle)
            break

    current_url = driver.current_url
    print(f'Code successfully completed: {current_url}')
    # Closing the browser
    driver.quit()

    # Return results
    return jsonify({"url": current_url})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

