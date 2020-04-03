SPOOL DROP.LOG

DEFINE USERNAME = &&1

PROMPT 'username: &&USERNAME'
PROMPT 'executing drop_user.sql'

@drop_user &&USERNAME

PROMPT 'user &&USERNAME dropped succesfully'

PROMPT 'executing drop_tablespace.sql'

@drop_tablespace &&USERNAME

PROMPT 'tablespace &&USERNAME._DATA dropped'

UNDEFINE USERNAME

SPOOL OFF