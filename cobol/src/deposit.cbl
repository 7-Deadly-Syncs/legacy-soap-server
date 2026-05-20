       IDENTIFICATION DIVISION.
       PROGRAM-ID. DEPOSIT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNTS
               ASSIGN TO "/app/data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT BALANCES
               ASSIGN TO "/app/data/balances.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TEMP-BALANCES
               ASSIGN TO "/app/data/balances.tmp"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD ACCOUNTS.
       01 ACCOUNT-RECORD             PIC X(400).

       FD BALANCES.
       01 BALANCE-RECORD             PIC X(100).

       FD TEMP-BALANCES.
       01 TEMP-BALANCE-RECORD        PIC X(100).

       WORKING-STORAGE SECTION.

       01 WS-EOF-ACCOUNTS            PIC X VALUE "N".
       01 WS-EOF-BALANCES            PIC X VALUE "N".

       01 WS-ACCOUNT-ID              PIC X(12).
       01 WS-REKENING                PIC X(16).
       01 WS-CUSTOMER-ID             PIC X(12).
       01 WS-EMAIL                   PIC X(100).
       01 WS-NAME                    PIC X(50).

       01 WS-PASSWORD                PIC X(64).
       01 WS-PIN                     PIC X(64).

       01 WS-BALANCE-REKENING        PIC X(16).

       01 WS-BALANCE-TEXT            PIC X(20).
       01 WS-AMOUNT-TEXT             PIC X(20).

       01 WS-BALANCE                 PIC 9(9)V99.
       01 WS-AMOUNT                  PIC 9(9)V99.

       01 WS-AUTHENTICATED           PIC X VALUE "N".

       01 WS-CMD                     PIC X(200).

       LINKAGE SECTION.

       01 L-REKENING                 PIC X(16).
       01 L-PIN                      PIC X(64).
       01 L-AMOUNT                   PIC X(20).
       01 L-RESULT                   PIC X(100).

       PROCEDURE DIVISION USING
           L-REKENING
           L-PIN
           L-AMOUNT
           L-RESULT.

           MOVE "N"
               TO WS-EOF-ACCOUNTS

           MOVE "N"
               TO WS-EOF-BALANCES

           MOVE "N"
               TO WS-AUTHENTICATED

           MOVE 0
               TO WS-BALANCE

           MOVE 0
               TO WS-AMOUNT

           MOVE FUNCTION TRIM(L-AMOUNT)
               TO WS-AMOUNT-TEXT

           MOVE WS-AMOUNT-TEXT
               TO WS-AMOUNT

           OPEN INPUT ACCOUNTS

           PERFORM UNTIL WS-EOF-ACCOUNTS = "Y"

               READ ACCOUNTS
                   AT END
                       MOVE "Y"
                           TO WS-EOF-ACCOUNTS

                   NOT AT END

                       UNSTRING ACCOUNT-RECORD
                           DELIMITED BY "|"
                           INTO
                               WS-ACCOUNT-ID
                               WS-REKENING
                               WS-CUSTOMER-ID
                               WS-EMAIL
                               WS-NAME
                               WS-PASSWORD
                               WS-PIN

                       IF FUNCTION TRIM(WS-REKENING)
                           = FUNCTION TRIM(L-REKENING)

                           IF FUNCTION TRIM(WS-PIN)
                               = FUNCTION TRIM(L-PIN)

                               MOVE "Y"
                                   TO WS-AUTHENTICATED

                           ELSE

                               MOVE
                                   "ERR|INVALID_PIN"
                                   TO L-RESULT

                               CLOSE ACCOUNTS
                               GOBACK

                           END-IF

                           MOVE "Y"
                               TO WS-EOF-ACCOUNTS
                       END-IF

               END-READ

           END-PERFORM

           CLOSE ACCOUNTS

           IF WS-AUTHENTICATED NOT = "Y"

               MOVE
                   "ERR|NO_ACCOUNT"
                   TO L-RESULT

               GOBACK

           END-IF

           OPEN INPUT BALANCES
           OPEN OUTPUT TEMP-BALANCES

           PERFORM UNTIL WS-EOF-BALANCES = "Y"

               READ BALANCES
                   AT END
                       MOVE "Y"
                           TO WS-EOF-BALANCES

                   NOT AT END

                       UNSTRING BALANCE-RECORD
                           DELIMITED BY "|"
                           INTO
                               WS-BALANCE-REKENING
                               WS-BALANCE-TEXT

                       MOVE FUNCTION TRIM(WS-BALANCE-TEXT)
                           TO WS-BALANCE

                       IF FUNCTION TRIM(WS-BALANCE-REKENING)
                           = FUNCTION TRIM(L-REKENING)

                           ADD WS-AMOUNT
                               TO WS-BALANCE

                           STRING
                               "OK|"
                               FUNCTION TRIM(WS-BALANCE-REKENING)
                               "|"
                               WS-BALANCE
                               INTO L-RESULT
                       END-IF

                       STRING
                           FUNCTION TRIM(WS-BALANCE-REKENING)
                           "|"
                           WS-BALANCE
                           INTO TEMP-BALANCE-RECORD

                       WRITE TEMP-BALANCE-RECORD

               END-READ

           END-PERFORM

           CLOSE BALANCES
           CLOSE TEMP-BALANCES

           MOVE
           "mv /app/data/balances.tmp /app/data/balances.dat"
               TO WS-CMD

           CALL "SYSTEM"
               USING FUNCTION TRIM(WS-CMD)

           GOBACK.

       END PROGRAM DEPOSIT.