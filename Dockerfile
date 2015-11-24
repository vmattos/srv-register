FROM mhart/alpine-node:base-0.12

COPY . /src

WORKDIR /src

CMD ["node", "main.js"]
