FROM node

RUN npm install -g docsify-cli@latest

RUN mkdir /summary
COPY docs /summary

WORKDIR /summary/docs

CMD [ "docsify", "serve", "." ]

EXPOSE 3000