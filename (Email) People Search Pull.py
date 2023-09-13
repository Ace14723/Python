from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

@app.route('/search_email', methods=['POST'])
def search_email():
    email = request.json['email']
    # Set up Chrome options
    chrome_options = Options()
    chrome_options.add_argument("--headless")  # Enable headless mode
    chrome_options.add_argument("--log-level=3")  # Minimize logging

    # Initialize the Selenium driver with options
    driver = webdriver.Chrome(options=chrome_options)
    
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

    # Set up Chrome options
    chrome_options = Options()
    chrome_options.add_argument("--headless")  # Enable headless mode
    chrome_options.add_argument("--log-level=3")  # Minimize logging

    # Initialize the Selenium driver with options
    driver = webdriver.Chrome(executable_path=r"C:\Users\DRP046\OneDrive - American Family (1)\Desktop\Python Scripts\chromedriver.exe", options=chrome_options)

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

