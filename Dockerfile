FROM java:8-jdk as java-node

ARG NODE_VERSION=10.14.2

WORKDIR /tmp
# https://github.com/joakimbeng/docker-java-node/blob/master/Dockerfile
RUN curl -SLO "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" \
    && tar -xJf "node-v${NODE_VERSION}-linux-x64.tar.xz" -C /usr/local --strip-components=1

FROM java-node as install

WORKDIR /app

COPY ./package*.json ./
RUN npm install

COPY ./shadow-cljs.edn ./
RUN npx shadow-cljs info

FROM install as build

COPY ./src ./src
COPY ./resources ./resources

RUN npm run build

FROM nginx as production

COPY --from=build /app/resources/public /usr/share/nginx/html
COPY ./nginx.conf.template /etc/nginx/conf.d/conf.template

ENV PORT=80

CMD /bin/bash -c "envsubst < /etc/nginx/conf.d/conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
