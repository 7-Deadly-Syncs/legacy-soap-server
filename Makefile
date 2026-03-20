init: bin run-detached

bin:
mkdir ./cobol/bin
mkdir ./axis2/bin

run:
docker compose up

run-detached:
docker compose up -d

stop:
docker compose down

logs:
docker compose logs -f

rebuild: clean all docker-build
