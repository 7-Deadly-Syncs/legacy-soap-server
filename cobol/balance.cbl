       IDENTIFICATION DIVISION.
       PROGRAM-ID. BALANCE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 ACCOUNT-ID        PIC X(10).
       01 ACCOUNT-PASS      PIC X(50).
       01 ACCOUNT-BALANCE   PIC 9(9)V99.

       PROCEDURE DIVISION.

           DISPLAY "Enter Account ID:"
           ACCEPT ACCOUNT-ID

           DISPLAY "Enter Password:"
           ACCEPT ACCOUNT-PASS

           *> Connect to Oracle
           EXEC SQL
               CONNECT TO 'XEPDB1'
               USER 'bank' IDENTIFIED BY 'bank'
           END-EXEC

           IF SQLCODE NOT = 0
               DISPLAY "CANNOT CONNECT TO DATABASE"
               STOP RUN
           END-IF

           *> Password Verif
           EXEC SQL
               SELECT balance
               INTO :ACCOUNT-BALANCE
               FROM accounts
               WHERE account_id = :ACCOUNT-ID
               AND password_hash = STANDARD_HASH(:ACCOUNT-PASS, 'SHA256')
           END-EXEC

           IF SQLCODE = 0
               DISPLAY "BALANCE: " ACCOUNT-BALANCE
           ELSE
               DISPLAY "INVALID ACCOUNT OR PASSWORD"
           END-IF

           EXEC SQL
               DISCONNECT CURRENT
           END-EXEC

           STOP RUN.