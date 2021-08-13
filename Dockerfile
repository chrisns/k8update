FROM node:16.6.2-alpine as builder
WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm install
COPY index.js .eslintrc.js ./
RUN node_modules/.bin/eslint .
RUN npm prune --production
RUN rm .eslintrc.js


FROM node:16.6.2-alpine
COPY --from=twistedvines/skopeo /usr/local/bin/skopeo /usr/local/bin/skopeo
COPY --from=builder /app /app
CMD node /app/index.js