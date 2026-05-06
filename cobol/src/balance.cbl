       IDENTIFICATION DIVISION.
       PROGRAM-ID. BALANCE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNTS
               ASSIGN TO "/app/data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT BALANCES
               ASSIGN TO "/app/data/balances.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD ACCOUNTS.
       01 ACCOUNT-RECORD             PIC X(400).

       FD BALANCES.
       01 BALANCE-RECORD             PIC X(100).

       WORKING-STORAGE SECTION.

       01 WS-EOF-ACCOUNTS            PIC X VALUE "N".
       01 WS-EOF-BALANCES            PIC X VALUE "N".

       01 WS-ACCOUNT-ID              PIC X(12).
       01 WS-CUSTOMER-ID             PIC X(12).
       01 WS-EMAIL                   PIC X(100).
       01 WS-NAME                    PIC X(50).

       01 WS-PASSWORD                PIC X(64).
       01 WS-PIN                     PIC X(64).

       01 WS-BALANCE-ACCOUNT         PIC X(12).
       01 WS-BALANCE                 PIC X(20).

       01 WS-AUTHENTICATED           PIC X VALUE "N".

       LINKAGE SECTION.

       01 L-ACCOUNT-ID               PIC X(20).
       01 L-PASSWORD                 PIC X(64).
       01 L-RESULT                   PIC X(100).

       PROCEDURE DIVISION USING
           L-ACCOUNT-ID
           L-PASSWORD
           L-RESULT.

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
                               WS-CUSTOMER-ID
                               WS-EMAIL
                               WS-NAME
                               WS-PASSWORD
                               WS-PIN

                       IF FUNCTION TRIM(WS-ACCOUNT-ID)
                           = FUNCTION TRIM(L-ACCOUNT-ID)

                           IF FUNCTION TRIM(WS-PASSWORD)
                               = FUNCTION TRIM(L-PASSWORD)

                               MOVE "Y"
                                   TO WS-AUTHENTICATED

                           ELSE

                               MOVE
                                   "ERR|INVALID_PASSWORD"
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

           PERFORM UNTIL WS-EOF-BALANCES = "Y"

               READ BALANCES
                   AT END
                       MOVE "Y"
                           TO WS-EOF-BALANCES

                   NOT AT END

                       UNSTRING BALANCE-RECORD
                           DELIMITED BY "|"
                           INTO
                               WS-BALANCE-ACCOUNT
                               WS-BALANCE

                       IF FUNCTION TRIM(WS-BALANCE-ACCOUNT)
                           = FUNCTION TRIM(L-ACCOUNT-ID)

                           STRING
                               "OK|"
                               FUNCTION TRIM(WS-ACCOUNT-ID)
                               "|"
                               FUNCTION TRIM(WS-BALANCE)
                               INTO L-RESULT

                           MOVE "Y"
                               TO WS-EOF-BALANCES
                       END-IF

               END-READ

           END-PERFORM

           CLOSE BALANCES

           GOBACK.

       END PROGRAM BALANCE.