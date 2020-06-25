FROM node

RUN npm install -g docsify-cli@latest

RUN mkdir /summary
COPY docs /summary/docs

WORKDIR /summary/docs

CMD [ "docsify", "serve", "." ]

EXPOSE 3000