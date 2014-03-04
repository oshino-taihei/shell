$ORACLE_HOME/bin/lsnrctl stop
$ORACLE_HOME/bin/sqlplus " / as sysdba" <<!
shutdown immediate
exit
!
$ORACLE_HOME/bin/emctl stop dbconsole


