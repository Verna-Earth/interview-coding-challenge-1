# Getting started

If you're using VSCode or similar, run this up in a devcontainer; that will automatically install all your dependencies and set up the database. This includes a selection of useful, preconfigured, VSCode extensions.

Otherwise, you should be able to run this via `docker compose` and run it as a standalone pair of containers - the working folder is `/workspace`.

## Running the code

Once you have access to the code in its container, run `mix phx.server` to start the app. There is a single user in the database with an email of `lacks_imagination@hotmail.com`.