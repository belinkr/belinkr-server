# API Procedure
POST /workspaces/:workspace_id/invitations
## Expected Outcome
creates an invitation
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f820907c-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"QLSSVIWQ"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f821dae0-5afa-11e2-8b59-b870f43f7835",
  "name": "QLSSVIWQ",
  "entity_id": "203ec9b5-c5ff-434d-a7ea-a2d7fbaf34a1",
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
