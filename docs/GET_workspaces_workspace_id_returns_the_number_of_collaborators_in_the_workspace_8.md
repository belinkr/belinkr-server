# API Procedure
GET /workspaces/:workspace_id
## Expected Outcome
returns the number of collaborators in the workspace
## Sequence Number
8
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ebfc9d7c-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"DRHNTQIP"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ebfdddb8-5afa-11e2-8b59-b870f43f7835",
  "name": "DRHNTQIP",
  "entity_id": "8411c16a-bd56-4a0b-9ac5-378e8db85e21",
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
