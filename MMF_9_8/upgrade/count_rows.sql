set serveroutput on;

declare rowCount NUMBER;

begin
select count(*) into rowCount from COUNTRY;
DBMS_OUTPUT.PUT_LINE('COUNTRY - row count: '|| rowCount);
select count(*) into rowCount from TRACK;
DBMS_OUTPUT.PUT_LINE('TRACK - row count: '|| rowCount); 
select count(*) into rowCount from DRIVER; 
DBMS_OUTPUT.PUT_LINE('DRIVER - row count: '|| rowCount); 
select count(*) into rowCount from EVENT;
DBMS_OUTPUT.PUT_LINE('EVENT - row count: '|| rowCount);
select count(*) into rowCount from CONSTRUCTOR;
DBMS_OUTPUT.PUT_LINE('CONSTRUCTOR - row count: '|| rowCount); 
select count(*) into rowCount from PARTICIPANT;
DBMS_OUTPUT.PUT_LINE('PARTICIPANT - row count: '|| rowCount); 
end;
/