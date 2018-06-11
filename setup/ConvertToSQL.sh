#!/bin/bash -

# convertToSql.sh 
# Converts a CSV to a format suitable for import via SQL

TABLE=ac_mtr_participants_v2
FILE=NewPartViewFinal2.csv
QNAME=$TABLE.sql

sed "s/\(.*\)/INSERT INTO $TABLE VALUES ( \1 );/" $FILE > $QNAME
