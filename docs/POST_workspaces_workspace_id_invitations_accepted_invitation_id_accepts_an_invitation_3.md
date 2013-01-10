# API Procedure
POST /workspaces/:workspace_id/invitations/accepted/:invitation_id
## Expected Outcome
accepts an invitation
## Sequence Number
3
## Request Method
post
## Request Path
/workspaces/f852265a-5afa-11e2-8b59-b870f43f7835/invitations/accepted/f8551c3e-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"f8560ee6-5afa-11e2-8b59-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"165"}

## Response Body
{
  "id": "f8551c3e-5afa-11e2-8b59-b870f43f7835",
  "state": "accepted",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:32+08:00",
  "updated_at": "2013-01-10T15:54:32+08:00"
}
