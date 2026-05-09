init: create-data-dir run-detached

create-data-dir:
	touch data/sessions.dat
	touch data/balances.dat
	touch data/accounts.dat
	touch data/qris_transaction.dat

run:
	docker compose up

run-detached:
	docker compose up -d --build

stop:
	docker compose down

logs:
	docker compose logs -f
