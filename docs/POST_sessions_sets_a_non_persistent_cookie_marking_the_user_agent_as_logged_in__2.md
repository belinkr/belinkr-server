# API Procedure
POST /sessions
## Expected Outcome
sets a non-persistent cookie marking the user-agent as "logged in"
## Sequence Number
2
## Request Method
post
## Request Path
/sessions
## Request Header

## Request Body
{"email":"ABXWKUCR@belinkr.com","password":"test","remember":true}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/\nbelinkr.auth_token=41aa14b8-5af9-11e2-addf-b870f43f7835; path=/\nbelinkr.remember=41aa14b8-5af9-11e2-addf-b870f43f7835; path=/; expires=Thu, 17-Jan-2013 07:42:17 GMT\nrack.session=c51b2e8f3a81863b800599d888741b0a51274b4f4d44178075516ca37fc1d4e8; path=/; HttpOnly","Content-Length":"279"}

## Response Body
{
  "id": "41aa14b8-5af9-11e2-addf-b870f43f7835",
  "user_id": "41a81ff0-5af9-11e2-addf-b870f43f7835",
  "profile_id": "839ffbf4-162a-4a6a-8c5d-1b025facedbc",
  "entity_id": "4bc39bfa-f436-4baa-993d-bb50c1b314da",
  "created_at": "2013-01-10T15:42:16+08:00",
  "updated_at": "2013-01-10T15:42:16+08:00"
}
