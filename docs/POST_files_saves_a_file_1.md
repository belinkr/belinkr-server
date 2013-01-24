# API Procedure
POST /files
## Expected Outcome
saves a file
## Sequence Number
1
## Request Method
post
## Request Path
/files
## Request Header
{:auth_token=>"06741132-5af9-11e2-8121-b870f43f7835"}
## Request Body
{:file=>#<Rack::Test::UploadedFile:0x000000047f80d8 @content_type="image/png", @original_filename="logo.png", @tempfile=#<File:/tmp/logo.png20130110-26283-4up83s>>}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"406"}

## Response Body
{
  "id": "067582ec-5af9-11e2-8121-b870f43f7835",
  "mime_type": "image/png",
  "original_filename": "logo.png",
  "created_at": "2013-01-10T15:40:37+08:00",
  "updated_at": "2013-01-10T15:40:37+08:00",
  "_links": {
    "self": "/files/067582ec-5af9-11e2-8121-b870f43f7835",
    "mini": "#/files/067582ec-5af9-11e2-8121-b870f43f7835?version=mini&inline=true",
    "small": "#/files/067582ec-5af9-11e2-8121-b870f43f7835?version=small&inline=true"
  }
}
