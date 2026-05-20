       IDENTIFICATION DIVISION.
       PROGRAM-ID. REGISTER.

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
       01 ACCOUNT-RECORD PIC X(400).

       FD BALANCES.
       01 BALANCE-RECORD PIC X(100).

       WORKING-STORAGE SECTION.

       01 WS-NAME PIC X(50).
       01 WS-EMAIL PIC X(100).
       01 WS-PASSWORD PIC X(64).
       01 WS-PIN PIC X(64).

       01 WS-LAST-ID PIC 9(6) VALUE 0.
       01 WS-NEW-ID PIC 9(6).

       01 WS-ACCOUNT-ID PIC X(12).
       01 WS-CUSTOMER-ID PIC X(12).
       01 WS-REKENING PIC X(16).

       01 WS-REKENING-1 PIC 9(8).
       01 WS-REKENING-2 PIC 9(8).

       01 WS-EOF PIC X VALUE 'N'.
       01 WS-EMAIL-EXISTS PIC X VALUE 'N'.
       01 WS-REKENING-UNIQUE PIC X VALUE 'N'.

       01 WS-TEMP-ACCOUNT PIC X(12).
       01 WS-TEMP-REKENING PIC X(16).
       01 WS-TEMP-CUSTOMER PIC X(12).
       01 WS-TEMP-EMAIL PIC X(100).
       01 WS-TEMP-NAME PIC X(50).
       01 WS-TEMP-PASSWORD PIC X(64).
       01 WS-TEMP-PIN PIC X(64).

       LINKAGE SECTION.

       01 L-NAME PIC X(50).
       01 L-EMAIL PIC X(100).
       01 L-PASSWORD PIC X(64).
       01 L-PIN PIC X(64).
       01 L-RESULT PIC X(100).

       PROCEDURE DIVISION USING
           L-NAME
           L-EMAIL
           L-PASSWORD
           L-PIN
           L-RESULT.

           MOVE FUNCTION TRIM(L-NAME) TO WS-NAME
           MOVE FUNCTION TRIM(L-EMAIL) TO WS-EMAIL
           MOVE L-PASSWORD TO WS-PASSWORD
           MOVE L-PIN TO WS-PIN

           OPEN INPUT ACCOUNTS

           PERFORM UNTIL WS-EOF = 'Y'

               READ ACCOUNTS
                   AT END
                       MOVE 'Y' TO WS-EOF

                   NOT AT END

                       MOVE ACCOUNT-RECORD(4:6)
                           TO WS-LAST-ID

                       UNSTRING ACCOUNT-RECORD
                           DELIMITED BY "|"
                           INTO
                               WS-TEMP-ACCOUNT
                               WS-TEMP-REKENING
                               WS-TEMP-CUSTOMER
                               WS-TEMP-EMAIL
                               WS-TEMP-NAME
                               WS-TEMP-PASSWORD
                               WS-TEMP-PIN

                       IF FUNCTION TRIM(WS-TEMP-EMAIL)
                           = FUNCTION TRIM(WS-EMAIL)

                           MOVE "ERR|EMAIL_EXISTS"
                               TO L-RESULT

                           CLOSE ACCOUNTS

                           GOBACK

                       END-IF

               END-READ

           END-PERFORM

           CLOSE ACCOUNTS

           ADD 1 TO WS-LAST-ID
           MOVE WS-LAST-ID TO WS-NEW-ID

           STRING
               "ACC"
               WS-NEW-ID
               INTO WS-ACCOUNT-ID

           STRING
               "CIF"
               WS-NEW-ID
               INTO WS-CUSTOMER-ID

           MOVE 'N' TO WS-REKENING-UNIQUE

           PERFORM UNTIL WS-REKENING-UNIQUE = 'Y'

               COMPUTE WS-REKENING-1 =
                   FUNCTION RANDOM * 90000000 + 10000000

               COMPUTE WS-REKENING-2 =
                   FUNCTION RANDOM * 90000000 + 10000000

               STRING
                   WS-REKENING-1
                   WS-REKENING-2
                   INTO WS-REKENING

               MOVE 'Y'
                   TO WS-REKENING-UNIQUE

               MOVE 'N'
                   TO WS-EOF

               OPEN INPUT ACCOUNTS

               PERFORM UNTIL WS-EOF = 'Y'

                   READ ACCOUNTS
                       AT END
                           MOVE 'Y' TO WS-EOF

                       NOT AT END

                           UNSTRING ACCOUNT-RECORD
                               DELIMITED BY "|"
                               INTO
                                   WS-TEMP-ACCOUNT
                                   WS-TEMP-REKENING
                                   WS-TEMP-CUSTOMER
                                   WS-TEMP-EMAIL
                                   WS-TEMP-NAME
                                   WS-TEMP-PASSWORD
                                   WS-TEMP-PIN

                           IF FUNCTION TRIM(WS-TEMP-REKENING)
                               = FUNCTION TRIM(WS-REKENING)

                               MOVE 'N'
                                   TO WS-REKENING-UNIQUE

                           END-IF

                   END-READ

               END-PERFORM

               CLOSE ACCOUNTS

           END-PERFORM

           OPEN EXTEND ACCOUNTS

           STRING
               FUNCTION TRIM(WS-ACCOUNT-ID) "|"
               FUNCTION TRIM(WS-REKENING) "|"
               FUNCTION TRIM(WS-CUSTOMER-ID) "|"
               FUNCTION TRIM(WS-EMAIL) "|"
               FUNCTION TRIM(WS-NAME) "|"
               FUNCTION TRIM(WS-PASSWORD) "|"
               FUNCTION TRIM(WS-PIN)
               INTO ACCOUNT-RECORD

           WRITE ACCOUNT-RECORD

           CLOSE ACCOUNTS

           OPEN EXTEND BALANCES

           STRING
               FUNCTION TRIM(WS-REKENING)
               "|0"
               INTO BALANCE-RECORD

           WRITE BALANCE-RECORD

           CLOSE BALANCES

           STRING
               "OK|"
               FUNCTION TRIM(WS-CUSTOMER-ID)
               "|"
               FUNCTION TRIM(WS-ACCOUNT-ID)
               "|"
               FUNCTION TRIM(WS-REKENING)
               INTO L-RESULT

           GOBACK.

       END PROGRAM REGISTER.