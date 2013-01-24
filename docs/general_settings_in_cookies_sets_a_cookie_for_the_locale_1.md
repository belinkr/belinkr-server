# API Procedure
general settings in cookies
## Expected Outcome
sets a cookie for the locale
## Sequence Number
1
## Request Method
post
## Request Path
/sessions
## Request Header

## Request Body
{"email":"AYOIDXBA@belinkr.com","password":"test"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/\nbelinkr.auth_token=42138b0a-5af9-11e2-addf-b870f43f7835; path=/\nrack.session=c1b7ec2a9739abacf5a745b67ba276564d7110d4b8439d696bc0a925d0679a93; path=/; HttpOnly","Content-Length":"279"}

## Response Body
{
  "id": "42138b0a-5af9-11e2-addf-b870f43f7835",
  "user_id": "4211a5ec-5af9-11e2-addf-b870f43f7835",
  "profile_id": "4d83be3a-ad76-4941-8d5f-b0bf6e597f39",
  "entity_id": "385182bd-7139-4d17-a06c-ca29acab1c44",
  "created_at": "2013-01-10T15:42:17+08:00",
  "updated_at": "2013-01-10T15:42:17+08:00"
}
