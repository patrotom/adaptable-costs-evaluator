# Extend from the official Elixir image
FROM elixir:1.13.0

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install OS packages
RUN apt update
RUN apt install --yes build-essential inotify-tools postgresql-client

# Install Elixir packages
RUN mix local.hex --force
RUN mix local.rebar --force

# Get the dependencies and compile the project
RUN mix deps.get
RUN mix do compile

# Run the app
CMD ["/app/scripts/entrypoint.sh"]
