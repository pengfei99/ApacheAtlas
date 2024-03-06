export token=
export entity_id=12ba0da3-4c50-4888-83a0-5c42fc298e27

curl -H "Authorization: Bearer ${token}" -X PUT "https://atlas.lab.sspcloud.fr/api/atlas/admin/purge/" \
  -H "Content-Type: application/json" \
  -d '["$entity_id"]'

#curl -i -X PUT  -H 'Content-Type: application/json' \
#-H 'Accept: application/json' \
#-u admin:admin 'http://localhost:21000/api/atlas/admin/purge/' \
#-d '["3c3c2619-770b-42a4-8498-48e1bfce7296"]'