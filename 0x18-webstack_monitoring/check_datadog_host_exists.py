import requests

# DataDog API base URL
DATADOG_API_URL = "https://api.datadoghq.com/api/v1/"

# Your DataDog API key
DATADOG_API_KEY = "04f178090000fa3a355d3d925ad673ca"

# Your DataDog application key
DATADOG_APP_KEY = "925d87a468140f04ff21539639823d90102d216e"

# Hostname to check
HOSTNAME = "422436-web-01"

def check_host_existence(hostname):
    url = f"{DATADOG_API_URL}hosts/{hostname}"
    headers = {
        "Content-Type": "application/json",
        "DD-API-KEY": DATADOG_API_KEY,
        "DD-APPLICATION-KEY": DATADOG_APP_KEY
    }
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return True
    elif response.status_code == 404:
        return False
    else:
        print(f"Failed to check host existence. Status code: {response.status_code}")
        return None

if __name__ == "__main__":
    exists = check_host_existence(HOSTNAME)
    if exists is not None:
        if exists:
            print(f"The host '{HOSTNAME}' exists in DataDog.")
        else:
            print(f"The host '{HOSTNAME}' does not exist in DataDog.")
