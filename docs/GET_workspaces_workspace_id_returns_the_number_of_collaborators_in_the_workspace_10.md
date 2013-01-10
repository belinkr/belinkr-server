# API Procedure
GET /workspaces/:workspace_id
## Expected Outcome
returns the number of collaborators in the workspace
## Sequence Number
10
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ec16f8fc-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"ICPFVBGF"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ec184e46-5afa-11e2-8b59-b870f43f7835",
  "name": "ICPFVBGF",
  "entity_id": "a521a738-fd8b-4e86-845a-4f8147e0b091",
  "created_at": "2013-01-10T15:54:12+08:00",
  "updated_at": "2013-01-10T15:54:12+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
