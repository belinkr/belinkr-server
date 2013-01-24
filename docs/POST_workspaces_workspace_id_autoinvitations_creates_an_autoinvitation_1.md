# API Procedure
POST /workspaces/:workspace_id/autoinvitations
## Expected Outcome
creates an autoinvitation
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f7e27a3a-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"YSQDJVAH"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f7e3bc92-5afa-11e2-8b59-b870f43f7835",
  "name": "YSQDJVAH",
  "entity_id": "dc77dfcb-c13f-449b-8b8f-7670aa18d4de",
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
