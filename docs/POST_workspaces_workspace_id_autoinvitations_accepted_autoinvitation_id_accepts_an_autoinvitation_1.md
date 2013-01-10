# API Procedure
POST  /workspaces/:workspace_id
                  /autoinvitations/accepted/:autoinvitation_id
## Expected Outcome
accepts an autoinvitation
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f75d91c6-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"WCQYDNGU"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f75edc34-5afa-11e2-8b59-b870f43f7835",
  "name": "WCQYDNGU",
  "entity_id": "f1d2b675-e38f-42ee-8383-1a7c36f1976e",
  "created_at": "2013-01-10T15:54:31+08:00",
  "updated_at": "2013-01-10T15:54:31+08:00",
  "counters": {
    "users": 0,
    "collaborators": 0,
    "administrators": 1,
    "statuses": 0
  },
  "_links": {
  }
}
