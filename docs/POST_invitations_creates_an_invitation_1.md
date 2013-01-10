# API Procedure
POST /invitations
## Expected Outcome
creates an invitation
## Sequence Number
1
## Request Method
post
## Request Path
/invitations
## Request Header
{:auth_token=>"24de6f78-5af9-11e2-bffe-b870f43f7835"}
## Request Body
{"invited_name":"foo","invited_email":"foo@foo.com"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"318"}

## Response Body
{
  "id": "24dfc8fa-5af9-11e2-bffe-b870f43f7835",
  "invited_name": "foo",
  "invited_email": "foo@foo.com",
  "locale": "en",
  "created_at": "2013-01-10T15:41:28+08:00",
  "updated_at": "2013-01-10T15:41:28+08:00",
  "_links": {
    "self": "/invitations/24dfc8fa-5af9-11e2-bffe-b870f43f7835",
    "inviter": "/users/24ddac32-5af9-11e2-bffe-b870f43f7835"
  }
}
