import requests
import json
from datetime import date, timedelta

API_KEY = "YOUR_API_KEY"
BASE_URL = "https://api.nasa.gov/neo/rest/v1/feed"

start = date(2025,1,1)
end = start + timedelta(days=6)

all_data = []

while start < date(2025,12,31):
    url = f"{BASE_URL}?start_date={start}&end_date={end}&api_key={API_KEY}"
    response = requests.get(url)
    
    if response.status_code == 200:
        data = response.json()
        
        for date_key, objects in data["near_earth_objects"].items():
            for obj in objects:
                # obj['date'] = date_key 
                all_data.append(obj)
    
    start = end + timedelta(days=1)
    end = start + timedelta(days=6)

    if end > date(2025,12,31):
        end = date(2025,12,31)

with open("nasa_asteroids.json", "w", encoding="utf-8") as f:
    json.dump(all_data, f, indent=2, ensure_ascii=False)
