# API Procedure
auth_token HTTP params
## Expected Outcome
gets the auth_token from params for Flash uploads
## Sequence Number
1
## Request Method
post
## Request Path
/sessions
## Request Header

## Request Body
{"email":"YBCGHFNI@belinkr.com","password":"test"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/\nbelinkr.auth_token=41ea993e-5af9-11e2-addf-b870f43f7835; path=/\nrack.session=edc6bc2bfad6ba2456bbdae35a8b6d0a18c76dc7067706fbd0f28c3fcfc8ac8e; path=/; HttpOnly","Content-Length":"279"}

## Response Body
{
  "id": "41ea993e-5af9-11e2-addf-b870f43f7835",
  "user_id": "41e8ce38-5af9-11e2-addf-b870f43f7835",
  "profile_id": "47b4e6f0-996b-4263-8445-adb1a09b3a9d",
  "entity_id": "9d51c66c-8691-43d4-b464-2626ae2bcc42",
  "created_at": "2013-01-10T15:42:17+08:00",
  "updated_at": "2013-01-10T15:42:17+08:00"
}
