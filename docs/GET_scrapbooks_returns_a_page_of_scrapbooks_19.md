# API Procedure
GET /scrapbooks
## Expected Outcome
returns a page of scrapbooks
## Sequence Number
19
## Request Method
post
## Request Path
/scrapbooks
## Request Header
{:auth_token=>"395400b2-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":"LRHMBJBL"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"267"}

## Response Body
{
  "id": "3954edd8-5af9-11e2-ab45-b870f43f7835",
  "name": "LRHMBJBL",
  "created_at": "2013-01-10T15:42:02+08:00",
  "updated_at": "2013-01-10T15:42:02+08:00",
  "_links": {
    "self": "/scrapbooks/3954edd8-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/39318352-5af9-11e2-ab45-b870f43f7835"
  }
}
