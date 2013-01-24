# API Procedure
POST /following/:followed_id
## Expected Outcome
makes the current user follow the other user
## Sequence Number
1
## Request Method
post
## Request Path
/following/1b92ccac-5af9-11e2-8807-b870f43f7835
## Request Header
{:auth_token=>"1b936310-5af9-11e2-8807-b870f43f7835"}
## Request Body


## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"211"}

## Response Body
{
  "id": "1b92ccac-5af9-11e2-8807-b870f43f7835",
  "name": "DJAFAKAO GBBYJDQQ",
  "first": "DJAFAKAO",
  "last": "GBBYJDQQ",
  "mobile": "OGIUHRJA",
  "created_at": "2013-01-10T15:41:13+08:00",
  "updated_at": "2013-01-10T15:41:13+08:00"
}
