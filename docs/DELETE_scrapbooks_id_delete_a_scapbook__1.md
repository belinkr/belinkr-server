# API Procedure
DELETE /scrapbooks/:id
## Expected Outcome
delete a scapbook 
## Sequence Number
1
## Request Method
post
## Request Path
/scrapbooks
## Request Header
{:auth_token=>"390779ae-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":"LQLESNLS"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"267"}

## Response Body
{
  "id": "39211396-5af9-11e2-ab45-b870f43f7835",
  "name": "LQLESNLS",
  "created_at": "2013-01-10T15:42:02+08:00",
  "updated_at": "2013-01-10T15:42:02+08:00",
  "_links": {
    "self": "/scrapbooks/39211396-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/39023700-5af9-11e2-ab45-b870f43f7835"
  }
}
