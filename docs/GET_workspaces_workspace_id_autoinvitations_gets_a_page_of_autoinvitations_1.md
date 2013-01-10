# API Procedure
GET /workspaces/:workspace_id/autoinvitations
## Expected Outcome
gets a page of autoinvitations
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ee3c5802-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"BYWQJHBV"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ee3da716-5afa-11e2-8b59-b870f43f7835",
  "name": "BYWQJHBV",
  "entity_id": "f231037a-28aa-460e-8dfa-988dd3563d51",
  "created_at": "2013-01-10T15:54:15+08:00",
  "updated_at": "2013-01-10T15:54:15+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
