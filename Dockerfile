FROM ruby:3.2-slim

# Install dependencies and gcsfuse
RUN apt-get update && apt-get install -y \
    build-essential \
    sqlite3 \
    postgresql-client \
    curl gnupg && \
    echo "deb http://packages.cloud.google.com/apt gcsfuse-bullseye main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y gcsfuse && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

RUN chmod +x entrypoint.sh

EXPOSE 8080

ENV RACK_ENV=production

ENTRYPOINT ["./entrypoint.sh"]
