# API Procedure
GET /scrapooks/:id
## Expected Outcome
returns 404 if the resource doesn't exist
## Sequence Number
2
## Request Method
post
## Request Path
/scrapbooks
## Request Header
{:auth_token=>"39894c72-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":"ORMQFILC"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"267"}

## Response Body
{
  "id": "398a8f06-5af9-11e2-ab45-b870f43f7835",
  "name": "ORMQFILC",
  "created_at": "2013-01-10T15:42:03+08:00",
  "updated_at": "2013-01-10T15:42:03+08:00",
  "_links": {
    "self": "/scrapbooks/398a8f06-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/39889782-5af9-11e2-ab45-b870f43f7835"
  }
}
