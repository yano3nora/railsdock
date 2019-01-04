Docker + Ruby on Rails.
===

## Requirements
- docker
- docker-compose

## Containers
- db
  - PostgreSQL 10.5 ( On development )
- web
  - ruby 2.5.3
  - rails 5.2
  - nginx 1.14

## Build
> In the first time of build.

```
# Set up env.
$ cp .env.development .env
$ vi .env  # Edit SMTP / RAILS_MASTER_KEY
$ docker-compose run --rm web rails new . --database=postgresql
> Overwrite /app/Gemfile? y
$ sudo chown -R $USER:$USER .  # If building onto Linux.

# Set configurations.
$ cp .provisions/**/*.* config/*
$ rm -rf .provisions

# Build containers.
$ docker-compose run --rm web bundle install
$ docker-compose build

# Create databases.
$ docker-compose run --rm web rake db:setup
$ docker-compose up -d
```

## Deployment
### On Development
```
$ docker-compose up     # Attach mode.
$ docker-compose up -d  # Detach mode.

# Accessing to docker-machine IP via 80 port by your browser.
# Retry after one moment please if you received 5xx response.
```

#### Commands
```
# Re-setup Database.
$ docker-compose run --rm web rake db:drop
$ docker-compose run --rm web rake db:create
$ docker-compose run --rm web rake db:migrate
$ docker-compose run --rm web rake db:seed

# Clear log / cache.
$ docker-compose run --rm web rake tmp:cache:clear
$ docker-compose run --rm web rake log:clear

# Launch bash.
$ docker-compose exec web bash

# Shutdown containers.
$ docker-compose down


# Add Migrations.
$ docker-compose run --rm web rails g model Article subject:string body:text user:references
$ docker-compose run --rm web rake db:migrate

# Add Packages.
$ vi Gemfile
> gem 'seedbank'
$ docker-compose run --rm web bundle install
$ docker-compose build
```

### On Production
```
# Login Heroku & Heroku Container Registry.
$ heroku login
$ heroku auth:token
> xxxx-xxxx-xxxx-xxxx
$ docker login registry.heroku.com
> Username: heroku-user-name
> Password: xxxx-xxxx-xxxx-xxxx

# Setting environment variables.
# @see     .env.development
# @see     https://dashboard.heroku.com/apps/${APP_NAME}/settings
# @exapmle $ heroku config:set RAILS_ENV=production
#          $ heroku config:set RAILS_MASTER_KEY=xxxxxxxxxx
#          $ heroku config:set DATABASE_URL=xxxxxxxxxxxxxx
$ cp .env.development .env  # Generate dummy .env file for production.

# Setup front-end files before container building.
# e.g. ) $ npm run build

# Push & Release Container onto Heroku Container Registry
$ heroku container:push web -a ${APP_NAME} --arg RAILS_ENV=production,DOMAIN=${APP_DOMAIN}
$ heroku container:release web -a ${APP_NAME}

# Reset & Migrate Database ( If you need ).
# @see https://dashboard.heroku.com/apps/${APP_NAME}/settings
$ heroku pg:reset DATABASE_URL -a ${APP_NAME}
$ heroku run -a ${APP_NAME} rake db:migrate
$ heroku run -a ${APP_NAME} rake db:seed
```
