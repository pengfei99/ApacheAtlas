# Load entity to Atlas

There are too many Atlas entities that you can upload to Atlas via rest api. So we can't provide templates for all these
entities. The better solution is to give you a procedure to how to build template by your self.

Often the entity has hierarchy dependencies, such as hive_db has many hive_tables, and hive_tables have many
hive_columns. We need to follow this nature hierarchy to create entities in orders (e.g. hive_db, hive_table,
hive_columns).

## Step1 Create an entity example

Atlas provides a web interface that allows you to create any entity that Atlas supports. So use it to create an example

## Step2 Get the entity detail

You need to get the uid of the entity to show the entity details. So First, find the entity uid by using search api.

The below command will search all hive_table in Atlas, note it takes a json file as search filter.

```shell
curl -H "Authorization: Bearer ${token}" -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' \
 "https://atlas.lab.sspcloud.fr/api/atlas/v2/search/basic" -d "@./search_hive_table.json"
 
# Don't forget export your oidc token
export token=<your oidc token>
```

The search_hive_table.json looks like this

```json
{
  "typeName": "hive_table",
  "excludeDeletedEntities": true,
  "classification": "",
  "query": "",
  "limit": 25,
  "offset": 0,
  "tagFilters": null,
  "attributes": [
    ""
  ]
}
```

After running above query, you should see below json response:

```json
{
  "queryType": "BASIC",
  "searchParameters": {
    "query": "",
    "typeName": "hive_table",
    "classification": "",
    "excludeDeletedEntities": true,
    "includeClassificationAttributes": false,
    "includeSubTypes": true,
    "includeSubClassifications": true,
    "limit": 25,
    "offset": 0,
    "attributes": [
      ""
    ]
  },
  "queryText": "",
  "entities": [
    {
      "typeName": "hive_table",
      "attributes": {
        "createTime": 1647212400000,
        "qualifiedName": "default.students",
        "name": "students"
      },
      "guid": "e57ce313-ef6c-4ada-b40d-697b693893f6",
      "status": "ACTIVE",
      "displayText": "students",
      "classificationNames": [],
      "meaningNames": [],
      "meanings": [],
      "isIncomplete": false,
      "labels": []
    }
  ],
  "approximateCount": 1
}
```

You can notice, the result is just a summary of the hive_table, for more details about this hive, you need to use the
guid(e57ce313-ef6c-4ada-b40d-697b693893f6).

Below command will get details of any entity in Atlas via its guid.

```shell
curl -H "Authorization: Bearer ${token}" -H  "accept: application/json" \
-X GET "https://atlas.lab.sspcloud.fr/api/atlas/v2/entity/guid/e57ce313-ef6c-4ada-b40d-697b693893f6?ignoreRelationships=true&minExtInfo=true"
```

Note the two parameters:

- ignoreRelationships=true: means don't get related entity info. For example, the hive_table belons to a hive_db, and
  has hive_tables. With this option, you will ignore all these entities
- minExtInfo=true: Reduce output details

```json
{
  "referredEntities": {},
  "entity": {
    "typeName": "hive_table",
    "attributes": {
      "owner": null,
      "temporary": false,
      "lastAccessTime": 1647212400000,
      "aliases": [],
      "replicatedTo": [],
      "userDescription": null,
      "replicatedFrom": [],
      "qualifiedName": "default.students",
      "displayName": null,
      "description": null,
      "viewExpandedText": null,
      "tableType": null,
      "createTime": 1647212400000,
      "name": "students",
      "comment": null,
      "parameters": null,
      "retention": 0,
      "viewOriginalText": null
    },
    "guid": "e57ce313-ef6c-4ada-b40d-697b693893f6",
    "isIncomplete": false,
    "status": "ACTIVE",
    "createdBy": "pengfei",
    "updatedBy": "pengfei",
    "createTime": 1647248347081,
    "updateTime": 1647250637670,
    "version": 0,
    "labels": []
  }
}
```

if you set ignoreRelationships=False, you will get below json file. You can notice you get all the hive_column, hive_db
dependencies information. But we don't recommend you to use this output as base to determine entity template.

