FROM node

RUN npm install -g docsify-cli@latest

RUN mkdir /app
COPY summary /app/summary

WORKDIR /app/summary/docs

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "docsify", "serve", "." ]

EXPOSE 3000