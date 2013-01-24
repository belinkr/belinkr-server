# API Procedure
GET /workspaces/:workspace_id/collaborators
## Expected Outcome
returns a page of collaborators in the workspace
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f1bbffbe-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"IANAQUNC"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f1bd5742-5afa-11e2-8b59-b870f43f7835",
  "name": "IANAQUNC",
  "entity_id": "6db27b74-a2f3-4d3d-a0e0-36537623055e",
  "created_at": "2013-01-10T15:54:21+08:00",
  "updated_at": "2013-01-10T15:54:21+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