```json
{
  "referredEntities": {
    "625ed183-211d-48a9-a37f-532cd66275c5": {
      "typeName": "hive_column",
      "attributes": {
        "qualifiedName": "default.students.studentID",
        "name": "studentID",
        "position": 0,
        "type": "int"
      },
      "guid": "625ed183-211d-48a9-a37f-532cd66275c5",
      "isIncomplete": false,
      "status": "ACTIVE",
      "createdBy": "pengfei",
      "updatedBy": "pengfei",
      "createTime": 1647249156946,
      "updateTime": 1647249156946,
      "version": 0,
      "labels": []
    },
    "3fcd8dde-c3b9-4457-a52e-395bd9d7301b": {
      "typeName": "hive_column",
      "attributes": {
        "qualifiedName": "default.students.year",
        "name": "year",
        "position": 0,
        "type": "string"
      },
      "guid": "3fcd8dde-c3b9-4457-a52e-395bd9d7301b",
      "isIncomplete": false,
      "status": "ACTIVE",
      "createdBy": "pengfei",
      "updatedBy": "pengfei",
      "createTime": 1647250563708,
      "updateTime": 1647250563708,
      "version": 0,
      "labels": []
    },
    "ad87c56f-9f0a-487a-88cf-27ece45fec9b": {
      "typeName": "hive_column",
      "attributes": {
        "qualifiedName": "default.students.firstName",
        "name": "firstName",
        "position": 0,
        "type": "string"
      },
      "guid": "ad87c56f-9f0a-487a-88cf-27ece45fec9b",
      "isIncomplete": false,
      "status": "ACTIVE",
      "createdBy": "pengfei",
      "updatedBy": "pengfei",
      "createTime": 1647249274457,
      "updateTime": 1647249274457,
      "version": 0,
      "labels": []
    },
    "99c439fa-e2bd-42d6-9970-0d9f6b203cee": {
      "typeName": "hive_column",
      "attributes": {
        "qualifiedName": "default.students.major",
        "name": "major",
        "position": 0,
        "type": "string"
      },
      "guid": "99c439fa-e2bd-42d6-9970-0d9f6b203cee",
      "isIncomplete": false,
      "status": "ACTIVE",
      "createdBy": "pengfei",
      "updatedBy": "pengfei",
      "createTime": 1647250637670,
      "updateTime": 1647250637670,
      "version": 0,
      "labels": []
    },
    "b6529c50-7de7-4672-a51b-6a64cc1c0299": {
      "typeName": "hive_column",
      "attributes": {
        "qualifiedName": "default.students.lastName",
        "name": "lastName",
        "position": 0,
        "type": "string"
      },
      "guid": "b6529c50-7de7-4672-a51b-6a64cc1c0299",
      "isIncomplete": false,
      "status": "ACTIVE",
      "createdBy": "pengfei",
      "updatedBy": "pengfei",
      "createTime": 1647249336265,
      "updateTime": 1647249336265,
      "version": 0,
      "labels": []
    }
  },
  "entity": {
    "typeName": "hive_table",
    "attributes": {
      "owner": null,
      "temporary": false,
      "lastAccessTime": 1647212400000,
      "aliases": [],
      "replicatedTo": [],
      "userDescription": null,
      "replicatedFrom": [],
      "qualifiedName": "default.students",
      "displayName": null,
      "columns": [
        {
          "guid": "b6529c50-7de7-4672-a51b-6a64cc1c0299",
          "typeName": "hive_column"
        },
        {
          "guid": "3fcd8dde-c3b9-4457-a52e-395bd9d7301b",
          "typeName": "hive_column"
        },
        {
          "guid": "625ed183-211d-48a9-a37f-532cd66275c5",
          "typeName": "hive_column"
        },
        {
          "guid": "ad87c56f-9f0a-487a-88cf-27ece45fec9b",
          "typeName": "hive_column"
        },
        {
          "guid": "99c439fa-e2bd-42d6-9970-0d9f6b203cee",
          "typeName": "hive_column"
        }
      ],
      "description": null,
      "viewExpandedText": null,
      "tableType": null,
      "createTime": 1647212400000,
      "name": "students",
      "comment": null,
      "partitionKeys": [],
      "parameters": null,
      "retention": 0,
      "viewOriginalText": null,
      "db": {
        "guid": "a5201924-87f7-4c3c-aab4-b8086917b108",
        "typeName": "hive_db"
      }
    },
    "guid": "e57ce313-ef6c-4ada-b40d-697b693893f6",
    "isIncomplete": false,
    "status": "ACTIVE",
    "createdBy": "pengfei",
    "updatedBy": "pengfei",
    "createTime": 1647248347081,
    "updateTime": 1647250637670,
    "version": 0,
    "relationshipAttributes": {
      "inputToProcesses": [],
      "schema": [],
      "ddlQueries": [],
      "columns": [
        {
          "guid": "b6529c50-7de7-4672-a51b-6a64cc1c0299",
          "typeName": "hive_column",
          "entityStatus": "ACTIVE",
          "displayText": "lastName",
          "relationshipType": "hive_table_columns",
          "relationshipGuid": "08d52c01-3b92-461d-a7b8-c9f0bb16354b",
          "relationshipStatus": "ACTIVE",
          "relationshipAttributes": {
            "typeName": "hive_table_columns"
          }
        },
        {
          "guid": "3fcd8dde-c3b9-4457-a52e-395bd9d7301b",
          "typeName": "hive_column",
          "entityStatus": "ACTIVE",
          "displayText": "year",
          "relationshipType": "hive_table_columns",
          "relationshipGuid": "7318335b-eade-4147-9b08-3f8f2447a8ed",
          "relationshipStatus": "ACTIVE",
          "relationshipAttributes": {
            "typeName": "hive_table_columns"
          }
        },
        {
          "guid": "625ed183-211d-48a9-a37f-532cd66275c5",
          "typeName": "hive_column",
          "entityStatus": "ACTIVE",
          "displayText": "studentID",
          "relationshipType": "hive_table_columns",
          "relationshipGuid": "8c0a8e8b-aa21-44e3-b445-334906a418bc",
          "relationshipStatus": "ACTIVE",
          "relationshipAttributes": {
            "typeName": "hive_table_columns"
          }
        },
        {
          "guid": "ad87c56f-9f0a-487a-88cf-27ece45fec9b",
          "typeName": "hive_column",
          "entityStatus": "ACTIVE",
          "displayText": "firstName",
          "relationshipType": "hive_table_columns",
          "relationshipGuid": "f617b05c-5848-40de-a1a3-c6d60a411e3c",
          "relationshipStatus": "ACTIVE",
          "relationshipAttributes": {
            "typeName": "hive_table_columns"
          }
        },
        {
          "guid": "99c439fa-e2bd-42d6-9970-0d9f6b203cee",
          "typeName": "hive_column",
          "entityStatus": "ACTIVE",
          "displayText": "major",
          "relationshipType": "hive_table_columns",
          "relationshipGuid": "991c1050-d9ae-4e5d-9e99-1abea6fe846c",
          "relationshipStatus": "ACTIVE",
          "relationshipAttributes": {
            "typeName": "hive_table_columns"
          }
        }
      ],
      "partitionKeys": [],
      "meanings": [],
      "db": {
        "guid": "a5201924-87f7-4c3c-aab4-b8086917b108",
        "typeName": "hive_db",
        "entityStatus": "ACTIVE",
        "displayText": "default",
        "relationshipType": "hive_table_db",
        "relationshipGuid": "05959fed-b3d5-408e-adf2-65db7a22bb2b",
        "relationshipStatus": "ACTIVE",
        "relationshipAttributes": {
          "typeName": "hive_table_db"
        }
      },
      "outputFromProcesses": []
    },
    "labels": []
  }
}
```

