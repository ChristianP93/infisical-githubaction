# ##################################### development
FROM node:22.14.0-alpine AS development

WORKDIR /usr/src/app

COPY . .

RUN npm i

CMD ["npm", "run", "start:dev"]

# ##################################### debug
FROM node:22.14.0-alpine AS debug

WORKDIR /usr/src/app

COPY . .

RUN npm install

CMD ["npm", "run", "start:debug"]

# ##################################### build
FROM node:22.14.0-alpine AS build

WORKDIR /usr/src/app

COPY --chown=node:node package*.json ./
COPY --chown=node:node . .

RUN npm ci

RUN npm run build

ENV NODE_ENV production

USER node

# ##################################### staging
FROM node:22.14.0-alpine AS staging

USER node
WORKDIR /usr/src/app/dist

ENV NODE_ENV=staging

COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./
COPY --chown=node:node .env ./.env
COPY --chown=node:node --from=build /usr/src/app/package.json/ ./package.json

CMD [ "node", "main.js" ]

# ##################################### production
FROM node:22.14.0-alpine AS production

USER node
WORKDIR /usr/src/app/dist

ENV NODE_ENV=production

COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./
COPY --chown=node:node .env ./.env
COPY --chown=node:node --from=build /usr/src/app/package.json/ ./package.json
# COPY --chown=node:node global-bundle.pem ./global-bundle.pem

CMD [ "node", "main.js" ]
