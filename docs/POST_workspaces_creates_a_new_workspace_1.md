# API Procedure
POST /workspaces
## Expected Outcome
creates a new workspace
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f7741e6e-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"WMUAHPRR"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f7755d06-5afa-11e2-8b59-b870f43f7835",
  "name": "WMUAHPRR",
  "entity_id": "57fd1d5a-30eb-4b54-a2ef-17997a1f790e",
  "created_at": "2013-01-10T15:54:31+08:00",
  "updated_at": "2013-01-10T15:54:31+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
