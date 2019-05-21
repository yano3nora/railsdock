FROM    ruby:2.5.3
RUN     apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ARG     RAILS_ENV
ARG     DOMAIN
ARG     CREDENTIAL

# Setup nginx.
RUN     wget "http://nginx.org/keys/nginx_signing.key" && \
        apt-key add nginx_signing.key && \
        echo "deb http://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list && \
        echo "deb-src http://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list && \
        apt-get update
RUN     apt-get install -y nginx && \
        rm -rf /etc/nginx/conf.d/* && \
        rm -rf /etc/nginx/sites-enabled/*
COPY    nginx.${RAILS_ENV}.conf /etc/nginx/conf.d/app.conf

# Build rails.
RUN     mkdir /app
COPY    Gemfile /app/Gemfile
COPY    Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN     bundle install
COPY    . /app
RUN     mkdir -p /var/tmp/sockets && \
        chmod -R 777 /var/tmp/sockets

# Deployment.
CMD     sed -e "s/ENV_PORT/${PORT}/g" -i /etc/nginx/conf.d/app.conf && \
        sed -e "s/DOMAIN/${DOMAIN}/g" -i /etc/nginx/conf.d/app.conf && \
        sed -e "s/CREDENTIAL/${CREDENTIAL}/g" -i /etc/nginx/conf.d/app.conf && \
        nginx -c /etc/nginx/nginx.conf && \
        mkdir -p /app/tmp/pids && \
        mkdir -p /var/tmp/sockets && \
        touch /var/tmp/sockets/puma.sock && \
        rm -f /app/tmp/pids/server.pid && \
        rm -f /var/sockets/puma.sock && \
        bundle exec puma -C /app/config/puma.rb