# API Procedure
DELETE /files/:id
## Expected Outcome
deletes a file
## Sequence Number
1
## Request Method
post
## Request Path
/files
## Request Header
{:auth_token=>"0614fc92-5af9-11e2-8121-b870f43f7835"}
## Request Body
{:file=>#<Rack::Test::UploadedFile:0x00000004425320 @content_type="text/plain", @original_filename="foo.txt", @tempfile=#<File:/tmp/foo.txt20130110-26283-j7xhlx>>}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"246"}

## Response Body
{
  "id": "062c7c6e-5af9-11e2-8121-b870f43f7835",
  "mime_type": "text/plain",
  "original_filename": "foo.txt",
  "created_at": "2013-01-10T15:40:37+08:00",
  "updated_at": "2013-01-10T15:40:37+08:00",
  "_links": {
    "self": "/files/062c7c6e-5af9-11e2-8121-b870f43f7835"
  }
}
