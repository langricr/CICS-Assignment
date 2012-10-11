       IDENTIFICATION DIVISION.
        PROGRAM-ID. RLPRGM.
         AUTHOR. RICHARD LANG.
        
       ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
         SOURCE-COMPUTER. RS-6000.
         OBJECT-COMPUTER. RS-6000.
       
       DATA DIVISION.
        WORKING-STORAGE SECTION.
         COPY 'RLMAP1'.
         
         01 WS-TRANSFER-FIELD       PIC X(2).
         01 WS-TRANSFER-LENGTH      PIC S9(4) COMP VALUE 2.
         
        LINKAGE SECTION.
         01 DFHCOMMAREA.
          05 LK-TRANSFER                   PIC XX.
          
       PROCEDURE DIVISION.
        000-START-LOGIC.
         EXEC CICS HANDLE AID PF2(400-CHOICE-2) END-EXEC.
         EXEC CICS HANDLE AID PF9(700-CHOICE-9) END-EXEC.
         EXEC CICS HANDLE CONDITION MAPFAIL(100-FIRST-TIME) END-EXEC.
         
         IF EIBCALEN EQUALS 2
          GO TO 100-FIRST-TIME
         END-IF.
         
         EXEC CICS RECEIVE MAP('MENU') MAPSET('RLMAP1') END-EXEC.
       
         GO TO 200-MAIN-LOGIC.
          
        100-FIRST-TIME.
         MOVE LOW-VALUES TO MENUO.
          
         EXEC CICS SEND MAP('MENU') MAPSET('RLMAP1') ERASE END-EXEC.
         EXEC CICS RETURN TRANSID('RL01') END-EXEC.
            
        200-MAIN-LOGIC.
         IF CHOICEI IS EQUAL TO '1'
          GO TO 300-CHOICE-1
         ELSE
         IF CHOICEI IS EQUAL TO '2'
          GO TO 400-CHOICE-2
         ELSE
         IF CHOICEI IS EQUAL TO '3'
          GO TO 500-CHOICE-3
         ELSE
         IF CHOICEI IS EQUAL TO '4'
          GO TO 600-CHOICE-4
         ELSE
         IF CHOICEI IS EQUAL TO '9'
          GO TO 700-CHOICE-9
         ELSE
          GO TO 999-SEND-ERROR-MSG
         END-IF.
         
       300-CHOICE-1.
        MOVE LOW-VALUES TO MENUO.
        MOVE 'YOU ENTERED ONE' TO MSGO.
        EXEC CICS SEND MAP('MENU') MAPSET('RLMAP1') END-EXEC.
        EXEC CICS RETURN TRANSID('RL01') END-EXEC.
        
       400-CHOICE-2.
        EXEC CICS XCTL
          PROGRAM('RLPRGI')
          COMMAREA( WS-TRANSFER-FIELD )
          LENGTH( WS-TRANSFER-LENGTH )
        END-EXEC.
         
       500-CHOICE-3.
        MOVE LOW-VALUES TO MENUO.
        MOVE 'YOU ENTERED THREE' TO MSGO.
        EXEC CICS SEND MAP('MENU') MAPSET('RLMAP1') END-EXEC.
        EXEC CICS RETURN TRANSID('RL01') END-EXEC.
         
       600-CHOICE-4.
        MOVE LOW-VALUES TO MENUO.
        MOVE 'YOU ENTERED FOUR' TO MSGO.
        EXEC CICS SEND MAP('MENU') MAPSET('RLMAP1') END-EXEC.
        EXEC CICS RETURN TRANSID('RL01') END-EXEC.
         
       700-CHOICE-9.
        MOVE LOW-VALUES TO MENUO.
        MOVE 'YOU ENTERED 9 - PROGRAM ENDING' TO MSGO.
        EXEC CICS SEND MAP('MENU') MAPSET('RLMAP1') END-EXEC.
        EXEC CICS RETURN END-EXEC.
         
       999-SEND-ERROR-MSG.
        MOVE LOW-VALUES TO MENUO.
        MOVE 'YOU HAVE ENTER AN INVALID NUMBER.' TO MSGO.
        EXEC CICS SEND MAP('MENU') MAPSET('RLMAP1') END-EXEC.
        EXEC CICS RETURN TRANSID('RL01') END-EXEC.