# API Procedure
PUT /workspaces/:workspace_id
## Expected Outcome
presents an errors hash if resource invalid
## Sequence Number
2
## Request Method
put
## Request Path
/workspaces/f8946e66-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"f8962206-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"changed"}

## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"280"}

## Response Body
{
  "id": "f8946e66-5afa-11e2-8b59-b870f43f7835",
  "name": "changed",
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
