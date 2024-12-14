.PHONY: build

docker-up:
	docker compose -f docker-compose-dev.yml up -d

docker-down:
	docker compose -f docker-compose-dev.yml down
docker-bash:
	docker exec -it recipes bash

heidisql: 
	wine ../../software/heidi-sql/heidisql.exe
clear-pdf:
	sudo rm -R app/webroot/files/clients/1-1000/1/*.pdf
