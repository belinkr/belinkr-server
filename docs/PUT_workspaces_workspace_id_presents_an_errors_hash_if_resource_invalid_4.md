# API Procedure
PUT /workspaces/:workspace_id
## Expected Outcome
presents an errors hash if resource invalid
## Sequence Number
4
## Request Method
put
## Request Path
/workspaces/f8a7d3f2-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"f8a98cec-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":""}

## Response Status
400
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"358"}

## Response Body
{
  "id": "f8a7d3f2-5afa-11e2-8b59-b870f43f7835",
  "name": "",
  "entity_id": "c5cb6496-0b6f-4744-96c1-da5cf5f586ef",
  "created_at": "2013-01-10T15:54:33+08:00",
  "updated_at": "2013-01-10T15:54:33+08:00",
  "errors": [
    "name must not be blank",
    "name must be between 1 and 250 characters long"
  ],
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
