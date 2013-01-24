# API Procedure
POST /following/:followed_id
## Expected Outcome
makes the current user follow the other user
## Sequence Number
3
## Request Method
get
## Request Path
/followers
## Request Header
{:auth_token=>"1b9851d6-5af9-11e2-8807-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"213"}

## Response Body
[
  {
    "id": "1b845b22-5af9-11e2-8807-b870f43f7835",
    "name": "KMVRIWKS ORRBPCWF",
    "first": "KMVRIWKS",
    "last": "ORRBPCWF",
    "mobile": "URERODOG",
    "created_at": "2013-01-10T15:41:12+08:00",
    "updated_at": "2013-01-10T15:41:12+08:00"
  }
]