## Step3. Create entities in Atlas

In our example, to create a hive_table, we need to create a hive_db first. Follow the above steps, you can determine a
valid load_hive_db.json as shown below:

```json
{
  "referredEntities": {},
  "entity": {
    "typeName": "hive_db",
    "attributes": {
      "owner": "pliu",
      "ownerType": "user",
      "replicatedTo": [],
      "userDescription": null,
      "replicatedFrom": [],
      "qualifiedName": "insee.org@insee-data",
      "displayName": "insee-data",
      "clusterName": "insee.org",
      "name": "insee-data",
      "description": "insee data for testing ",
      "location": null,
      "parameters": null
    },
    "isIncomplete": false,
    "status": "ACTIVE",
    "createdBy": "pengfei",
    "updatedBy": "pengfei",
    "createTime": 1647248769815,
    "updateTime": 1647248804548,
    "version": 0,
    "labels": []
  }
}
```

To load the above hive_db into Atlas, you can run below command:

```shell
curl -H "Authorization: Bearer ${token}" -X POST -H "Content-Type: application/json" -H "Accept: application/json" \
"https://atlas.lab.sspcloud.fr/api/atlas/v2/entity" -d "@./load_hive_db.json"

```

Now we have the hive_db, we can build the load_hive_table.json by using the minimum attributs:

