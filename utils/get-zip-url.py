import sys
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By


def create_driver():
    service = Service(executable_path="/usr/bin/chromedriver")
    options = webdriver.ChromeOptions()
    driver = webdriver.Chrome(service=service, options=options)
    return driver


def get_latest(addon_name):
    url = f"https://www.curseforge.com/wow/addons/{addon_name}/"

    try:
        driver.get(url)
        driver.implicitly_wait(10)
    except:
        print("NULL")
        return

    try:
        recent_files = driver.find_element(By.ID, "recent-files")
        entry = recent_files.find_element(By.CLASS_NAME, "file-card")
        highest = entry.get_attribute("href").split("/")[-1]
    except:
        print("NULL")
        return
    
    driver.get(f"https://www.curseforge.com/wow/addons/{addon_name}/files/{highest}")
    
    try:
        driver.implicitly_wait(10)
        zip_name = driver.find_element(By.CLASS_NAME, "section-file-name").text.replace("File Name", "").strip()
    except:
        print("NULL")
        return
    
    zip_url = f"https://mediafilez.forgecdn.net/files/{highest[:4]}/{highest[4:]}/{zip_name}"
    print(zip_url)



if len(sys.argv) == 2:
    driver = create_driver()
    get_latest(sys.argv[1])
    driver.close()
else:
    print("NULL")
