# API Procedure
POST /workspaces/:workspace_id/invitations
## Expected Outcome
creates an invitation
## Sequence Number
2
## Request Method
post
## Request Path
/workspaces/f821dae0-5afa-11e2-8b59-b870f43f7835/invitations
## Request Header
{:auth_token=>"f831b55a-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"invited_id":"f8316a78-5afa-11e2-8b59-b870f43f7835"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "f832f604-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:32+08:00",
  "updated_at": "2013-01-10T15:54:32+08:00"
}
