# API Procedure
GET /workspaces/:workspace_id/autoinvitations
## Expected Outcome
gets a page of autoinvitations
## Sequence Number
9
## Request Method
post
## Request Path
/workspaces/ee3da716-5afa-11e2-8b59-b870f43f7835/autoinvitations
## Request Header
{:auth_token=>"eec862de-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"autoinvited_id":"eec7cb8a-5afa-11e2-8b59-b870f43f7835"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "eec971e2-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:16+08:00",
  "updated_at": "2013-01-10T15:54:16+08:00"
}
