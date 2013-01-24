# API Procedure
GET /workspaces
## Expected Outcome
returns a page
## Sequence Number
11
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"eae2bb10-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"KUQLYKHN"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"281"}

## Response Body
{
  "id": "eae3ae08-5afa-11e2-8b59-b870f43f7835",
  "name": "KUQLYKHN",
  "entity_id": "d2786a29-e6fa-4e8c-8a07-894c9a6f506a",
  "created_at": "2013-01-10T15:54:10+08:00",
  "updated_at": "2013-01-10T15:54:10+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