```json
{
  "referredEntities": {},
  "entity": {
    "typeName": "hive_table",
    "attributes": {
      "owner": "pliu",
      "temporary": false,
      "lastAccessTime": 1647212400000,
      "aliases": [],
      "replicatedTo": [],
      "userDescription": null,
      "replicatedFrom": [],
      "qualifiedName": "insee.org@insee-data.students_test",
      "displayName": "students_test",
      "description": null,
      "viewExpandedText": null,
      "tableType": null,
      "createTime": 1647212400000,
      "name": "students_test",
      "comment": null,
      "parameters": null,
      "retention": 0,
      "viewOriginalText": null
    },
    "isIncomplete": false,
    "status": "ACTIVE",
    "createdBy": "pengfei",
    "updatedBy": "pengfei",
    "createTime": 1647248347081,
    "updateTime": 1647250637670,
    "version": 0,
    "labels": []
  }
}
```

To load the above hive_table into Atlas, you can run below command:

```shell
curl -H "Authorization: Bearer ${token}" -X POST -H "Content-Type: application/json" -H "Accept: application/json" \
"https://atlas.lab.sspcloud.fr/api/atlas/v2/entity" -d "@./load_hive_table.json"
```

You can notice the hive_table will be created without relating any hive_db. To add dependent hive_db, you need to add 
the following attribute inside the load_hive_table.json
```json
"db": {
        "typeName": "hive_db",
        "uniqueAttributes": {
            "qualifiedName": "insee.org@insee-data"
          }
      }
```
you can find the full example in load_hive_table.json



### load hive_column

Repeat Step1, 2, you can get the below valid hive_column specification.

```json
{
  "referredEntities": {},
  "entity": {
    "typeName": "hive_column",
    "attributes": {
      "owner": "pliu",
      "replicatedTo": [],
      "userDescription": null,
      "replicatedFrom": [],
      "qualifiedName": "insee.org@insee-data.students_test.studentID",
      "displayName": "studentID",
      "name": "studentID",
      "description": "The id of student",
      "table": {
        "typeName": "hive_table",
        "uniqueAttributes": {
            "qualifiedName": "insee.org@insee-data.students_test"
          }
      },
      "comment": null,
      "position": 0,
      "type": "int"
    },
    "isIncomplete": false,
    "status": "ACTIVE",
    "createdBy": "pengfei",
    "updatedBy": "pengfei",
    "createTime": 1647249156946,
    "updateTime": 1647249156946,
    "version": 0,
    "labels": []
  }
}
```

Note the attribute **table** will link this column to a column, and the qualifiedName of the hive_column must be compatible
with the qualifiedName of the hive_table. For example, 


## Step 4 Purge entity in atlas

When we delete an entity in atlas, the entity is just marked as deleted, but it still stays inside the database. To 
remove these deleted entities, you need to run below purge command.

```shell
curl -H "Authorization: Bearer ${token}" -X PUT "https://atlas.lab.sspcloud.fr/api/atlas/v2/admin/purge/" \
-H "Content-Type: application/json" \
-d '["5f0d5c6b-6e73-4fe2-a3e7-cfcc96a4ad95"]'
```
