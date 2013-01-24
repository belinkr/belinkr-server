# API Procedure
PUT /scrapbooks/:id
## Expected Outcome
presents an errors hash if resource invalid
## Sequence Number
2
## Request Method
put
## Request Path
/scrapbooks/39ac722e-5af9-11e2-ab45-b870f43f7835
## Request Header
{:auth_token=>"39ace6d2-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":"changed"}

## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"266"}

## Response Body
{
  "id": "39ac722e-5af9-11e2-ab45-b870f43f7835",
  "name": "changed",
  "created_at": "2013-01-10T15:42:03+08:00",
  "updated_at": "2013-01-10T15:42:03+08:00",
  "_links": {
    "self": "/scrapbooks/39ac722e-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/39aa79ce-5af9-11e2-ab45-b870f43f7835"
  }
}
