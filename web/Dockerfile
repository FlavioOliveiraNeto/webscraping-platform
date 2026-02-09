FROM ruby:3.4.8

# Instala dependencias do sistema
RUN apt-get update -qq && apt-get install -y build-essential curl

# Define diretorio de trabalho
WORKDIR /app

# Copia Gemfile antes do codigo
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia o restante do codigo
COPY . .

# Expoe a porta
EXPOSE 3000

# Script de entrada para corrigir problema de server.pid
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
