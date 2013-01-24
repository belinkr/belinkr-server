# API Procedure
POST /workspaces/:workspace_id/invitations/accepted/:invitation_id
## Expected Outcome
accepts an invitation
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f850e704-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"CVSTDKAG"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f852265a-5afa-11e2-8b59-b870f43f7835",
  "name": "CVSTDKAG",
  "entity_id": "d27807db-1eb3-4633-a322-9e38b6aa6198",
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
