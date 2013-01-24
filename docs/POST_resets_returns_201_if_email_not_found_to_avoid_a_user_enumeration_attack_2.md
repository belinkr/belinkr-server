# API Procedure
POST /resets
## Expected Outcome
returns 201 if email not found, to avoid a user enumeration attack
## Sequence Number
2
## Request Method
post
## Request Path
/resets
## Request Header

## Request Body
{"email":"nonexistent@belinkr.com"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"0"}

## Response Body

