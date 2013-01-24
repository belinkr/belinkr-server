# API Procedure
GET /workspaces/:workspace_id
                /autoinvitations/:autoinvitation_id
## Expected Outcome
retrieves an autoinvitation
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"ec386fbe-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"SQHLLOKL"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "ec39ae38-5afa-11e2-8b59-b870f43f7835",
  "name": "SQHLLOKL",
  "entity_id": "ad94be80-990c-46b9-b050-9532b5563fea",
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
