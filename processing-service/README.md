### Processing Service

# Processing Service (Worker)

Microsserviço responsável pela execução "pesada" do sistema: acessar a URL alvo, extrair os dados do veículo e reportar o resultado.

## Estratégia de Scraping (Smart Extraction)

Diferente de scrapers tradicionais que quebram com qualquer mudança de layout, este serviço implementa uma estratégia de **três níveis de fallback** no arquivo `app/services/scraper/webmotors.rb`:

1.  **Nível 1: API Interna (Engenharia Reversa)**
    - O sistema tenta converter a URL pública do veículo para a API interna da Webmotors (`/api/detail/car`).
    - _Vantagem:_ Dados puros em JSON, extremamente rápido e estruturado.

2.  **Nível 2: Hidratação Next.js (`__NEXT_DATA__`)**
    - Se a API falhar (403/404), o sistema baixa o HTML e extrai o JSON da tag `<script id="__NEXT_DATA__">`.
    - _Vantagem:_ Acesso ao estado da aplicação React sem depender de seletores CSS visuais. Contorna proteções que exibem o conteúdo, mas bloqueiam APIs diretas.

3.  **Nível 3: Parsing de HTML (Legado)**
    - Último recurso usando seletores CSS (Nokogiri) caso os métodos anteriores falhem.

## Tecnologias

- **Ruby:** 3.4.1
- **Rails:** 8.0.1 (API Only)
- **HTTP Client:** HTTParty (com headers rotativos para simular browsers reais)
- **Parser:** Nokogiri & JSON standard library

## Endpoints (Uso Interno)

- **POST `/api/scrape`**
  - Recebe: `{ "task_id": 1, "url": "..." }`
  - Ação: Enfileira um `ScrapingJob` no Sidekiq.

## Testes

Utiliza **VCR** e **WebMock** para garantir que a lógica de extração seja testada sem fazer requisições reais a cada execução, garantindo velocidade e estabilidade no CI.

```bash
docker-compose exec processing-service bundle exec rspec
```
