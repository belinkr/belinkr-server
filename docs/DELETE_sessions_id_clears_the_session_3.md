# API Procedure
DELETE /sessions/:id
## Expected Outcome
clears the session
## Sequence Number
3
## Request Method
post
## Request Path
/sessions
## Request Header

## Request Body
{"email":"AVYALIOH@belinkr.com","password":"test","remember":true}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.auth_token=; path=/; expires=Thu, 01-Jan-1970 00:00:00 GMT\nbelinkr.auth_token=416285ee-5af9-11e2-addf-b870f43f7835; path=/\nbelinkr.remember=416285ee-5af9-11e2-addf-b870f43f7835; path=/; expires=Thu, 17-Jan-2013 07:42:16 GMT","Content-Length":"279"}

## Response Body
{
  "id": "416285ee-5af9-11e2-addf-b870f43f7835",
  "user_id": "416108e0-5af9-11e2-addf-b870f43f7835",
  "profile_id": "347b8a56-1e25-410c-803c-2c06e261e3bf",
  "entity_id": "73c11608-d74a-48ab-bba9-682e882d7ea3",
  "created_at": "2013-01-10T15:42:16+08:00",
  "updated_at": "2013-01-10T15:42:16+08:00"
}
