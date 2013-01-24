# API Procedure
DELETE /following/:followed_id
## Expected Outcome
makes the current user unfollow the other user
## Sequence Number
1
## Request Method
post
## Request Path
/following/1b0bfd44-5af9-11e2-8807-b870f43f7835
## Request Header
{:auth_token=>"1b0cb19e-5af9-11e2-8807-b870f43f7835"}
## Request Body


## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"211"}

## Response Body
{
  "id": "1b0bfd44-5af9-11e2-8807-b870f43f7835",
  "name": "ECYLFDOC UNRABGXE",
  "first": "ECYLFDOC",
  "last": "UNRABGXE",
  "mobile": "YIKGOKGL",
  "created_at": "2013-01-10T15:41:12+08:00",
  "updated_at": "2013-01-10T15:41:12+08:00"
}
