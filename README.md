Docker + Ruby on Rails.
===

## Composition
- db
  - PostgreSQL 10.5
- web
  - nginx 1.13
  - ruby 2.5.1
  - rails 5.2

## Build
> In first time of build.

```
# Set up rails.
$ cp .env.development .env
$ docker-compose run --rm web rails new . --database=postgresql
> Overwrite /app/Gemfile? y
$ sudo chown -R $USER:$USER .  # If building onto Linux.

# Build contianers.
$ docker-compose build

# Set configurations.
$ cp .provision/puma.init.rb config/puma.rb
$ cp .provision/database.init.yml config/database.yml

# Create databases.
$ docker-compose run --rm web rake db:create
$ docker-compose run --rm web rake db:create RAILS_ENV=production
```

## Deployment
```
$ docker-compose up

# Deploy as production.
$ vi .env
> RAILS_ENV=production
$ docker-compose up
```