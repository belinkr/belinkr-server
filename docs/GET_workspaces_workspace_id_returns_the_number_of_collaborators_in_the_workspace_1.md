# API Procedure
GET /workspaces/:workspace_id
## Expected Outcome
returns the number of collaborators in the workspace
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ebabb862-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"VPLPLCNH"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ebb4b3ae-5afa-11e2-8b59-b870f43f7835",
  "name": "VPLPLCNH",
  "entity_id": "a8dfc723-e764-4d36-bc2e-2060d792863e",
  "created_at": "2013-01-10T15:54:11+08:00",
  "updated_at": "2013-01-10T15:54:11+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
