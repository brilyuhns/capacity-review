#!/bin/bash

# Exit on error
set -e

function start() {
    echo "Starting development environment..."
    docker-compose up --build
}

function stop() {
    echo "Stopping development environment..."
    docker-compose down
}

function logs() {
    docker-compose logs -f
}

function shell() {
    docker-compose exec web bash
}

function migrate() {
    docker-compose exec web bundle exec rake db:migrate
}

function test() {
    docker-compose exec web bundle exec rake test
}

case "$1" in
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "logs")
        logs
        ;;
    "shell")
        shell
        ;;
    "migrate")
        migrate
        ;;
    "test")
        test
        ;;
    *)
        echo "Usage: $0 {start|stop|logs|shell|migrate|test}"
        exit 1
        ;;
esac 