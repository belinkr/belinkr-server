# API Procedure
GET /workspaces/:workspace_id/invitations
## Expected Outcome
gets a page of invitations
## Sequence Number
11
## Request Method
post
## Request Path
/workspaces/f3ac9f0e-5afa-11e2-8b59-b870f43f7835/invitations
## Request Header
{:auth_token=>"f458745a-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"invited_id":"f4582d24-5afa-11e2-8b59-b870f43f7835"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "f459b626-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:26+08:00",
  "updated_at": "2013-01-10T15:54:26+08:00"
}
