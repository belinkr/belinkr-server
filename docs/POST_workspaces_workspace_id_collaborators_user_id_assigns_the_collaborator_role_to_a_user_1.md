# API Procedure
POST /workspaces/:workspace_id/collaborators/:user_id
## Expected Outcome
assigns the collaborator role to a user
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f8045aa6-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"DKIMDHVV"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f80d4c56-5afa-11e2-8b59-b870f43f7835",
  "name": "DKIMDHVV",
  "entity_id": "1c0256dc-177e-4e51-ab33-84d84820478b",
  "created_at": "2013-01-10T15:54:32+08:00",
  "updated_at": "2013-01-10T15:54:32+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
