# API Procedure
GET /workspaces/:workspace_id/invitations/:invitation_id
## Expected Outcome
retrieves an invitation
## Sequence Number
3
## Request Method
get
## Request Path
/workspaces/f7341dfa-5afa-11e2-8b59-b870f43f7835/invitations/f73e743a-5afa-11e2-8b59-b870f43f7835
## Request Header
{:auth_token=>"f73f73ee-5afa-11e2-8b59-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "f73e743a-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:31+08:00",
  "updated_at": "2013-01-10T15:54:31+08:00"
}
