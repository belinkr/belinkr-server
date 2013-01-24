# API Procedure
POST /workspaces/:workspace_id
                 /autoinvitations/rejected/:autoinvitation_id
## Expected Outcome
rejects an autoinvitation
## Sequence Number
3
## Request Method
post
## Request Path
/workspaces/f7954db4-5afa-11e2-8b59-b870f43f7835/autoinvitations/rejected/f79fb560-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"f7a094bc-5afa-11e2-8b59-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"188"}

## Response Body
{
  "id": "f79fb560-5afa-11e2-8b59-b870f43f7835",
  "state": "rejected",
  "rejected_at": "2013-01-10T15:54:31+08:00",
  "created_at": "2013-01-10T15:54:31+08:00",
  "updated_at": "2013-01-10T15:54:31+08:00"
}
