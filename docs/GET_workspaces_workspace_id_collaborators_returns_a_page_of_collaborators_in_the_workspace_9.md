# API Procedure
GET /workspaces/:workspace_id/collaborators
## Expected Outcome
returns a page of collaborators in the workspace
## Sequence Number
9
## Request Method
post
## Request Path
/workspaces/f1bd5742-5afa-11e2-8b59-b870f43f7835/collaborators/f24ce682-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"f24d7ebc-5afa-11e2-8b59-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"211"}

## Response Body
{
  "id": "f24ce682-5afa-11e2-8b59-b870f43f7835",
  "name": "IBVIJAAJ LXTYOKDL",
  "first": "IBVIJAAJ",
  "last": "LXTYOKDL",
  "mobile": "DKHSBFGO",
  "created_at": "2013-01-10T15:54:22+08:00",
  "updated_at": "2013-01-10T15:54:22+08:00"
}
