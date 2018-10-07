# Dockerfile
FROM    ruby:2.5.1
RUN     apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Setup nginx.
RUN     apt-get install -y nginx
COPY    .provision/nginx.conf /etc/nginx/sites-available/app.conf
RUN     rm -f /etc/nginx/sites-enabled/default && \
        ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app.conf

# Build rails.
RUN     mkdir /app
COPY    Gemfile /app/Gemfile
COPY    Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN     bundle install
COPY    . /app