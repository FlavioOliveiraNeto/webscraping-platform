### Auth Service

Microsserviço dedicado exclusivamente à gestão de identidade, registro de usuários e autenticação.

## Funcionamento

O serviço utiliza a gem `jwt` para gerar tokens assinados. A arquitetura segue o padrão de **banco de dados de usuários segregado**, garantindo que as credenciais fiquem isoladas dos dados de negócio.

## API Endpoints

- **POST `/api/registrations`**
  - Cria um novo usuário.
  - Params: `email`, `password`, `password_confirmation`.
- **POST `/api/sessions`**
  - Autentica um usuário e retorna um Bearer Token JWT.

## Segurança

Todos os outros serviços da malha (Manager, Web) compartilham a mesma `JWT_SECRET` definida no `docker-compose.yml`, permitindo que eles validem a autenticidade do token sem precisar consultar este serviço a cada requisição (Stateless Authentication).

## Testes

```bash
docker-compose exec auth-service bundle exec rspec
```
