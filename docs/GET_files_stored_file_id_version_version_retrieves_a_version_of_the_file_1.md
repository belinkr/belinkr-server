# API Procedure
GET /files/:stored_file_id?version=:version
## Expected Outcome
retrieves a version of the file
## Sequence Number
1
## Request Method
post
## Request Path
/files
## Request Header
{:auth_token=>"06614098-5af9-11e2-8121-b870f43f7835"}
## Request Body
{:file=>#<Rack::Test::UploadedFile:0x00000004472a58 @content_type="image/png", @original_filename="logo.png", @tempfile=#<File:/tmp/logo.png20130110-26283-1q3xo3z>>}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"406"}

## Response Body
{
  "id": "0662bc48-5af9-11e2-8121-b870f43f7835",
  "mime_type": "image/png",
  "original_filename": "logo.png",
  "created_at": "2013-01-10T15:40:37+08:00",
  "updated_at": "2013-01-10T15:40:37+08:00",
  "_links": {
    "self": "/files/0662bc48-5af9-11e2-8121-b870f43f7835",
    "mini": "#/files/0662bc48-5af9-11e2-8121-b870f43f7835?version=mini&inline=true",
    "small": "#/files/0662bc48-5af9-11e2-8121-b870f43f7835?version=small&inline=true"
  }
}
