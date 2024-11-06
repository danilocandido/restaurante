Restaurante
============

Microserviço que gerencia pedidos em um restaurante, listando os produtos e processando pedidos.

##### Pré-requisito

The setups steps expect following tools installed on the system.

- Git
- Ruby [3.3.5](https://github.com/ruby/ruby)
- Rails [7.2.1](https://github.com/rails/rails)
- Docker
- Docker Compose

##### 1. Check out do repositório

```bash
git clone git@github.com:danilocandido/restaurante.git
```

##### 2.  o projeto

Dentro da pasta `restaurante` rode o comando abaixo para criar baixar e configurar as dependências do projeto

```bash
docker compose build
```

##### 3. Configurar o banco de dados

Rode os comandos abaixo para criar o banco de dados, rodar as migrações e popular o banco com valores iniciais para o uso

```ruby
docker compose run api bin/rails db:create
docker compose run api bin/rails db:migrate
docker compose run api bin/rails db:seed
```

##### 4. Iniciar o projeto

Inicia os seguintes projetos:
- rails server - http://127.0.0.1:3000
- rabbitmq server - http://127.0.0.1:15672

```ruby
docker compose up
```

em outra aba, para rodar o projeto frontend
```js
npm build
npm start
```

- rails server - http://127.0.0.1:3000
- react server - http://127.0.0.1:3001
- rabbitmq server - http://127.0.0.1:15672