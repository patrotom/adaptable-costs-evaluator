#!/bin/bash

# Create the database if it doesn't exist yet, run the migrations, and seed the database.
if [[ -z $(psql -Atqc "\\list $PGDATABASE") ]]; then
    mix ecto.create
    mix ecto.migrate
    mix run priv/repo/seeds.exs
fi

mix phx.server
