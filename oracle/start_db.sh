$ORACLE_HOME/bin/lsnrctl start
$ORACLE_HOME/bin/sqlplus " / as sysdba" <<!
startup
exit
!
$ORACLE_HOME/bin/emctl start dbconsole
