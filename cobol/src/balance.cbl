       IDENTIFICATION DIVISION.
       PROGRAM-ID. BALANCE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNT-FILE
               ASSIGN TO "/app/data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD ACCOUNT-FILE.
       01 ACCOUNT-RECORD         PIC X(100).

       WORKING-STORAGE SECTION.

       01 EOF-FLAG               PIC X VALUE "N".

       01 WS-ACCOUNT             PIC X(10).
       01 WS-NAME                PIC X(20).
       01 WS-PIN                 PIC X(10).
       01 WS-BALANCE             PIC X(20).

       LINKAGE SECTION.

       01 L-ACCOUNT-ID           PIC X(20).
       01 L-PASSWORD             PIC X(10).
       01 L-RESULT               PIC X(50).

       PROCEDURE DIVISION USING
           L-ACCOUNT-ID
           L-PASSWORD
           L-RESULT.

           OPEN INPUT ACCOUNT-FILE

           PERFORM UNTIL EOF-FLAG = "Y"

               READ ACCOUNT-FILE
                   AT END
                       MOVE "Y" TO EOF-FLAG
                       MOVE "ERR|NO_ACCOUNT" TO L-RESULT

                   NOT AT END

                       UNSTRING ACCOUNT-RECORD
                           DELIMITED BY "|"
                           INTO
                               WS-ACCOUNT
                               WS-NAME
                               WS-PIN
                               WS-BALANCE

                       IF FUNCTION TRIM(WS-ACCOUNT)
                           = FUNCTION TRIM(L-ACCOUNT-ID)

                           IF FUNCTION TRIM(WS-PIN)
                               = FUNCTION TRIM(L-PASSWORD)

                               STRING
                                   "OK|"
                                   FUNCTION TRIM(WS-BALANCE)
                                   INTO L-RESULT

                           ELSE
                               MOVE "ERR|INVALID_PIN"
                                   TO L-RESULT
                           END-IF

                           MOVE "Y" TO EOF-FLAG
                       END-IF
               END-READ

           END-PERFORM

           CLOSE ACCOUNT-FILE

           GOBACK.

       END PROGRAM BALANCE.