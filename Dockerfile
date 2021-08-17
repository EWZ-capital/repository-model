FROM nginx

# Arguments

# Aws configs args

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

ARG AWS_DEFAULT_REGION=sa-east-1
ARG aws_bucket=hub-api

# # Postgres config

# # ELASTIC

ARG APM_SERVER
ARG APM_SECRET_TOKEN

ARG KIBANA_HOST

ARG ELASTIC_CLOUD_ID
ARG ELASTIC_HOST
ARG ELASTIC_USER
ARG ELASTIC_PASS

# Api configs

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

RUN rm -f /var/log/nginx/access.log && rm -f /var/log/nginx/error.log


# RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.13.1-amd64.deb
# RUN dpkg -i filebeat-7.13.1-amd64.deb

# COPY ./nginx/filebeat.yml /etc/filebeat/filebeat.yml
#
# RUN chmod go-w /etc/filebeat/filebeat.yml

ENV PORT=3333

ENV ENVIRONMENT=production

ENV APP_API_URL=https://api.ewzhub.com
ENV APP_WEB_HUB=https://ewzhub.com

WORKDIR /home/node/app

COPY . .

COPY ./.docker/entrypoint.sh /entrypoint.sh

COPY ./nginx/ /etc/nginx/conf.d/

RUN chmod +x /entrypoint.sh

RUN npm i

RUN npx ts-node-dev node_modules/typeorm/cli.js migration:run

EXPOSE 80

CMD [ "/entrypoint.sh" ]
