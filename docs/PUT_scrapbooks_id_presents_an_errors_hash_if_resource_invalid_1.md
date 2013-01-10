# API Procedure
PUT /scrapbooks/:id
## Expected Outcome
presents an errors hash if resource invalid
## Sequence Number
1
## Request Method
post
## Request Path
/scrapbooks
## Request Header
{:auth_token=>"39ab2f72-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":"AVLKSQYS"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"267"}

## Response Body
{
  "id": "39ac722e-5af9-11e2-ab45-b870f43f7835",
  "name": "AVLKSQYS",
  "created_at": "2013-01-10T15:42:03+08:00",
  "updated_at": "2013-01-10T15:42:03+08:00",
  "_links": {
    "self": "/scrapbooks/39ac722e-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/39aa79ce-5af9-11e2-ab45-b870f43f7835"
  }
}
