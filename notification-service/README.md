### Notification Service

# Notification Service

Serviço de auditoria e registro de eventos. Ele atua como um "Observer" do sistema, armazenando logs de ações importantes para histórico.

## Eventos Registrados

O sistema armazena payload JSON para os seguintes eventos:

- `task_created`: Quando um usuário solicita um scraping.
- `task_completed`: Quando o dados são extraídos com sucesso.
- `task_failed`: Quando ocorre erro (ex: Página não encontrada, Bloqueio de API).

## API Endpoints

- **POST `/api/notifications`**
  - Recebe eventos de qualquer microsserviço da plataforma.

## Testes

```bash
docker-compose exec notification-service bundle exec rspec
```
