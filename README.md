Restaurante
============

Microserviço que gerencia pedidos em um restaurante, listando os produtos e processando pedidos.

##### Pré-requisito

The setups steps expect following tools installed on the system.

- Git
- Ruby [3.3.5](https://github.com/ruby/ruby)
- Rails API only [7.2.1](https://github.com/rails/rails)
- Docker
- Docker Compose

##### 1. Check out do repositório

```bash
git clone git@github.com:danilocandido/restaurante.git
```

##### 2. Variáveis de ambiente
As variáveis de ambiente estão dentro do docker-compose.yml no servido API. Para simular um webhook é preciso abrir o site https://webhook.site
e no menu procurar o link `COPY` (lado superior direito do site) e copiar a URL substituindo a variável `WEBHOOK_URL` pelo link copiado. Segue um exemplo de como deve ficar abaixo

WEBHOOK_URL=https://webhook.site/76d77748-495c-43f9-b664-00c100bdf226

##### 3.  o projeto

Dentro da pasta `restaurante` rode o comando abaixo para criar baixar e configurar as dependências do projeto

```bash
docker compose build
```

##### 4. Configurar o banco de dados

Rode os comandos abaixo para criar o banco de dados, rodar as migrações e popular o banco com valores iniciais para o uso

```ruby
docker compose run api bin/rails db:create
docker compose run api bin/rails db:migrate
docker compose run api bin/rails db:seed
```

##### 5. Iniciar o projeto

Inicia os seguintes projetos:
```ruby
docker compose up
```

em outra aba, rode os consumidores da fila rabbitmq (sneakers)
```
docker compose run api bundle exec rake sneakers:run
```

Por ultimo, em outra aba, para rodar o projeto frontend
```js
npm build
npm start
```

- backend(rails)  - http://127.0.0.1:3000
- frontend(react) - http://127.0.0.1:4000
- rabbitmq server - http://127.0.0.1:15672
  - usuário: guest
  - senha: guest

### Rabbimq

A escolha adoção do tópico exchange foi devido a centralizar o tópico com a possibilidade de criar várias rotas. Sendo a central de pedidos e as rotas os destinos que partem dessa central de pedidos. Outras possibilidades seriam comunicação ponto a ponto ou broadcast  

                    ┌───────────────────────────────┐
                    │        orders_exchange        │
                    │           (Tópico)            │
                    └───────────────┬───────────────┘
                                    │
                                    │
                                    ▼
                           ┌─────────────────────┐
                           │    order.received   │
                           │        (Fila)       │
                           └─────────────────────┘

  
Publisher: OrderPublisher.rb  
Consumidor: KitchenWorker.rb  

### Testes
Foi implementado dois tipos de testes, `testes unitários` nos modelos e `testes de integração` para o contexto das requisições da API.
Para executar todos os testes rode o comando abaixo:

```
docker compose run api bundle exec rspec
```
