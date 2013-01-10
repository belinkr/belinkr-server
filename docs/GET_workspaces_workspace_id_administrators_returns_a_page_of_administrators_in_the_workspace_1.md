# API Procedure
GET /workspaces/:workspace_id/administrators
## Expected Outcome
returns a page of administrators in the workspace
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ec4d2b7a-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"XVCMQJDU"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ec4e70d4-5afa-11e2-8b59-b870f43f7835",
  "name": "XVCMQJDU",
  "entity_id": "4349b808-d01f-48cd-a17a-60837b4cfa2d",
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
