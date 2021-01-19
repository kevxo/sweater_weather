# Weather, Sweater?

## Project Description
 - You are a back-end developer working on a team that is building an application to plan road trips. This app will allow users to see the current weather as well as the forecasted weather at the destination.
  Your team is working in a service-oriented architecture. The front-end will communicate with your back-end through an API. Your job is to expose that API that satisfies the front-end team’s requirements.

## Learning Goals


- Expose an API that aggregates data from multiple external APIs
- Expose an API that requires an authentication token
- Expose an API for CRUD functionality
- Determine completion criteria based on the needs of other developers

- Research, select, and consume an API based on your needs as a developer
## Important Steps to Take:
  - fork repo and then clone to local.
  - Make sure you have rbenv install 2.5.3. and Rails version 5.2.4.3
  -  bundle install, rails db:{drop,create,migrate,seed}
  - Have postman and hit rails s in terminal. Use the endpoints below.

## Endpoints
 ### Retrieve weather for a city
  - GET /api/v1/forecast?location=denver,co


### Background Image for a city
  - GET /api/v1/backgrounds?location=denver,co

### User Registration

  - POST /api/v1/users
  - in Postman, under the address bar, click on “Body”, select “raw”, which will show a dropdown that probably says “Text” in it, choose “JSON” from the list.
  - Body should be like
  ``` javascript
{
  "email": "whatever@example.com",
  "password": "password",
  "password_confirmation": "password"
}
```

### User Login

  - POST /api/v1/sessions
  - in Postman, under the address bar, click on “Body”, select “raw”, which will show a dropdown that probably says “Text” in it, choose “JSON” from the list.
  - Body should be like
  ``` javascript
{
  "email": "whatever@example.com",
  "password": "password"
}
```

### Road Trip

  - POST /api/v1/road_trip
  - in Postman, under the address bar, click on “Body”, select “raw”, which will show a dropdown that probably says “Text” in it, choose “JSON” from the list.
  - Body should be like

``` javascript
{
  "origin": "Denver,CO",
  "destination": "Pueblo,CO",
  "api_key": "jgn983hy48thw9begh98h4539h4"
}
```