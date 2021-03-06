--INSERT INTO COUNTRY
DELETE FROM COUNTRY;
INSERT INTO COUNTRY
SELECT ROWNUM, t.* FROM (
SELECT DISTINCT SUBSTR(EVENT,1,INSTR(EVENT ,' ')-1) country FROM F1
) t;

--INSERT INTO DRIVER
DELETE FROM DRIVER;
INSERT INTO DRIVER
SELECT ROWNUM, t.* FROM (
SELECT DISTINCT SUBSTR(driver,1,INSTR(driver ,' ')-1) fname, SUBSTR(driver,INSTR(driver ,' ')+1,LENGTH(driver)) sname FROM F1
) t;

--INSERT INTO CONSTRUCTOR
DELETE FROM "CONSTRUCTOR" c ;
INSERT INTO "CONSTRUCTOR"
SELECT ROWNUM, t.* FROM (
SELECT DISTINCT "Constructor", MIN(ct.ID) FROM F1
INNER JOIN COUNTRY  ct ON ct.NAME = SUBSTR(F1.EVENT,1,INSTR(F1.EVENT ,' ')-1)
GROUP BY "Constructor"
) t;

--INSERT INTO TRACK
DELETE FROM TRACK t ;
INSERT INTO TRACK (ID, TRACK_NAME, "LENGTH", LAPS, LONGITUDE, LATITUDE, COUNTRY_ID)
SELECT ROWNUM, t.* FROM (
SELECT DISTINCT F1.CIRCUIT, 0 distance, F1.LAPS, NULL longitude, NULL latitude, ct.ID FROM F1
INNER JOIN COUNTRY  ct ON ct.NAME = SUBSTR(F1.EVENT,1,INSTR(F1.EVENT ,' ')-1)
) t;

--INSERT INTO EVENT
DELETE FROM EVENT;
INSERT INTO EVENT (ID, TRACK_ID, GRAND_PRIX, "DATE")
SELECT ROWNUM, t.* FROM (
SELECT DISTINCT tk.ID trackId, F1.EVENT grandPrix, TO_DATE(F1."Date", 'MM/DD/YYYY') "date" FROM F1
INNER JOIN TRACK tk ON tk.TRACK_NAME = F1.CIRCUIT
) t;

--INSERT INTO PARTICIPANT
DELETE FROM PARTICIPANT p ;
INSERT INTO PARTICIPANT (ID, EVENT_ID, DRIVER_ID, CONSTRUCTOR_ID, START_POSITION, FINISH_POSITION, POINTS, "RESULT")
SELECT ROWNUM, t.eventId,t.driverId,t.constructorId,t.START_DRIVER_PLACE,t.finishPosition,t.POINTS, (CASE WHEN t.finishPosition = 1 THEN TO_DSINTERVAL(CONCAT(CONCAT('+00 ',t.timeResult),'.00000') ) 
       ELSE 
       (
       SELECT TO_DSINTERVAL(CONCAT(CONCAT('+00 ',F1."Time"),'.00000') ) 
       FROM F1
       WHERE f1."Date" =t."Date" AND f1.DRIVER = t.WINNER
       )
       +TO_DSINTERVAL(CONCAT('+00 00:00:',t.timeResult) ) END) "RESULT" 
       FROM (
	SELECT DISTINCT 
		et.ID eventId,
		dr.ID driverId,
		cr.ID constructorID, 
		F1.START_DRIVER_PLACE,
		row_number() OVER(
		        PARTITION BY F1.EVENT, F1."Date" 
		        ORDER BY F1.POINTS DESC
	    ) finishPosition, 
	    F1.POINTS,
	    F1."Time" timeResult,
	    F1."Date",
	    F1.WINNER 
	FROM F1
	INNER JOIN DRIVER dr ON dr.FIRST_NAME = SUBSTR(F1.DRIVER ,1,INSTR(driver ,' ')-1)
	INNER JOIN EVENT et ON et.GRAND_PRIX = F1.EVENT AND et."DATE" = TO_DATE(F1."Date", 'MM/DD/YYYY')
	INNER JOIN "CONSTRUCTOR" cr ON cr.BRAND_NAME = F1."Constructor"
) t;

COMMIT;