# API Procedure
GET /scrapbooks
## Expected Outcome
returns a page of scrapbooks
## Sequence Number
17
## Request Method
post
## Request Path
/scrapbooks
## Request Header
{:auth_token=>"39513d50-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":"RKAPVCOC"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"267"}

## Response Body
{
  "id": "39522f12-5af9-11e2-ab45-b870f43f7835",
  "name": "RKAPVCOC",
  "created_at": "2013-01-10T15:42:02+08:00",
  "updated_at": "2013-01-10T15:42:02+08:00",
  "_links": {
    "self": "/scrapbooks/39522f12-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/39318352-5af9-11e2-ab45-b870f43f7835"
  }
}
