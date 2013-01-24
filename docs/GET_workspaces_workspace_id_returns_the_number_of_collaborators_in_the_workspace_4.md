# API Procedure
GET /workspaces/:workspace_id
## Expected Outcome
returns the number of collaborators in the workspace
## Sequence Number
4
## Request Method
get
## Request Path
/workspaces/ebc7cf84-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"ebc98306-5afa-11e2-8b59-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"281"}

## Response Body
{
  "id": "ebc7cf84-5afa-11e2-8b59-b870f43f7835",
  "name": "PPVKUKOS",
  "entity_id": "2cc80907-8a67-49c7-8b88-55df2e189b95",
  "created_at": "2013-01-10T15:54:11+08:00",
  "updated_at": "2013-01-10T15:54:11+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
