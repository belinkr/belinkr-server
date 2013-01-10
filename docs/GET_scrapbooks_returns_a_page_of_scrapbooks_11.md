# API Procedure
GET /scrapbooks
## Expected Outcome
returns a page of scrapbooks
## Sequence Number
11
## Request Method
post
## Request Path
/scrapbooks
## Request Header
{:auth_token=>"3947a8d0-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":"SESWGMGB"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"267"}

## Response Body
{
  "id": "3948c0a8-5af9-11e2-ab45-b870f43f7835",
  "name": "SESWGMGB",
  "created_at": "2013-01-10T15:42:02+08:00",
  "updated_at": "2013-01-10T15:42:02+08:00",
  "_links": {
    "self": "/scrapbooks/3948c0a8-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/39318352-5af9-11e2-ab45-b870f43f7835"
  }
}
