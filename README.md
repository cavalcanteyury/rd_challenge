# RD Challenge - Ruby

Uma versão em Ruby do desafio para desenvolvedores da RD Station

## Requisitos

* [Docker](https://docs.docker.com/get-docker/)

## Stack

* Ruby 3.3 [+YJIT](https://shopify.engineering/ruby-yjit-is-production-ready) apps

## Como rodar os testes


Na raíz do projeto:

```sh
docker build -t rd_challenge:latest .
docker run rd_challenge:latest
```

Existe um script na raíz do projeto para buildar o projeto e rodar os testes:

```sh
./run.sh
```