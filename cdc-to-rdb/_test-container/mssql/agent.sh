#!/bin/bash 

/opt/mssql/bin/mssql-conf set sqlagent.enabled true
echo 'enable sqlagent'
/opt/mssql/bin/sqlservr