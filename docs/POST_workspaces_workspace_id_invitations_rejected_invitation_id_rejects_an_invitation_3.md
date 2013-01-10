# API Procedure
POST /workspaces/:workspace_id/invitations/rejected/:invitation_id
## Expected Outcome
rejects an invitation
## Sequence Number
3
## Request Method
post
## Request Path
/workspaces/f87ea400-5afa-11e2-8b59-b870f43f7835/invitations/rejected/f881a52e-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"f882a140-5afa-11e2-8b59-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"188"}

## Response Body
{
  "id": "f881a52e-5afa-11e2-8b59-b870f43f7835",
  "state": "rejected",
  "rejected_at": "2013-01-10T15:54:33+08:00",
  "created_at": "2013-01-10T15:54:33+08:00",
  "updated_at": "2013-01-10T15:54:33+08:00"
}
