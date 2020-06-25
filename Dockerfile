FROM node

RUN npm install -g docsify-cli@latest

RUN mkdir /summary
COPY docs /summary

WORKDIR /summary/docs

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "docsify", "serve", "." ]

EXPOSE 3000