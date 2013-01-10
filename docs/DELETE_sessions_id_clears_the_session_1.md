# API Procedure
DELETE /sessions/:id
## Expected Outcome
clears the session
## Sequence Number
1
## Request Method
post
## Request Path
/sessions
## Request Header

## Request Body
{"email":"JOGOIHXF@belinkr.com","password":"test"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/\nbelinkr.auth_token=41421aa2-5af9-11e2-addf-b870f43f7835; path=/\nrack.session=651fb714200d83ab1c8948ce3a96a614ab99970ef6b758a9f55e6c95df046f10; path=/; HttpOnly","Content-Length":"279"}

## Response Body
{
  "id": "41421aa2-5af9-11e2-addf-b870f43f7835",
  "user_id": "41263bfc-5af9-11e2-addf-b870f43f7835",
  "profile_id": "52669582-dc05-4d7a-8d38-c52c16963516",
  "entity_id": "5b4d004c-edbe-4005-a80f-047130cd9dcd",
  "created_at": "2013-01-10T15:42:16+08:00",
  "updated_at": "2013-01-10T15:42:16+08:00"
}
