       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOGIN.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNTS
               ASSIGN TO "/app/data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD ACCOUNTS.
       01 ACCOUNT-RECORD             PIC X(400).

       WORKING-STORAGE SECTION.

       01 WS-EOF                     PIC X VALUE "N".

       01 WS-ACCOUNT-ID              PIC X(12).
       01 WS-CUSTOMER-ID             PIC X(12).

       01 WS-EMAIL                   PIC X(100).
       01 WS-NAME                    PIC X(50).

       01 WS-PASSWORD                PIC X(64).
       01 WS-PIN                     PIC X(64).

       LINKAGE SECTION.

       01 L-EMAIL                    PIC X(100).
       01 L-PASSWORD                 PIC X(64).

       01 L-RESULT                   PIC X(300).

       PROCEDURE DIVISION USING
           L-EMAIL
           L-PASSWORD
           L-RESULT.

           MOVE "N"
               TO WS-EOF

           OPEN INPUT ACCOUNTS

           PERFORM UNTIL WS-EOF = "Y"

               READ ACCOUNTS
                   AT END

                       MOVE
                           "ERR|INVALID_CREDENTIALS"
                           TO L-RESULT

                       MOVE "Y"
                           TO WS-EOF

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

                       IF FUNCTION TRIM(WS-EMAIL)
                           = FUNCTION TRIM(L-EMAIL)

                           IF FUNCTION TRIM(WS-PASSWORD)
                               = FUNCTION TRIM(L-PASSWORD)

                               STRING
                                   "OK|"
                                   FUNCTION TRIM(WS-CUSTOMER-ID)
                                   "|"
                                   FUNCTION TRIM(WS-ACCOUNT-ID)
                                   "|"
                                   FUNCTION TRIM(WS-NAME)
                                   INTO L-RESULT

                           ELSE

                               MOVE
                                   "ERR|INVALID_CREDENTIALS"
                                   TO L-RESULT

                           END-IF

                           MOVE "Y"
                               TO WS-EOF
                       END-IF

               END-READ

           END-PERFORM

           CLOSE ACCOUNTS

           GOBACK.

       END PROGRAM LOGIN.