# API Procedure
POST /workspaces/:workspace_id/administrators/:user_id
## Expected Outcome
assigns the administrator role to a existing user in the workspace
## Sequence Number
2
## Request Method
post
## Request Path
/workspaces/f7c10c38-5afa-11e2-8b59-b870f43f7835/administrators/f7bf2d5a-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"f7c2c492-5afa-11e2-8b59-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"211"}

## Response Body
{
  "id": "f7bf2d5a-5afa-11e2-8b59-b870f43f7835",
  "name": "XLGNNCFG OFOGVXGD",
  "first": "XLGNNCFG",
  "last": "OFOGVXGD",
  "mobile": "XTVPLMPC",
  "created_at": "2013-01-10T15:54:31+08:00",
  "updated_at": "2013-01-10T15:54:31+08:00"
}
