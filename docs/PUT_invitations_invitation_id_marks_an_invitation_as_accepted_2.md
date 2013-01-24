# API Procedure
PUT /invitations/:invitation_id
## Expected Outcome
marks an invitation as accepted
## Sequence Number
2
## Request Method
put
## Request Path
/invitations/24f047fc-5af9-11e2-bffe-b870f43f7835
## Request Header

## Request Body
{"first":"User","last":"111","email":"foo@foo.com","password":"changeme"}

## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"187"}

## Response Body
{
  "id": "24ff1f52-5af9-11e2-bffe-b870f43f7835",
  "name": "User 111",
  "first": "User",
  "last": "111",
  "mobile": null,
  "created_at": "2013-01-10T15:41:28+08:00",
  "updated_at": "2013-01-10T15:41:28+08:00"
}
