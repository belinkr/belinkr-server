# API Procedure
POST /sessions
## Expected Outcome
sets a non-persistent cookie marking the user-agent as "logged in"
## Sequence Number
3
## Request Method
post
## Request Path
/sessions
## Request Header

## Request Body
{"email":"CVFMNLQM@belinkr.com","password":"test"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/\nbelinkr.auth_token=41c8f090-5af9-11e2-addf-b870f43f7835; path=/\nrack.session=8401ab3b82d293f71ac84c004ce1bba4b446f6dabec9666a51b0cb1c14da221a; path=/; HttpOnly","Content-Length":"279"}

## Response Body
{
  "id": "41c8f090-5af9-11e2-addf-b870f43f7835",
  "user_id": "41c6f2cc-5af9-11e2-addf-b870f43f7835",
  "profile_id": "e4b9301a-1fee-4aca-925b-96bb2aa387c6",
  "entity_id": "f81af8dd-1ad0-47fc-bcfa-7988688dfd95",
  "created_at": "2013-01-10T15:42:17+08:00",
  "updated_at": "2013-01-10T15:42:17+08:00"
}
