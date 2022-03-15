## Load s3 example

# example of localhost and user password
curl -u admin:admin -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' \
"http://localhost:21000/api/atlas/v2/entity" -d "@./load_s3_bucket.json"


## Load hive table example

# example of remote and oidc
# search hive table
curl -H "Authorization: Bearer ${token}" -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' \
 "https://atlas.lab.sspcloud.fr/api/atlas/v2/search/basic" -d "@./search_hive_table.json"

# show hive table details
curl -H "Authorization: Bearer ${token}" -H  "accept: application/json" \
-X GET "https://atlas.lab.sspcloud.fr/api/atlas/v2/entity/guid/e57ce313-ef6c-4ada-b40d-697b693893f6?ignoreRelationships=true&minExtInfo=true"

# show hive db details
curl -H "Authorization: Bearer ${token}" -H  "accept: application/json" \
-X GET "https://atlas.lab.sspcloud.fr/api/atlas/v2/entity/guid/a5201924-87f7-4c3c-aab4-b8086917b108?ignoreRelationships=true&minExtInfo=true"


# get hive db typedef
curl -H "Authorization: Bearer ${token}" -H  "accept: application/json" \
-X GET "https://atlas.lab.sspcloud.fr/api/atlas/v2/types/typedef/name/hive_db" -H  "accept: application/json"

# load hive db
curl -H "Authorization: Bearer ${token}" -X POST -H "Content-Type: application/json" \
-H "Accept: application/json" "https://atlas.lab.sspcloud.fr/api/atlas/v2/entity" -d "@./load_hive_db.json"

# load hive table
curl -H "Authorization: Bearer ${token}" -X POST -H "Content-Type: application/json" \
-H "Accept: application/json" "https://atlas.lab.sspcloud.fr/api/atlas/v2/entity" -d "@./load_hive_table.json"

