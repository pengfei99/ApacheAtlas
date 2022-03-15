## There are many auth mode


# Mode 1: login and password
# You need to replace the login, pwd, hostname, and search query for your search request

curl -u login:pwd -X POST -H "Content-Type: application/json" -H "Accept: application/json" \
"http://localhost:21000/api/atlas/v2/search/basic" -d "@./search.json"

# Mode 2: OIDC
curl -H "Authorization: Bearer ${token}" \
-X POST -H "Content-Type: application/json" -H "Accept: application/json" "http://localhost:21000/api/atlas/v2/search/basic" \
-d "@./search.json"




export token=


