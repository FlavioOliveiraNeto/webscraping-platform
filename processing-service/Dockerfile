FROM ruby:3.4.8

# Instala dependências do sistema (Postgres client + build tools)
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    chromium \
    chromium-driver \
    libnss3 \
    libfontconfig1 \
    libfreetype6 \
    libharfbuzz0b \
    ca-certificates \
    fonts-freefont-ttf \
    --no-install-recommends

# Define diretório de trabalho
WORKDIR /app

# Copia Gemfile antes do código
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia o restante do código
COPY . .

# Expõe a porta (será trocada pelo Compose)
EXPOSE 3000

# Script de entrada para corrigir problema de server.pid
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]