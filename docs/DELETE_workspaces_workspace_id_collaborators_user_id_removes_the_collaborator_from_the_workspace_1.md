# API Procedure
DELETE /workspaces/:workspace_id/collaborators/:user_id
## Expected Outcome
removes the collaborator from the workspace
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ea65396a-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"RFFLBATE"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ea668c52-5afa-11e2-8b59-b870f43f7835",
  "name": "RFFLBATE",
  "entity_id": "a184ffd2-fa30-4a49-9a37-fcc997453185",
  "created_at": "2013-01-10T15:54:09+08:00",
  "updated_at": "2013-01-10T15:54:09+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
