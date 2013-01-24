# API Procedure
POST /workspaces/:workspace_id
                 /autoinvitations/rejected/:autoinvitation_id
## Expected Outcome
rejects an autoinvitation
## Sequence Number
1
## Request Method
post
## Request Path
/workspaces
## Request Header
{:auth_token=>"f7940d8c-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"name":"UBLRDELY"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"281"}

## Response Body
{
  "id": "f7954db4-5afa-11e2-8b59-b870f43f7835",
  "name": "UBLRDELY",
  "entity_id": "f4dd483e-2a39-4f9e-bcfe-b6f360ce4a7a",
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
