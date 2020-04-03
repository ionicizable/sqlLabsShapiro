SPOOL INSTALL.LOG

DEFINE USERNAME = &&1
DEFINE TABLESPACE_PATH = &&2

PROMPT 'username: &&USERNAME'
PROMPT 'tablespace location: &&TABLESPACE_PATH'

PROMPT 'executing create_tablespace.sql'
@create_tablespace &&USERNAME &&TABLESPACE_PATH

PROMPT 'index and data tablespaces created succesfully'

PROMPT 'executing create_user.sql'

@create_user &&USERNAME

PROMPT 'user created succesfully'

PROMPT 'executing user_privilege.sql'

@user_privilege &&USERNAME

PROMPT 'privileges given to &&USERNAME succesfully'

UNDEFINE USERNAME
UNDEFINE TABLESPACE_PATH

SPOOL OFF