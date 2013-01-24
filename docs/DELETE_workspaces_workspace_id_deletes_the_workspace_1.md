# API Procedure
DELETE /workspaces/:workspace_id
## Expected Outcome
deletes the workspace
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ea2bc9aa-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"OXCOLVRB"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ea43953a-5afa-11e2-8b59-b870f43f7835",
  "name": "OXCOLVRB",
  "entity_id": "f7a27fb0-213e-4c00-a09d-379205b7384c",
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
