### Web Frontend

````markdown
# Web Frontend

Interface gráfica desenvolvida em **Ruby on Rails 8 (Fullstack)** utilizando **Bootstrap 5**.

## Visão Geral

Este projeto atua como um cliente HTTP (Backend for Frontend) que consome os microsserviços. Ele não possui banco de dados próprio para regras de negócio, apenas consome as APIs.

## Funcionalidades

- **Login/Cadastro:** Consome o `auth-service` e gerencia a sessão do usuário via Cookies/Session Storage.
- **Dashboard:** Consome o `webscraping-manager` para listar tarefas.
- **Live Updates:** A interface está preparada para exibir os status das tarefas (Pendente -> Processando -> Concluído/Falha).

## Tecnologias

- **Framework:** Rails 8.0.1
- **CSS:** Bootstrap 5 (via Importmap/CDN)
- **Ícones:** Bootstrap Icons
- **HTTP Client:** Services Objects encapsulando chamadas de API.

## Testes

Testes de Request e System (se aplicável) para garantir a integração com os serviços.

```bash
docker-compose exec web bundle exec rspec
```
````
