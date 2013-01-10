# API Procedure
POST /scrapbooks
## Expected Outcome
creates a new scrapbook
## Sequence Number
1
## Request Method
post
## Request Path
/scrapbooks
## Request Header
{:auth_token=>"399ad942-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":"scrapbook 1"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"270"}

## Response Body
{
  "id": "399c1e1a-5af9-11e2-ab45-b870f43f7835",
  "name": "scrapbook 1",
  "created_at": "2013-01-10T15:42:03+08:00",
  "updated_at": "2013-01-10T15:42:03+08:00",
  "_links": {
    "self": "/scrapbooks/399c1e1a-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/399a2b96-5af9-11e2-ab45-b870f43f7835"
  }
}
