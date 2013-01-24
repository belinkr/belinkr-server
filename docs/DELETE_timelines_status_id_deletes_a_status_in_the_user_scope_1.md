# API Procedure
DELETE /timelines/:status_id
## Expected Outcome
deletes a status in the user scope
## Sequence Number
1
## Request Method
post
## Request Path
/statuses
## Request Header
{:auth_token=>"971c6b30-5af9-11e2-8ecd-b870f43f7835"}
## Request Body
{"text":"test"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"152"}

## Response Body
{
  "id": "97347fb8-5af9-11e2-8ecd-b870f43f7835",
  "text": "test",
  "files": [

  ],
  "created_at": "2013-01-10T15:44:40+08:00",
  "updated_at": "2013-01-10T15:44:40+08:00"
}
