COBOL = cobc
COBFLAGS = -x

COBOL_SRC = cobol/src
COBOL_BIN = cobol/bin

AXIS2_SERVICE = axis2/services/BankService
AXIS2_BUILD = axis2/build
AAR_NAME = BankService.aar

all: cobol axis2

cobol:
mkdir -p $(COBOL_BIN)
$(COBOL) $(COBFLAGS) $(COBOL_SRC)/transfer.cbl -o $(COBOL_BIN)/transfer
$(COBOL) $(COBFLAGS) $(COBOL_SRC)/balance.cbl -o $(COBOL_BIN)/balance
$(COBOL) $(COBFLAGS) $(COBOL_SRC)/deposit.cbl -o $(COBOL_BIN)/deposit
$(COBOL) $(COBFLAGS) $(COBOL_SRC)/withdraw.cbl -o $(COBOL_BIN)/withdraw

axis2:
mkdir -p $(AXIS2_BUILD)
cd $(AXIS2_SERVICE) && jar cvf ../../build/$(AAR_NAME) *

docker-build:
docker compose build

run:
docker compose up

run-detached:
docker compose up -d

stop:
docker compose down

logs:
docker compose logs -f

clean:
rm -rf $(COBOL_BIN)/*
rm -rf $(AXIS2_BUILD)/*

rebuild: clean all docker-build

