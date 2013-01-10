# API Procedure
GET /autocomplete/scrapbooks
## Expected Outcome
Get Scrapbook List Match query
## Sequence Number
1
## Request Method
get
## Request Path
/autocomplete/scrapbooks?q=HOHEJRIT
## Request Header
{:auth_token=>"f7f4a162-5af8-11e2-bf31-b870f43f7835"}
## Request Body


## Response Status
200
## Response Header
{"Content-Type":"text/html;charset=utf-8","X-XSS-Protection":"1; mode=block","X-Content-Type-Options":"nosniff","Set-Cookie":"belinkr.locale=en; path=/","Content-Length":"269"}

## Response Body
[
  {
    "id": "6f96f010-5b27-4887-9d0e-4d3e493bbdf3",
    "name": "HOHEJRIT",
    "created_at": "2013-01-10T15:40:13+08:00",
    "updated_at": "2013-01-10T15:40:13+08:00",
    "_links": {
      "self": "/scrapbooks/6f96f010-5b27-4887-9d0e-4d3e493bbdf3",
      "user": "/users/f7ebad1e-5af8-11e2-bf31-b870f43f7835"
    }
  }
]
