# API Procedure
PUT /workspaces/:workspace_id
## Expected Outcome
presents an errors hash if resource invalid
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f8932998-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"JKINCTLY"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f8946e66-5afa-11e2-8b59-b870f43f7835",
  "name": "JKINCTLY",
  "entity_id": "1617b9e4-c329-4617-8663-fc0bd60f8548",
  "created_at": "2013-01-10T15:54:33+08:00",
  "updated_at": "2013-01-10T15:54:33+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
