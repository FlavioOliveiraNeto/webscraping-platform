# Webscraping Platform - Microservices

Este repositório contém uma plataforma distribuída para coleta de dados de veículos (Web Scraping), construída com arquitetura de microsserviços utilizando Ruby on Rails 8, Docker e comunicação assíncrona.

## Arquitetura

O sistema é composto por 5 containers principais orquestrados via Docker Compose:

1.  **Web (Frontend):** Interface visual para o usuário gerenciar tarefas.
2.  **Webscraping Manager:** API central que gerencia tarefas e orquestra o fluxo.
3.  **Auth Service:** Microsserviço dedicado a autenticação JWT.
4.  **Processing Service:** Microsserviço responsável pela execução do scraping (HTTParty + Nokogiri).
5.  **Notification Service:** Microsserviço para centralizar logs e notificações de eventos.

## Como Executar (Quick Start)

Pré-requisitos: **Docker** e **Docker Compose** instalados.

1.  Clone o repositório:

    ```bash
    git clone <seu-repo-url>
    cd webscraping-platform
    ```

2.  Suba todo o ambiente com um único comando:

    ```bash
    docker-compose up --build
    ```

3.  Acesse a aplicação no navegador:
    - **Frontend:** [http://localhost:8080](http://localhost:8080)

## Serviços e Portas

| Serviço                | Responsabilidade                | Porta Externa |
| :--------------------- | :------------------------------ | :------------ |
| `web`                  | Frontend (Rails MVC)            | 8080          |
| `webscraping-manager`  | API Principal / Gestão de Tasks | 3000          |
| `auth-service`         | Autenticação e Usuários         | 3001          |
| `notification-service` | Notificações                    | 3002          |
| `processing-service`   | Scraping Engine (Interno)       | N/A           |

## Executando os Testes

Para rodar a suíte de testes (RSpec) em todos os serviços:

```bash
# Rodar todos os testes de uma vez (opcional)
docker-compose exec processing-service bundle exec rspec
# Repita para os outros serviços conforme necessário
```
