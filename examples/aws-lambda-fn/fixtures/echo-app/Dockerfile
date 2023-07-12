# -------------------------------------------------------------------- build ---

FROM node:18 as build

WORKDIR /opt/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npx tsc

CMD [ "node", "src/index.js" ]

# ------------------------------------------------------------------ package ---

FROM alpine:latest as package

COPY --from=build /opt/app/dist /opt/app/dist

RUN apk add zip \
  && cd /opt/app/dist \
  && zip -r /tmp/package.zip .
