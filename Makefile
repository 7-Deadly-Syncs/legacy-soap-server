.PHONY: init create-data-dir run run-detached stop logs

DATA_DIR := data
DATA_FILES := sessions.dat balances.dat accounts.dat qris_transaction.dat

ifeq ($(OS),Windows_NT)
	MKDIR = if not exist "$(DATA_DIR)" mkdir "$(DATA_DIR)"
	TOUCH = type nul >>
else
	MKDIR = mkdir -p $(DATA_DIR)
	TOUCH = touch
endif

init: create-data-dir run-detached

create-data-dir:
	$(MKDIR)
ifeq ($(OS),Windows_NT)
	@for %%f in ($(DATA_FILES)) do if not exist "$(DATA_DIR)\%%f" type nul > "$(DATA_DIR)\%%f"
else
	@for f in $(DATA_FILES); do touch "$(DATA_DIR)/$$f"; done
endif

run:
	docker compose up

run-detached:
	docker compose up -d --build

stop:
	docker compose down

logs:
	docker compose logs -f