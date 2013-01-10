# API Procedure
POST /workspaces/:workspace_id/administrators/:user_id
## Expected Outcome
assigns the administrator role to a existing user in the workspace
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f7bfc1c0-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"WVIDKGSQ"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f7c10c38-5afa-11e2-8b59-b870f43f7835",
  "name": "WVIDKGSQ",
  "entity_id": "9c6c8ccd-e017-4664-9004-e8702605627d",
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
