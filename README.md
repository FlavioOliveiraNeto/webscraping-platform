# Web Scraping Microservices Platform

Solução distribuída para gerenciamento e execução de scraping de veículos (Webmotors), desenvolvida com foco em desacoplamento, robustez e escalabilidade.

## Arquitetura

O sistema foi dividido em 4 microsserviços especializados:

1.  **Auth Service (Porta 3001):** Responsável pela identificação única e emissão de JWT.
2.  **Webscraping Manager (Porta 3000):** API Gateway principal. Gerencia tarefas, valida permissões e orquestra o fluxo.
3.  **Processing Service (Crawler):** Executa o scraping via Nokogiri de forma assíncrona e resiliente.
4.  **Notification Service (Porta 3002):** Centraliza logs de eventos e auditoria do sistema.

### Decisões Técnicas

- **Autenticação Stateless:** Utilização de JWT com _Shared Secret_ para evitar chamadas HTTP desnecessárias na validação de tokens.
- **Assincronismo:** Uso intensivo de **Sidekiq + Redis** para evitar bloqueio da thread principal durante o scraping e orquestração.
- **Resiliência:** Implementação de `retries` no Sidekiq e tratamento defensivo no Nokogiri (Webmotors muda o HTML frequentemente).
- **Infraestrutura:** Docker Compose gerenciando bancos de dados isolados, Redis e Workers dedicados.

## Como Executar

Pré-requisito: Docker e Docker Compose instalados.

1. **Subir o ambiente** (Isso irá buildar as imagens, criar os bancos e rodar as migrations automaticamente):
   ```bash
   docker-compose up --build
   ```
