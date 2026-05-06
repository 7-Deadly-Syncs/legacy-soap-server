       IDENTIFICATION DIVISION.
       PROGRAM-ID. WITHDRAW.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNT-FILE
               ASSIGN TO "/app/data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TEMP-FILE
               ASSIGN TO "/app/data/accounts.tmp"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD ACCOUNT-FILE.
       01 ACCOUNT-RECORD             PIC X(200).

       FD TEMP-FILE.
       01 TEMP-RECORD                PIC X(200).

       WORKING-STORAGE SECTION.

       01 EOF-FLAG                   PIC X VALUE "N".

       01 WS-ACCOUNT                 PIC X(10).
       01 WS-NAME                    PIC X(20).
       01 WS-PIN                     PIC X(64).

       01 WS-BALANCE-TEXT            PIC X(20).
       01 WS-AMOUNT-TEXT             PIC X(20).

       01 WS-BALANCE                 PIC 9(9)V99.
       01 WS-AMOUNT                  PIC 9(9)V99.

       LINKAGE SECTION.

       01 L-ACCOUNT-ID               PIC X(20).
       01 L-PASSWORD                 PIC X(64).
       01 L-AMOUNT                   PIC X(20).
       01 L-RESULT                   PIC X(50).

       PROCEDURE DIVISION USING
           L-ACCOUNT-ID
           L-PASSWORD
           L-AMOUNT
           L-RESULT.

           MOVE FUNCTION TRIM(L-AMOUNT)
               TO WS-AMOUNT-TEXT

           MOVE WS-AMOUNT-TEXT
               TO WS-AMOUNT

           OPEN INPUT ACCOUNT-FILE
           OPEN OUTPUT TEMP-FILE

           PERFORM UNTIL EOF-FLAG = "Y"

               READ ACCOUNT-FILE
                   AT END
                       MOVE "Y" TO EOF-FLAG

                   NOT AT END

                       UNSTRING ACCOUNT-RECORD
                           DELIMITED BY "|"
                           INTO
                               WS-ACCOUNT
                               WS-NAME
                               WS-PIN
                               WS-BALANCE-TEXT

                       MOVE FUNCTION TRIM(WS-BALANCE-TEXT)
                           TO WS-BALANCE

                       IF FUNCTION TRIM(WS-ACCOUNT)
                           = FUNCTION TRIM(L-ACCOUNT-ID)

                           IF FUNCTION TRIM(WS-PIN)
                               = FUNCTION TRIM(L-PASSWORD)

                               IF WS-BALANCE >= WS-AMOUNT

                                   SUBTRACT WS-AMOUNT
                                       FROM WS-BALANCE

                                   STRING
                                       "OK|"
                                       WS-BALANCE
                                       INTO L-RESULT

                               ELSE
                                   MOVE
                                       "ERR|INSUFFICIENT_FUNDS"
                                       TO L-RESULT
                               END-IF

                           ELSE
                               MOVE "ERR|INVALID_PIN"
                                   TO L-RESULT
                           END-IF
                       END-IF

                       STRING
                           FUNCTION TRIM(WS-ACCOUNT)
                           "|"
                           FUNCTION TRIM(WS-NAME)
                           "|"
                           FUNCTION TRIM(WS-PIN)
                           "|"
                           WS-BALANCE
                           INTO TEMP-RECORD

                       WRITE TEMP-RECORD

               END-READ

           END-PERFORM

           CLOSE ACCOUNT-FILE
           CLOSE TEMP-FILE

           CALL "SYSTEM"
               USING "mv /app/data/accounts.tmp /app/data/accounts.dat"

           GOBACK.

       END PROGRAM WITHDRAW.