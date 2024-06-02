import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import pandas as pd

def model(dbt, session):
    base_url = "https://www.ahrq.gov"
    url = f"{base_url}/sdoh/data-analytics/sdoh-data.html#download"
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')

    download_dir = "../data/SDOH"
    os.makedirs(download_dir, exist_ok=True)

    for link in soup.select('a[href$=".xlsx"]'):
        file_url = urljoin(base_url, link['href'])
        file_name = file_url.split('/')[-1]
        file_path = os.path.join(download_dir, file_name)

        with open(file_path, 'wb') as file:
            file.write(requests.get(file_url).content)

    return pd.DataFrame({"status": ["SDOH data downloaded successfully."]})
