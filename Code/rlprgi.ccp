       IDENTIFICATION DIVISION.
        PROGRAM-ID. RLPRGM.
         AUTHOR. RICHARD LANG.
       ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
         SOURCE-COMPUTER. RS-6000.
         OBJECT-COMPUTER. RS-6000.
       DATA DIVISION.
        WORKING-STORAGE SECTION.
         COPY 'RLMAP2'.
         01 WS-TRANSFER-FIELD              PIC X(2).
         01 WS-TRANSFER-LENGTH             PIC S9(4) COMP VALUE 2.
         
         01  RECORD-FOUND                  PIC 9 VALUE 1.
         
         01  STUFILE-RECORD.
          05  STUFILE-KEY.
           10  STUFILE-PREFIX              PIC XXX VALUE 'XXX'.
           10  STUFILE-STUDENT-NO          PIC X(7).
          05 STUFILE-NAME                  PIC X(20).
          05 STUFILE-COURSES.
           10 STUFILE-COURSE1.    
            15 STUFILE-COURSE1-PART1       PIC X(4).
            15 STUFILE-COURSE1-PART2       PIC X(4).
           10 STUFILE-COURSE2.             
            15 STUFILE-COURSE2-PART1       PIC X(4).
            15 STUFILE-COURSE2-PART2       PIC X(4).               
           10 STUFILE-COURSE3.             
            15 STUFILE-COURSE3-PART1       PIC X(4).
            15 STUFILE-COURSE3-PART2       PIC X(4).
           10 STUFILE-COURSE4.             
            15 STUFILE-COURSE4-PART1       PIC X(4).
            15 STUFILE-COURSE4-PART2       PIC X(4).               
           10 STUFILE-COURSE5.             
            15 STUFILE-COURSE5-PART1       PIC X(4).
            15 STUFILE-COURSE5-PART2       PIC X(4).  
          05 STUFILE-ADDR-LINE1            PIC X(20).
          05 STUFILE-ADDR-LINE2            PIC X(20).
          05 STUFILE-ADDR-LINE3            PIC X(20).
          05 STUFILE-POSTAL.
            10 STUFILE-POSTAL-1            PIC XXX.
            10 STUFILE-POSTAL-2            PIC XXX.
          05 STUFILE-PHONE.
            10 STUFILE-AREA-CODE           PIC XXX.
            10 STUFILE-EXCHANGE            PIC XXX.
            10 STUFILE-PHONE-NUM           PIC XXXX.
          
          05  FILLER                       PIC X(11) VALUE SPACES.

         01 STUFILE-LENGTH                 PIC S9(4) COMP VALUE 150.
         
        LINKAGE SECTION.
         01 DFHCOMMAREA.
          05 LK-TRANSFER                   PIC XX.
          
       PROCEDURE DIVISION.
        000-START-LOGIC.
         EXEC CICS HANDLE CONDITION MAPFAIL (100-FIRST-TIME) END-EXEC.
         EXEC CICS HANDLE CONDITION NOTFND (400-NOTFND) END-EXEC.
         EXEC CICS HANDLE AID PF9(700-EXIT) END-EXEC.
         
         IF EIBCALEN EQUALS 2
          GO TO 100-FIRST-TIME
         END-IF.
         
         EXEC CICS RECEIVE MAP('MENUINQ') MAPSET('RLMAP2') END-EXEC.
         
         GO TO 200-MAIN-LOGIC.
          
        100-FIRST-TIME.
         MOVE LOW-VALUES TO MENUINQO.
         
         EXEC CICS SEND MAP('MENUINQ') MAPSET('RLMAP2') ERASE 
         END-EXEC.
         EXEC CICS RETURN TRANSID('RL02') END-EXEC.
       
        200-MAIN-LOGIC.
         IF STUNUMI IS NOT NUMERIC  
          MOVE LOW-VALUES TO MENUINQO 
          MOVE 'STUDENT NUMBER MUST NUMERIC' TO MSGO 
          EXEC CICS SEND MAP ('MENUINQ') MAPSET ('RLMAP2')  
          END-EXEC 
          EXEC CICS RETURN TRANSID ('RL02') END-EXEC 
         ELSE
         IF STUNUML < 7
          MOVE LOW-VALUES TO MENUINQO 
          MOVE 'STUDENT NUMBER MUST NUMERIC' TO MSGO 
          EXEC CICS SEND MAP ('MENUINQ') MAPSET ('RLMAP2')  
          END-EXEC 
          EXEC CICS RETURN TRANSID ('RL02') END-EXEC 
         ELSE
          GO TO 300-FIND-RECORD
         END-IF.
          
        300-FIND-RECORD.
         MOVE STUNUMI TO STUFILE-STUDENT-NO.
         
         EXEC CICS READ FILE('STUFILE')
          INTO (STUFILE-RECORD)
          LENGTH (STUFILE-LENGTH)
          RIDFLD (STUFILE-KEY)
         END-EXEC.
        
         IF RECORD-FOUND EQUALS 0
          GO TO 500-DISPLAY-RECORD-NOT-FOUND
         ELSE
          GO TO 600-DISPLAY-RECORD
         END-IF.
          
        400-NOTFND.
         MOVE 0 TO RECORD-FOUND.
         
        500-DISPLAY-RECORD-NOT-FOUND.
         MOVE LOW-VALUES TO MENUINQO.
         MOVE 'STUDENT NUMBER NOT FOUND' TO MSGO.
         EXEC CICS SEND MAP ('MENUINQ') MAPSET ('RLMAP2') END-EXEC.
         EXEC CICS RETURN TRANSID ('RL02') END-EXEC.
         
        600-DISPLAY-RECORD.
         MOVE 1 TO RECORD-FOUND.
         MOVE LOW-VALUES TO MENUINQO.
        
         MOVE STUFILE-STUDENT-NO TO STUNUMO.
         MOVE STUFILE-COURSE1-PART1 TO CODE1AO.
         MOVE STUFILE-COURSE1-PART2 TO CODE1BO.
         MOVE STUFILE-COURSE2-PART1 TO CODE2AO.
         MOVE STUFILE-COURSE2-PART2 TO CODE2BO.
         MOVE STUFILE-COURSE3-PART1 TO CODE3AO.
         MOVE STUFILE-COURSE3-PART2 TO CODE3BO.
         MOVE STUFILE-COURSE4-PART1 TO CODE4AO.
         MOVE STUFILE-COURSE4-PART2 TO CODE4BO.
         MOVE STUFILE-COURSE5-PART1 TO CODE5AO.
         MOVE STUFILE-COURSE5-PART2 TO CODE5BO.
         MOVE STUFILE-NAME TO STUNAMEO.
         MOVE STUFILE-ADDR-LINE1 TO ADDR1O.
	       MOVE STUFILE-ADDR-LINE2 TO ADDR2O.
	       MOVE STUFILE-ADDR-LINE3 TO ADDR3O.
	       MOVE STUFILE-POSTAL-1 TO ADDRPCAO.
	       MOVE STUFILE-POSTAL-2 TO ADDRPCBO.
	       MOVE STUFILE-AREA-CODE TO PHAREO.
         MOVE STUFILE-EXCHANGE TO PHEXCO.
         MOVE STUFILE-PHONE-NUM TO PHNUMO.
         
         EXEC CICS SEND MAP ('MENUINQ') MAPSET ('RLMAP2') END-EXEC.
         EXEC CICS RETURN TRANSID ('RL02') END-EXEC.
        
        700-EXIT.
         EXEC CICS XCTL
          PROGRAM('RLPRGM')
          COMMAREA( WS-TRANSFER-FIELD )
          LENGTH( WS-TRANSFER-LENGTH )
        END-EXEC.