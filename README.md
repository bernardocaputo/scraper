## Scraper Phoenix LiveView APP

This application contains a Web Scrapping where you add a link and have all links listed contained on that page.

![GIF Recording 2023-12-07 at 1 01 09 PM](https://github.com/bernardocaputo/scraper/assets/17001577/c810f659-ee08-41a9-9be0-a5a73ecb29c5)

## Notes
  - For this project, I decided to use Phoenix Liveview. It is the lightest, easiest to maintain and most performant way without the need for any javascript framework/code (everything is done on the server-side).
  - Pagination for Link's listing
  - Scrapping done asynchronously
  - Realtime update of processed status

## Technologies used:
  - Elixir
  - Phoenix LiveView
  - For Web scrapping, I used the lib floki which is already used by the LiveView.

## System Requirements:
  - Docker

## Getting Started
  - Clone this project to your machine

```
git clone git@github.com:bernardocaputo/scraper.git
```

  - With docker initialized, build the image in your computer by running: 
```
cd scraper
docker-compose build
docker-compose run web mix ecto.create
docker-compose run web mix ecto.migrate
```

  - Finally run the container by typing:
```
docker-compose up
```

## Tests
  - To run tests, run the following command:
```
mix test
```
