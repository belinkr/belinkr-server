# API Procedure
PUT /scrapbooks/:id
## Expected Outcome
presents an errors hash if resource invalid
## Sequence Number
4
## Request Method
put
## Request Path
/scrapbooks/39be1998-5af9-11e2-ab45-b870f43f7835
## Request Header
{:auth_token=>"39c6964a-5af9-11e2-ab45-b870f43f7835"}
## Request Body
{"name":""}

## Response Status
400
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"344"}

## Response Body
{
  "id": "39be1998-5af9-11e2-ab45-b870f43f7835",
  "name": "",
  "created_at": "2013-01-10T15:42:03+08:00",
  "updated_at": "2013-01-10T15:42:03+08:00",
  "errors": [
    "name must not be blank",
    "name must be between 1 and 250 characters long"
  ],
  "_links": {
    "self": "/scrapbooks/39be1998-5af9-11e2-ab45-b870f43f7835",
    "user": "/users/39bc264c-5af9-11e2-ab45-b870f43f7835"
  }
}
