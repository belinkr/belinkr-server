# API Procedure
POST /workspaces/:workspace_id/invitations/accepted/:invitation_id
## Expected Outcome
accepts an invitation
## Sequence Number
2
## Request Method
post
## Request Path
/workspaces/f852265a-5afa-11e2-8b59-b870f43f7835/invitations
## Request Header
{:auth_token=>"f853dcde-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"invited_id":"f85053d4-5afa-11e2-8b59-b870f43f7835"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "f8551c3e-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:32+08:00",
  "updated_at": "2013-01-10T15:54:32+08:00"
}
