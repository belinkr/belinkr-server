# API Procedure
POST  /workspaces/:workspace_id
                  /autoinvitations/accepted/:autoinvitation_id
## Expected Outcome
accepts an autoinvitation
## Sequence Number
2
## Request Method
post
## Request Path
/workspaces/f75edc34-5afa-11e2-8b59-b870f43f7835/autoinvitations
## Request Header
{:auth_token=>"f7609538-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"autoinvited_id":"f75d0044-5afa-11e2-8b59-b870f43f7835"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "f761a91e-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:31+08:00",
  "updated_at": "2013-01-10T15:54:31+08:00"
}
