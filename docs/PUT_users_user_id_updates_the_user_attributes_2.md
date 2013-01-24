# API Procedure
PUT /users/:user_id
## Expected Outcome
updates the user attributes
## Sequence Number
2
## Request Method
put
## Request Path
/users/0a426a38-5afa-11e2-b6d2-b870f43f7835
## Request Header
{:auth_token=>"0a44f51e-5afa-11e2-b6d2-b870f43f7835"}
## Request Body
{"first":"changed","mobile":"changed"}

## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"250"}

## Response Body
{
  "id": "0a426a38-5afa-11e2-b6d2-b870f43f7835",
  "name": "QIGMRCHT KNMIDTHS",
  "first": "changed",
  "last": "KNMIDTHS",
  "mobile": "changed",
  "created_at": "2013-01-10T15:47:53+08:00",
  "updated_at": "2013-01-10T15:47:53+08:00",
  "deleted_at": "2013-01-10T15:47:53+08:00"
}
