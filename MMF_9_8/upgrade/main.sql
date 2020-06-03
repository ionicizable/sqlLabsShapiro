SPOOL UPGRADE.LOG 

START TRANSACTION;

PROMPT 'dropping and creating tables'
@generateDB

PROMPT 'generating F1Table'
@generateF1Table

PROMPT 'inserting data into F1 table'
@insertIntoF1

PROMPT 'inserting F1 data into database tables'
@insertF1intoDB

PROMPT 'creating view'
@createView

COMMIT;

UNDEFINE USERNAME

SPOOL OFF