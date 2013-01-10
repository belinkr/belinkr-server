# API Procedure
GET /workspaces/:workspace_id/invitations/:invitation_id
## Expected Outcome
retrieves an invitation
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f732dd96-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"HTCJWGFM"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f7341dfa-5afa-11e2-8b59-b870f43f7835",
  "name": "HTCJWGFM",
  "entity_id": "d30ba8f1-80b0-405f-b84e-9e38355e7999",
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
