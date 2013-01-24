# API Procedure
auth_token HTTP params
## Expected Outcome
gets the auth_token from params for Flash uploads
## Sequence Number
2
## Request Method
post
## Request Path
/files?auth_token=41ea993e-5af9-11e2-addf-b870f43f7835
## Request Header

## Request Body
{:file=>#<Rack::Test::UploadedFile:0x000000038123d0 @content_type="image/png", @original_filename="logo.png", @tempfile=#<File:/tmp/logo.png20130110-26528-nie5jg>>}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"406"}

## Response Body
{
  "id": "41fa782c-5af9-11e2-addf-b870f43f7835",
  "mime_type": "image/png",
  "original_filename": "logo.png",
  "created_at": "2013-01-10T15:42:17+08:00",
  "updated_at": "2013-01-10T15:42:17+08:00",
  "_links": {
    "self": "/files/41fa782c-5af9-11e2-addf-b870f43f7835",
    "mini": "#/files/41fa782c-5af9-11e2-addf-b870f43f7835?version=mini&inline=true",
    "small": "#/files/41fa782c-5af9-11e2-addf-b870f43f7835?version=small&inline=true"
  }
}
