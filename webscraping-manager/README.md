### Webscraping Manager

O núcleo da plataforma. Este microsserviço gerencia o ciclo de vida das tarefas (`ScrapingTask`), orquestra a comunicação com o worker e armazena os resultados finais.

## Funcionalidades

- **Gestão de Tarefas:** Criação, leitura e exclusão de tarefas.
- **Orquestração:** Ao criar uma tarefa, delega automaticamente o processamento para o `processing-service`.
- **Callbacks:** Recebe atualizações de status (sucesso/falha) do worker via Webhooks.
- **Validação:** Garante que apenas URLs válidas da Webmotors sejam processadas.

## API Endpoints

### Tarefas

- `GET /api/scraping_tasks` - Lista todas as tarefas do usuário.
- `POST /api/scraping_tasks` - Cria uma nova tarefa.
- `GET /api/scraping_tasks/:id` - Exibe o resultado (Marca, Modelo, Preço).
- `DELETE /api/scraping_tasks/:id` - Exclui uma tarefa.

### Callbacks (Sistema)

- `POST /api/callbacks/update_task`
  - Endpoint utilizado pelo `processing-service` para enviar o JSON com os dados do veículo ou mensagem de erro.

## Variáveis de Ambiente

- `JWT_SECRET`: Chave para validar tokens do `auth-service`.
- `PROCESSING_SERVICE_URL`: Endereço do worker.
- `NOTIFICATION_SERVICE_URL`: Endereço do serviço de logs.

## Testes

```bash
docker-compose exec webscraping-manager bundle exec rspec
```
