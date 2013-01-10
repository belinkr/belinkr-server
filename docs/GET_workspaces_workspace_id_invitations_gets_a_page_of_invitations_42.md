# API Procedure
GET /workspaces/:workspace_id/invitations
## Expected Outcome
gets a page of invitations
## Sequence Number
42
## Request Method
post
## Request Path
/workspaces/f3ac9f0e-5afa-11e2-8b59-b870f43f7835/invitations
## Request Header
{:auth_token=>"f67358e0-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"invited_id":"f6730dcc-5afa-11e2-8b59-b870f43f7835"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "f6749656-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:29+08:00",
  "updated_at": "2013-01-10T15:54:29+08:00"
}
