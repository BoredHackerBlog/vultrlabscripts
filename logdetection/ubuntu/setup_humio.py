import requests
from time import sleep

while True:
    try:
        if requests.get("http://localhost:8080").status_code == 200:
            break
        else:
            sleep(5)
    except:
        sleep(5)


headers = {
    'Accept': 'application/json, multipart/mixed',
    'Accept-Language': 'en-US,en;q=0.5',
    'content-type': 'application/json',
    'Authorization': 'Bearer null',
    'Origin': 'http://localhost:8080',
    'Connection': 'keep-alive',
}

data = '{"query":"mutation {\\n enableFeature(feature: CustomIngestTokens)\\n}\\n","variables":null}'

response = requests.post('http://localhost:8080/graphql', headers=headers, data=data)

print(response.json())

data = '{"query":"mutation {\\n addIngestToken(\\n repositoryName: \\"sandbox\\",\\n name: \\"MyIngestToken\\",\\n customToken: \\"abcdabcdabcdabcd\\",\\n ) {\\n ingestToken {\\n name\\n token\\n }\\n }\\n}\\n","variables":null}'

response = requests.post('http://localhost:8080/graphql', headers=headers, data=data)

print(response.json())

quit()