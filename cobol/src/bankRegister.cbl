       IDENTIFICATION DIVISION.
       PROGRAM-ID. REGISTER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS ASSIGN TO "data/accounts.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD ACCOUNTS.
       01 ACCOUNT-RECORD              PIC X(200).

       WORKING-STORAGE SECTION.
       01 WS-NAME                     PIC X(20).
       01 WS-PIN                      PIC X(64).

       01 WS-LAST-ID                  PIC 9(6) VALUE 0.
       01 WS-NEW-ID                   PIC 9(6).

       01 WS-EOF                      PIC X VALUE 'N'.

       LINKAGE SECTION.
       01 L-NAME                      PIC X(20).
       01 L-PIN                       PIC X(64).
       01 L-RESULT                    PIC X(50).

       PROCEDURE DIVISION USING L-NAME L-PIN L-RESULT.

           MOVE L-NAME TO WS-NAME.
           MOVE L-PIN TO WS-PIN.

           OPEN INPUT ACCOUNTS.

           PERFORM UNTIL WS-EOF = 'Y'
               READ ACCOUNTS
                   AT END
                       MOVE 'Y' TO WS-EOF
                   NOT AT END
                       MOVE ACCOUNT-RECORD(1:6) TO WS-LAST-ID
               END-READ
           END-PERFORM.

           CLOSE ACCOUNTS.

           ADD 1 TO WS-LAST-ID.
           MOVE WS-LAST-ID TO WS-NEW-ID.

           OPEN EXTEND ACCOUNTS.

           STRING
               WS-NEW-ID DELIMITED BY SIZE
               "|"
               WS-NAME DELIMITED BY SPACE
               "|"
               WS-PIN DELIMITED BY SPACE
               "|0"
               INTO ACCOUNT-RECORD
           END-STRING.

           WRITE ACCOUNT-RECORD.

           CLOSE ACCOUNTS.

           STRING
               "OK|"
               WS-NEW-ID
               INTO L-RESULT
           END-STRING.

           GOBACK.