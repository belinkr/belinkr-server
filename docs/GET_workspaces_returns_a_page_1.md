# API Procedure
GET /workspaces
## Expected Outcome
returns a page
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"eaa874be-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"GREYELQO"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "eaa9cdfa-5afa-11e2-8b59-b870f43f7835",
  "name": "GREYELQO",
  "entity_id": "2c8c4bcd-48c9-44e6-a4ee-add4243a67bf",
  "created_at": "2013-01-10T15:54:09+08:00",
  "updated_at": "2013-01-10T15:54:09+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
