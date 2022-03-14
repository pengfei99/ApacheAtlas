# Rest Api of atlas

Atlas provides a rest API for all features which it supports. 
- Discovery (search query for finding data)
- Entity (list entity with or without filter)
- Glossary (list glossary with or without filter)
- Lineage
- Relationship
- Types


You can find the latest (2.2.0) atlas rest [API doc](https://atlas.apache.org/api/v2/ui/index.html)

## 1.Api for discovery 

Atlas exposes search over the metadata in two ways:
  * Basic Search
  * Advanced Search(DSL or full text)

You can find the full doc on https://atlas.apache.org/0.8.3/Search.html


### 1.1 Basic search 

The basic search allows you to query using typename of an entity, associated classification/tag and has support for 
filtering on the entity attributes as well as the classification/tag attributes.

The basic search query structure can be represented using the following JSON structure(configurable search parameters)

```json
{
  "typeName": "hive_table",
  "excludeDeletedEntities": true,
  "classification" : "",
  "query": "",
  "limit": 25,
  "offset": 0,
  "entityFilters": {
   "attributeName": "name",
   "operator": "contains",
   "attributeValue": "testtable"
  },
  "tagFilters": null,
  "attributes": [""]
}

```


Note: The JSON file should be all data, so you don't put comments in it. If you really want to insert comments, then 
you can create a designated data element called "_comment"(or whatever you want) that would be ignored by apps that 
use the JSON data. It's better having the comment of the JSON file in the processes that generates/receives the JSON, 
as they are supposed to know what the JSON data will be in advance, or at least the structure of it.

**Field description**

- typeName: The type of entity to look for
- excludeDeletedEntities: Should the search include deleted entities too (default: true)
- classification: Only include entities with given Classification/tag
- query: Any free text occurrence that the entity should have (generic/wildcard queries might be slow)
- limit: Max number of results to fetch
- offset: Starting offset of the result set (useful for pagination)
- entityFilters: Entity Attribute filter(s)
- tagFilters: Classification/tag Attribute filter(s)
- attributes: Attributes to include in the search result (default: include any attribute present in the filter)

**Attribute based filtering can be done on multiple attributes with AND/OR condition.**

For the purpose of simplicity, all the rest query which we use to demonstrate is done with curl. The query 
authentication can be different if atlas uses different authentication mode:
- login/password: if atlas uses ldap/file for authentication, you should use curl -u <login>:<password> <restURI>. 
- kerberos: use curl -negotiate -u <login> <restURI>. 
- OIDC: **curl -H 'Authorization: Bearer <oidc-token>'

All the following code example will omit the authentication part in the curl code by assuming you are doing -u <login>:<password>.


All the url for search activity starts with /v2/search, the full list is

  * (GET) /v2/search/attribute : Retrieve data for the specified attribute search query
  * (GET) /v2/search/basic : Retrieve data for the specified fulltext query
  * (POST) /v2/search/basic : Attribute based search for entities satisfying the search parameters
  * (GET) /v2/search/dsl : Retrieve data for the specified DSL
  * (GET) /v2/search/fulltext : Retrieve data for the specified fulltext query
  * (GET) /v2/search/relationship : Relationship search to search for related entities satisfying the search parameters
  * (GET) /v2/search/saved : Retrieve saved search query for given user
  * (POST) /v2/search/saved : Add the search query in the post payload to atlas
  * (PUT) /v2/search/saved : Update the existing search query
  * (DELETE) /v2/search/saved/{guid} : Delete the existing search query with the given guid
  * (GET) /v2/search/saved/{guid/name} : Retrieve saved search query based on the given  guid or name of the search query
  * (GET) /v2/search/saved/execute/{name} : Attribute based search for entities satisfying the name of saved-search
  * (GET) /v2/search/saved/execute/guid/{guid}

Note The rest API changes with the update of the atlas, so you may encounter errors.

```shell
# basic search on all data with typeName hive_db
curl http://localhost:21000/api/atlas/v2/search/basic?typeName=hive_db

# a more complete curl command for search basic
curl -X GET --header 'Accept: application/json' -u admin:kdHVNXuo1zMjnM32QqAk 'http://localhost:21000/api/atlas/v2/search/basic?typeName=GPFSDataFile'

# if you don't want pass parameters with "?", you can also supply a JSON data payload
# -g means globoff, when you set this option, you can specify URLs that contain the letters {}[] without having 
# them being interpreted by curl itself. 
# Note that these letters are not normal legal URL contents but they should be encoded according to the URI standard.
# -d means data
# @. means current directory
curl -u admin:kdHVNXuo1zMjnM32QqAk -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/search/basic" -d "@./searchByOwner.json"

# basic search with json payload and multi conditioin (OR)
curl -u admin:kdHVNXuo1zMjnM32QqAk -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/search/basic" -d "@./searchMultiCond.json"

```

Below file searchByOwner.json allow you to search all hive_table where owner is hive:

```json
{
  "typeName": "hive_table",
  "excludeDeletedEntities": true,
  "classification": "Mosaic",
  "query": "",
  "limit": 50,
  "offset": 0,
  "entityFilters": {
    "attributeName": "owner",
    "operator": "eq",
    "attributeValue": "hive"
  },
  "tagFilters": null,
  "attributes": [
    ""
  ]
}

```

In file searchMultiCond.json, we use multiple conditions to filter hive table 

```json
{
  "typeName": "hive_table",
  "excludeDeletedEntities": true,
  "classification": "Mosaic",
  "query": "",
  "limit": 50,
  "offset": 0,
  "entityFilters": {
    "condition": "OR",
    "criterion": [
      {
        "attributeName": "columns",
        "operator": "contains",
        "attributeValue": "age"
      },
      {
        "attributeName": "owner",
        "operator": "eq",
        "attributeValue": "hive"
      }
    ]
  },
  "tagFilters": null,
  "attributes": [
    ""
  ]
}
```

### 1.2 Advance search

In the advance search you need to use the Atlas DSL. See the official doc

## 2. Api for type management 

The **TypesRest** API of ATLAS supports all CRUD operations on type definitions. You can find the full doc here
: https://atlas.apache.org/api/v2/resource_TypesREST.html. 

The full list of the TypesRest api:
  * (GET) /v2/types/classificationdef/guid/{guid} : Get the classification definition for the given guid.
  * (GET) /v2/types/classificationdef/name/{name} : Get the classification definition by it's name (unique).
  * (GET) /v2/types/entitydef/guid/{guid} : Get the Entity definition for the given guid.
  * (GET) /v2/types/entitydef/name/{name} : Get the entity definition by it's name (unique)
  * (GET) /v2/types/enumdef/guid/{guid} : Get the enum definition for the given guid. 
  * (GET) /v2/types/enumdef/name/{name} : Get the enum definition by it's name (unique)
  * (GET) /v2/types/relationshipdef/guid/{guid} : Get the relationship definition for the given guid
  * (GET) /v2/types/relationshipdef/name/{name} : Get the relationship definition by it's name (unique)
  * (GET) /v2/types/structdef/guid/{guid} : Get the struct definition for the given guid.
  * (GET) /v2/types/structdef/name/{name} : Get the struct definition by it's name (unique).
  * (GET) /v2/types/typedef/guid/{guid} : Get any type definition (e.g. classification, entity, etc.) by it's guid
  * (GET) /v2/types/typedef/name/{name} : Get type definition by it's name
  * (DELETE) /v2/types/typedef/name/{typeName} : Delete API for type identified by its name.
  * (DELETE) /v2/types/typedefs : Bulk delete API for all types.
  * (GET) /v2/types/typedefs : Bulk retrieval API for retrieving all type definitions in Atlas.
  * (POST) /v2/types/typedefs : Bulk create APIs for all atlas type definitions, only new definitions will be created
  * (PUT) /v2/types/typedefs : Bulk update API for all types, changes detected in the type definitions would be persisted
  * (GET) /v2/types/typedefs/headers : Bulk retrieval API for all type definitions returned as a list of minimal information header

```shell
# get classification definition of a classification with name Mosaic
curl -X GET -u admin:kdHVNXuo1zMjnM32QqAk http://localhost:21000/api/atlas/v2/types/classificationdef/name/Mosaic

# get entity hive_table definition
curl -X GET -u admin:kdHVNXuo1zMjnM32QqAk http://localhost:21000/api/atlas/v2/types/entitydef/name/hive_table

# get type defition with its guid, in this example, the guid is for entity hive_table
curl -X GET -u admin:kdHVNXuo1zMjnM32QqAk http://localhost:21000/api/atlas/v2/types/typedef/guid/ffcb381a-4953-4557-9fb8-4307260a3552

# retrive type definition of DataSet by using name (GET /v2/types/typedef/name/{name})
curl -X GET -u admin:kdHVNXuo1zMjnM32QqAk http://localhost:21000/api/atlas/v2/types/typedef/name/DataSet

# Delete any type definition by its type name
curl -X DELETE -u admin:kdHVNXuo1zMjnM32QqAk http://localhost:21000/api/atlas/v2/types/typedef/name/testEntity

# bulk delete all types (DELETE /v2/types/typedefs + payload). The payload (json/xml) specifies which types needs to be deleted
curl -X DELETE -u admin:kdHVNXuo1zMjnM32QqAk http://localhost:21000/api/atlas/v2/types/typedefs

# bulk create API for all type, only new type definitions will be created. Any changes to the existing definitions will be discarded. (POST /v2/types/typedefs + payload), payload contains type definitions.
curl -u admin:kdHVNXuo1zMjnM32QqAk -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/types/typedefs" -d "@./typeDef_datafile.json"

# bulk update API for all types, changes detected in the new submitted type definition will be updated on the existing atlas types.
curl -X PUT --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' 'http://localhost:21000/api/atlas/v2/types/typedefs' -d "@./typesUpdate.json"

# bulk retrieval for all type definitions returned as a list of minimal information header
curl -X GET -u admin:kdHVNXuo1zMjnM32QqAk http://localhost:21000/api/atlas/v2/types/typedefs/headers

```


To illustrate how to create a new type in atlas, we use the following example. Suppose we store all our data on a 
network storage which called gpfs.

We write the following data type definition (typeDef_datafile.json)
```json
{
  "structDefs": [
    {
      "category": "STRUCT",
      "name": "schema_col",
      "description": "column definition for schema",
      "typeVersion": "1.0",
      "attributeDefs": [
        {
          "name": "col",
          "typeName": "string",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        },
        {
          "name": "data_type",
          "typeName": "string",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        },
        {
          "name": "required",
          "typeName": "boolean",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        }
      ]
    }
  ],
  "entityDefs": [
    {
      "superTypes": [
        "DataSet"
      ],
      "category": "ENTITY",
      "name": "GPFSDataFile",
      "description": "a type definition for a file in gpfs which contains data, this could a file that needs to be processed or it can be an output (ex: extracts)",
      "typeVersion": "1.0",
      "attributeDefs": [
        {
          "name": "file_name",
          "typeName": "string",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": true,
          "isIndexable": true
        },
        {
          "name": "parent_dir",
          "typeName": "string",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": true,
          "isIndexable": true
        },
        {
          "name": "user",
          "typeName": "string",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        },
        {
          "name": "group",
          "typeName": "string",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        },
        {
          "name": "permission",
          "typeName": "string",
          "isOptional": true,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        },
        {
          "name": "creation_time",
          "typeName": "date",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        },
        {
          "name": "format",
          "typeName": "string",
          "isOptional": false,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        },
        {
          "name": "schema",
          "typeName": "array<schema_col>",
          "isOptional": true,
          "cardinality": "SINGLE",
          "valuesMinCount": 1,
          "valuesMaxCount": 1,
          "isUnique": false,
          "isIndexable": false
        }
      ]
    }
  ]
}
```

We could notice that the above type definition has two parts. The second part is the main type definition, It starts 
with key word "entityDefs" and contains the following information:
- SuperTypes: Every customer types in Atlas must have one
- Category: A metadata type definition has the Category "ENTITY",
- name: Name of the metadata type
- description: 
- typeVersion: 
- attributeDefs: list of the attributes' definition, every attribute must have a type. The predefined types almost cover every thing.
- Primitive metatypes: boolean, byte, short, int, long, float, double, biginteger, bigdecimal, string, date
- Enum metatypes
- Collection metatypes: array, map
- Composite metatypes: Entity, Struct, Classification, Relationship
If you want something special, you can also add new types for attributes. In the above example, I add a new struct type with name schema_col.

For more information on how to define metadata types in Atlas, please visit 
 https://atlas.apache.org/TypeSystem.html
   
Now we can use the bulk add typedef api to add the above type definition into Atlas

```shell
# add new type definition (entity)
curl -u admin:kdHVNXuo1zMjnM32QqAk -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/types/typedefs" -d "@./typeDef_datafile.json"

# check the newly added entity
curl -u admin:kdHVNXuo1zMjnM32QqAk http://localhost:21000/api/atlas/v2/types/typedef/name/GPFSDataFile

```


We want to manage the metadata of these data in Atlas.


## 3. API for entity management

In this section, we will see how to CRUD an entity in Atlas. To see the official doc, please visit https://atlas.apache.org/api/v2/ui/index.html#/EntityREST

All the url for entity CRUD activity start with /v2/entity, the full list is

  * (POST) /v2/entity : Create new entity or update existing entity in Atlas
  * (DELETE) /v2/entity/bulk : Bulk API to delete a list of entities identified by its GUIDs
  * (GET) /v2/entity/bulk : Bulk API to retrieve list of entities identified by its GUIDs.
  * (GET) /v2/search/dsl : Retrieve data for the specified DSL
  * (GET) /v2/search/fulltext : Retrieve data for the specified fulltext query
  * (GET) /v2/search/relationship : Relationship search to search for related entities satisfying the search parameters

```shell
# Check entity attributes by using their GUIDs. This allows you to add multiple guids 
curl -X GET -u admin:admin --header 'Accept: application/json' 'http://atlas.lab.sspcloud.fr/api/atlas/v2/entity/bulk?guid=4263e0b8-fde9-4d78-bed5-0de470078bce&ignoreRelationships=false&minExtInfo=false'

# example with two guids

curl -X GET -u admin:admin --header 'Accept: application/json' 'http://atlas.lab.sspcloud.fr/api/atlas/v2/entity/bulk?guid=4263e0b8-fde9-4d78-bed5-0de470078bce&guid=a-new-guid&ignoreRelationships=false&minExtInfo=false'


# Get all the entities in a given type
curl -u admin:kdHVNXuo1zMjnM32QqAk -X GET http://localhost:21000/api/atlas/entities?type=GPFS_Path

# delete an entity based on its guid
curl -iv -u admin:kdHVNXuo1zMjnM32QqAk -X DELETE http://localhost:21000/api/atlas/entities?guid=b1ed9bc1-e6e7-48f6-ac70-578ecb13ce79

```

### 3.1  Example of adding new entity

Add a new entity of a specific type, Below file (load_data.json) is the payload of the curl command,
```json
{
  "entities": [
    {
      "typeName": "GPFS_Path",
      "createdBy": "pliu",
      "attributes": {
        "qualifiedName": "it's only a simple attribute",
        "uri": "pengfei.org",
        "name": "human_blood_sample.csv",
        "file_name": "human_blood_sample.csv",
        "parent_dir": "/sps/bioater/pt6/pliu/mosaic/data/",
        "user":"pliu",
        "group":"bioaster",
        "permission":"650",
        "creation_time":"2019-08-18T18:49:44.000Z",
        "format":"csv",
        "description":"test rest api",
        "owner":"pliu"
      },
      "classifications": [
        { "typeName": "Mosaic" }
      ]
    },
{
      "typeName": "GPFS_Path",
      "createdBy": "pliu",
      "attributes": {
        "qualifiedName": "rabbit tissu image",
        "uri": "pengfei.org",
        "name": "rabbit_124_tissu_infection.jpg",
        "file_name": "rabbit_124_tissu_infection.jpg",
        "parent_dir": "/sps/bioater/pt6/pliu/mosaic/data/rabbit",
        "user":"pliu",
        "group":"bioaster",
        "permission":"650",
        "creation_time":"2019-08-19T18:49:44.000Z",
        "format":"jpg",
        "description":"test rest api",
        "owner":"pliu"
      },
      "classifications": [
        { "typeName": "Mosaic" }
      ]
    }

]
}

```

```shell
# The Below command load the above json file into the atlas
curl -u admin:pwd -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/entity/bulk" -d "@./load_data.json"

```

We can also add an entity with complex types(), load_data_with_schema.json

```json
{
  "entities": [
    {
      "typeName": "GPFSDataFile",
      "createdBy": "pliu",
      "guid": "-208942807557404",
      "status": "ACTIVE",
      "version": 0,
      "attributes": {
        "qualifiedName": "data_from_mosaic",
        "uri": "data_from_mosaic",
        "name": "data_from_mosaic",

        "file_name": "human_blood_sample.csv",
        "parent_dir": "/sps/bioater/pt6/pliu/mosaic/data/",
        "user":"pliu",
        "group":"bioaster",
        "permission":"650",
        "creation_time":"Fri Nov 16 13:51:21 UTC 2018",
        "format":"csv",
        "schema":[
          { "col" : "name" ,"data_type" : "string" ,"required" : true },
          { "col" : "age" ,"data_type" : "int" ,"required" : true },
          { "col" : "blood_type" ,"data_type" : "string" ,"required" : true },
          { "col" : "white_cell_num" ,"data_type" : "int" ,"required" : true }
        ]
      },
      "classifications": [
        { "typeName": "Mosaic" }
      ]
    }
]
}

```

```shell
# I can't load the above data correctly, 
curl -u admin:pwd -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/entity/bulk" -d "@./test2.json"

# error message
# {"errorCode":"ATLAS-404-00-007","errorMessage":"Invalid instance creation/updation parameters passed : GPFSDataFile.schema[0]={col=name, data_type=string, required=true}: invalid value for type objectid"}

```


## 4. api for Glossary

### 4.1 get information of Glossary 

```shell
# get all elements of all Glossaries in the platform which includes categories and terms
curl -u admin:pwd -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/glossary"

# get all elements of a Glossary with a given glossary guid,
curl -u admin:pwd -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/glossary/f96c17d4-13c5-4958-8e76-ffc4c805c97a/detailed"

# The results contains guid, qualifiedName, Name of the glossary, 
# - a list of terms (only has termGuid and relationGuid)
# - a list fo termInfo (It contains detailed info of a term, e.g. seeAlso, synonyms, ...)
# - a list of categories (only has categoryGuid, relationGuid)
# - a list of categoryInfo (It constains detaild info of a category)

# get all categories of a Glossary with a given glossary guid,
curl -u admin:pwd -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/glossary/f96c17d4-13c5-4958-8e76-ffc4c805c97a/categories"

# get all terms of a Glossary
curl -u admin:pwd -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/glossary/f96c17d4-13c5-4958-8e76-ffc4c805c97a/terms"

# get a term description with its guid
curl -u admin:pwd -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/glossary/term/a610c968-e495-419a-8609-c4deba5790b1"


```


### 4.2 Create terms and categories 

#### 4.2.1 Create a term 

```shell
curl -u admin:pwd -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' "http://localhost:21000/api/atlas/v2/glossary/term" -d "@./load_term.json"

```

The full version of the json template for loading term can be found here http://atlas.apache.org/api/v2/resource_GlossaryREST.html#resource_GlossaryREST_createGlossaryTerm_POST.
Note all attribute names must be in lower case.

Below file (simple_term.json) represent a simple term
```json
{
"anchor":{
"displayText" : "Artefacts",
"glossaryGuid":"ee3f05ba-2fe1-4806-a81e-660c777a3403",
"relationGuid":"3be4d5d8-9a98-421c-a3f4-f8279604e50c"},
"longDescription":"Pièce ornementale ou de renfort fixée sur une autre (fr)",
"name":"applique",
"qualifiedName":"applique@Artefacts",
"shortDescription":"applique"
}

```


The full_HyperThesaurus.json is the full template for hyperThesaurus project. He only needs "see also" and "synonyms" as term relation.

```json
{
  "abbreviation" : "...",
  "anchor" : {
    "displayText" : "...",
    "glossaryGuid" : "...",
    "relationGuid" : "..."
  },
  "assignedEntities" : [ {
    "displayText" : "...",
    "entityStatus" : "ACTIVE",
    "relationshipAttributes" : {
      "attributes" : {
        "property1" : { },
        "property2" : { }
      },
      "typeName" : "..."
    },
    "relationshipGuid" : "...",
    "relationshipStatus" : "DELETED",
    "relationshipType" : "...",
    "guid" : "...",
    "typeName" : "...",
    "uniqueAttributes" : {
      "property1" : { },
      "property2" : { }
    }
  }, {
    "displayText" : "...",
    "entityStatus" : "DELETED",
    "relationshipAttributes" : {
      "attributes" : {
        "property1" : { },
        "property2" : { }
      },
      "typeName" : "..."
    },
    "relationshipGuid" : "...",
    "relationshipStatus" : "DELETED",
    "relationshipType" : "...",
    "guid" : "...",
    "typeName" : "...",
    "uniqueAttributes" : {
      "property1" : { },
      "property2" : { }
    }
  } ],
  "categories" : [ {
    "categoryGuid" : "...",
    "description" : "...",
    "displayText" : "...",
    "relationGuid" : "...",
    "status" : "DEPRECATED"
  }, {
    "categoryGuid" : "...",
    "description" : "...",
    "displayText" : "...",
    "relationGuid" : "...",
    "status" : "DEPRECATED"
  } ],
  
  "seeAlso" : [ {
    "description" : "...",
    "displayText" : "...",
    "expression" : "...",
    "relationGuid" : "...",
    "source" : "...",
    "status" : "ACTIVE",
    "steward" : "...",
    "termGuid" : "..."
  }, {
    "description" : "...",
    "displayText" : "...",
    "expression" : "...",
    "relationGuid" : "...",
    "source" : "...",
    "status" : "DRAFT",
    "steward" : "...",
    "termGuid" : "..."
  } ],
  "synonyms" : [ {
    "description" : "...",
    "displayText" : "...",
    "expression" : "...",
    "relationGuid" : "...",
    "source" : "...",
    "status" : "OTHER",
    "steward" : "...",
    "termGuid" : "..."
  }, {
    "description" : "...",
    "displayText" : "...",
    "expression" : "...",
    "relationGuid" : "...",
    "source" : "...",
    "status" : "ACTIVE",
    "steward" : "...",
    "termGuid" : "..."
  } ],
 
 
 
  "classifications" : [ {
    "entityGuid" : "...",
    "entityStatus" : "DELETED",
    "propagate" : true,
    "removePropagationsOnEntityDelete" : true,
    "validityPeriods" : [ {
      "endTime" : "...",
      "startTime" : "...",
      "timeZone" : "..."
    }, {
      "endTime" : "...",
      "startTime" : "...",
      "timeZone" : "..."
    } ],
    "attributes" : {
      "property1" : { },
      "property2" : { }
    },
    "typeName" : "..."
  }, {
    "entityGuid" : "...",
    "entityStatus" : "ACTIVE",
    "propagate" : true,
    "removePropagationsOnEntityDelete" : true,
    "validityPeriods" : [ {
      "endTime" : "...",
      "startTime" : "...",
      "timeZone" : "..."
    }, {
      "endTime" : "...",
      "startTime" : "...",
      "timeZone" : "..."
    } ],
    "attributes" : {
      "property1" : { },
      "property2" : { }
    },
    "typeName" : "..."
  } ],
  "longDescription" : "...",
  "name" : "...",
  "qualifiedName" : "...",
  "shortDescription" : "...",
  "guid" : "..."
}
```