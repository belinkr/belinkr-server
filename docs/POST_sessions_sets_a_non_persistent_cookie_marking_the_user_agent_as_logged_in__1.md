# API Procedure
POST /sessions
## Expected Outcome
sets a non-persistent cookie marking the user-agent as "logged in"
## Sequence Number
1
## Request Method
post
## Request Path
/sessions
## Request Header

## Request Body
{"email":"FQLGLKCG@belinkr.com","password":"test","remember":true}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/\nbelinkr.auth_token=418afa38-5af9-11e2-addf-b870f43f7835; path=/\nbelinkr.remember=418afa38-5af9-11e2-addf-b870f43f7835; path=/; expires=Thu, 17-Jan-2013 07:42:16 GMT\nrack.session=c19559fcebbbc8d6596b7fb3ba76ec0c2bec410f14cb442086a882d58d974fd8; path=/; HttpOnly","Content-Length":"279"}

## Response Body
{
  "id": "418afa38-5af9-11e2-addf-b870f43f7835",
  "user_id": "4188fdfa-5af9-11e2-addf-b870f43f7835",
  "profile_id": "684e1521-fc5f-4d6a-a87b-4f9760fcf3f7",
  "entity_id": "b7084570-c5b6-49ae-ad88-aeba1660d31a",
  "created_at": "2013-01-10T15:42:16+08:00",
  "updated_at": "2013-01-10T15:42:16+08:00"
}
