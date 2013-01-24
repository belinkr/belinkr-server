# API Procedure
GET /workspaces/:workspace_id
                /autoinvitations/:autoinvitation_id
## Expected Outcome
retrieves an autoinvitation
## Sequence Number
2
## Request Method
post
## Request Path
/workspaces/ec39ae38-5afa-11e2-8b59-b870f43f7835/autoinvitations
## Request Header
{:auth_token=>"ec3b66d8-5afa-11e2-8b59-b870f43f7835"}
## Request Body
{"autoinvited_id":"ec37d81a-5afa-11e2-8b59-b870f43f7835"}

## Response Status
201
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Content-Length":"164"}

## Response Body
{
  "id": "ec3c8658-5afa-11e2-8b59-b870f43f7835",
  "state": "pending",
  "rejected_at": null,
  "created_at": "2013-01-10T15:54:12+08:00",
  "updated_at": "2013-01-10T15:54:12+08:00"
}
