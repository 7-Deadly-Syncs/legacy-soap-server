       IDENTIFICATION DIVISION.
       PROGRAM-ID. QRIS.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS ASSIGN TO "/app/data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT BALANCES ASSIGN TO "/app/data/balances.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TEMP-BALANCES ASSIGN TO "/app/data/balances.tmp"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TX-FILE ASSIGN TO "/app/data/qris_transaction.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       
       FD ACCOUNTS.
       01 ACCOUNT-RECORD PIC X(400).
       
       FD BALANCES.
       01 BALANCE-RECORD PIC X(100).
       
       FD TEMP-BALANCES.
       01 TEMP-BALANCE-RECORD PIC X(100).
       
       FD TX-FILE.
       01 TX-RECORD PIC X(200).
       
       WORKING-STORAGE SECTION.

       01 WS-EOF-ACCOUNTS PIC X VALUE "N".
       01 WS-EOF-BALANCES PIC X VALUE "N".

       01 WS-ACCOUNT-ID PIC X(12).
       01 WS-REKENING PIC X(16).
       01 WS-CUSTOMER-ID PIC X(12).

       01 WS-EMAIL PIC X(100).
       01 WS-NAME PIC X(50).

       01 WS-PASSWORD PIC X(64).
       01 WS-PIN PIC X(64).

       01 WS-BALANCE-REKENING PIC X(16).

       01 WS-BALANCE-TEXT PIC X(20).
       01 WS-AMOUNT-TEXT PIC X(20).

       01 WS-BALANCE PIC 9(9)V99.
       01 WS-AMOUNT PIC 9(9)V99.

       01 WS-SOURCE-BALANCE PIC 9(9)V99 VALUE 0.
       01 WS-NEW-BALANCE PIC 9(9)V99 VALUE 0.

       01 WS-SOURCE-FOUND PIC X VALUE "N".
       01 WS-STATUS PIC X(30) VALUE SPACES.
       01 WS-BALANCE-DISPLAY PIC Z(9)9.99.

       01 WS-CMD PIC X(200).
       01 WS-LINE PIC X(200).
       
       LINKAGE SECTION.

       01 L-REKENING PIC X(16).
       01 L-MERCHANT-ID PIC X(20).
       01 L-AMOUNT PIC X(20).
       01 L-RESULT PIC X(100).
       
       PROCEDURE DIVISION USING
           L-REKENING
           L-MERCHANT-ID
           L-AMOUNT
           L-RESULT.
       
           MOVE "N"
               TO WS-EOF-ACCOUNTS

           MOVE "N"
               TO WS-EOF-BALANCES

           MOVE "N"
               TO WS-SOURCE-FOUND

           MOVE 0
               TO WS-SOURCE-BALANCE

           MOVE 0
               TO WS-NEW-BALANCE

           MOVE 0
               TO WS-BALANCE

           MOVE 0
               TO WS-AMOUNT

           MOVE SPACES
               TO WS-STATUS

           MOVE FUNCTION NUMVAL(
               FUNCTION TRIM(L-AMOUNT))
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

                           MOVE "Y"
                               TO WS-SOURCE-FOUND

                       END-IF

               END-READ

           END-PERFORM

           CLOSE ACCOUNTS
       
           IF WS-SOURCE-FOUND NOT = "Y"

               MOVE "ERR|NO_ACCOUNT"
                   TO L-RESULT

               GOBACK

           END-IF
       
           OPEN INPUT BALANCES
           OPEN OUTPUT TEMP-BALANCES
           OPEN EXTEND TX-FILE
       
           MOVE "N"
               TO WS-EOF-BALANCES
       
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

                       MOVE FUNCTION NUMVAL(
                           FUNCTION TRIM(WS-BALANCE-TEXT))
                           TO WS-BALANCE
       
                       IF FUNCTION TRIM(WS-BALANCE-REKENING)
                           = FUNCTION TRIM(L-REKENING)

                           IF WS-BALANCE < WS-AMOUNT

                               MOVE
                                   "ERR|INSUFFICIENT_FUNDS"
                                   TO L-RESULT

                               CLOSE BALANCES
                               CLOSE TEMP-BALANCES
                               CLOSE TX-FILE

                               GOBACK

                           END-IF
       
                           SUBTRACT WS-AMOUNT
                               FROM WS-BALANCE

                           MOVE WS-BALANCE
                               TO WS-NEW-BALANCE

                           MOVE "OK"
                               TO WS-STATUS
       
                           STRING
                               "OK|"
                               FUNCTION TRIM(L-REKENING)
                               "|"
                               FUNCTION TRIM(L-MERCHANT-ID)
                               "|"
                               FUNCTION TRIM(L-AMOUNT)
                               INTO WS-LINE
                           END-STRING
       
                           MOVE WS-LINE
                               TO TX-RECORD

                           WRITE TX-RECORD

                       ELSE

                           MOVE WS-BALANCE
                               TO WS-NEW-BALANCE

                       END-IF
       
                       MOVE WS-NEW-BALANCE
                           TO WS-BALANCE-DISPLAY

                       MOVE SPACES TO TEMP-BALANCE-RECORD
                       STRING
                           FUNCTION TRIM(WS-BALANCE-REKENING)
                           "|"
                           FUNCTION TRIM(WS-BALANCE-DISPLAY)
                           INTO TEMP-BALANCE-RECORD
                       END-STRING

                       WRITE TEMP-BALANCE-RECORD

               END-READ

           END-PERFORM
       
           CLOSE BALANCES
           CLOSE TEMP-BALANCES
           CLOSE TX-FILE
       
           MOVE
           "mv /app/data/balances.tmp /app/data/balances.dat"
               TO WS-CMD

           CALL "SYSTEM"
               USING FUNCTION TRIM(WS-CMD)
       
           IF WS-STATUS = "OK"

               STRING
                   "OK|"
                   FUNCTION TRIM(L-REKENING)
                   "|"
                   FUNCTION TRIM(L-MERCHANT-ID)
                   "|"
                   FUNCTION TRIM(L-AMOUNT)
                   INTO L-RESULT
               END-STRING

           ELSE

               MOVE "ERR|UNKNOWN"
                   TO L-RESULT

           END-IF
       
           GOBACK.

       END PROGRAM QRIS.