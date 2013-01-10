# API Procedure
GET /workspaces/:workspace_id/invitations
## Expected Outcome
gets a page of invitations
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f3ab5112-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"RHKCGYCJ"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f3ac9f0e-5afa-11e2-8b59-b870f43f7835",
  "name": "RHKCGYCJ",
  "entity_id": "58dab912-199e-4cc9-a9b0-b47f49bc115c",
  "created_at": "2013-01-10T15:54:25+08:00",
  "updated_at": "2013-01-10T15:54:25+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
