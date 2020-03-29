# CoronalyticsAPI

API build for the Coronalytics iOS app for #CodeVsCovid19 hackathon.

## Functionality

### Daily analytics data
 - GET, api/v1/daily_analytics

 returns:
```json
 [
   {
      "confirmed": 59989,
      "region": "Mainland China",
      "state": "Hubei",
      "recovered": 7862,
      "deaths": 1789,
      "id": 1,
      "lastUpdate": "2020-02-17T23:13:06"
  }
]
```

### Contact check
  - POST, api/v1/contacts/check_contact

  payload:
```json
  { "phone" : "123123123" }
```
  response:
```json
{
  "status": 0,
  "phone": "123123123"
}
```
status:
  - clear = 0
  - infected = 1
  - friendsInfected = 2

### Submit new infection case
  - POST, api/v1/contacts/newInfection

  payload:
```json
{
"infectedPhone" : "(555) 564-8583",
"friendsPhones" : [
"555-522-8243",
"555-522-8242",
"555-522-8241",
"555-522-8240"
]
}
```
