# API Procedure
POST /workspaces/:workspace_id/invitations/rejected/:invitation_id
## Expected Outcome
rejects an invitation
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f87d46be-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"UHYHLFFG"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f87ea400-5afa-11e2-8b59-b870f43f7835",
  "name": "UHYHLFFG",
  "entity_id": "98b85148-5406-47d7-9469-20589999d220",
  "created_at": "2013-01-10T15:54:33+08:00",
  "updated_at": "2013-01-10T15:54:33+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
