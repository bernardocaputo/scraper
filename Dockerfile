FROM elixir:1.14-otp-25-slim

WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force \
  && apt-get update \
  && apt-get install -y inotify-tools \
  && apt-get install -y socat

COPY mix.exs mix.lock ./

RUN mix deps.get

COPY . /app

RUN mix do compile

EXPOSE 4000

CMD ["mix", "phx.server"]