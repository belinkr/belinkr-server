# API Procedure
POST /workspaces/:workspace_id/invitations/rejected/:invitation_id
## Expected Outcome
rejects an invitation
## Sequence Number
2
## Request Method
post
## Request Path
/workspaces/f87ea400-5afa-11e2-8b59-b870f43f7835/invitations
## Request Header
{:auth_token=>"f8806254-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"invited_id":"f87cb578-5afa-11e2-8b59-b870f43f7835"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "f881a52e-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:33+08:00",
  "updated_at": "2013-01-10T15:54:33+08:00"
}
