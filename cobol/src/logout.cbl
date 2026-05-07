       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOGOUT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT SESSIONS
               ASSIGN TO "/app/data/sessions.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD SESSIONS.
       01 SESSION-RECORD             PIC X(300).

       WORKING-STORAGE SECTION.

       01 WS-EOF                     PIC X VALUE "N".

       01 WS-SESSION-ID              PIC X(100).
       01 WS-ACCOUNT-ID              PIC X(20).
       01 WS-EXPIRES-AT              PIC X(20).

       01 WS-FOUND                   PIC X VALUE "N".

       01 WS-INDEX                   PIC 9(4) VALUE 0.

       01 WS-SESSIONS.
           05 WS-SESSION-LINE
               OCCURS 100 TIMES.
               10 WS-STORED-SESSION  PIC X(300).

       LINKAGE SECTION.

       01 L-SESSION-ID               PIC X(100).
       01 L-RESULT                   PIC X(100).

       PROCEDURE DIVISION USING
           L-SESSION-ID
           L-RESULT.

           MOVE "N"
               TO WS-EOF

           MOVE "N"
               TO WS-FOUND

           MOVE 0
               TO WS-INDEX

           OPEN INPUT SESSIONS

           PERFORM UNTIL WS-EOF = "Y"

               READ SESSIONS
                   AT END

                       MOVE "Y"
                           TO WS-EOF

                   NOT AT END

                       UNSTRING SESSION-RECORD
                           DELIMITED BY "|"
                           INTO
                               WS-SESSION-ID
                               WS-ACCOUNT-ID
                               WS-EXPIRES-AT

                       IF FUNCTION TRIM(WS-SESSION-ID)
                           = FUNCTION TRIM(L-SESSION-ID)

                           MOVE "Y"
                               TO WS-FOUND

                       ELSE

                           ADD 1 TO WS-INDEX

                           MOVE SESSION-RECORD
                               TO WS-STORED-SESSION(WS-INDEX)

                       END-IF

               END-READ

           END-PERFORM

           CLOSE SESSIONS

           OPEN OUTPUT SESSIONS

           PERFORM VARYING WS-INDEX
               FROM 1 BY 1
               UNTIL WS-INDEX > 100

               IF FUNCTION TRIM(
                   WS-STORED-SESSION(WS-INDEX)
                   ) NOT = ""

                   MOVE FUNCTION TRIM(
                       WS-STORED-SESSION(WS-INDEX)
                       )
                       TO SESSION-RECORD

                   WRITE SESSION-RECORD

               END-IF

           END-PERFORM

           CLOSE SESSIONS

           IF WS-FOUND = "Y"

               MOVE
                   "OK|LOGOUT_SUCCESS"
                   TO L-RESULT

           ELSE

               MOVE
                   "ERR|INVALID_SESSION"
                   TO L-RESULT

           END-IF

           GOBACK.

       END PROGRAM LOGOUT.