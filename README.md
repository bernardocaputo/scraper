## Score Phoenix LiveView APP

This application contains a Web Scrapping where you add a link and have all links listed contained on that page.

## Notes
  - For this project, I decided to use Phoenix Liveview. It is the lightest, easiest to maintain and most performant way without the need for any javascript framework/code (everything is done on the server-side).



## Technologies used:
  - Elixir
  - Phoenix LiveView

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
