# API Procedure
DELETE /workspaces/:workspace_id/users/:user_id
## Expected Outcome
allows the actor to leave the workspace
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ea91e668-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"JBJLXOSW"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ea9330e0-5afa-11e2-8b59-b870f43f7835",
  "name": "JBJLXOSW",
  "entity_id": "949e2729-8bce-4f70-89cb-acad48420b9b",
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
