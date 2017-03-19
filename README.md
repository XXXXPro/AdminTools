# AdminTools
This repository is for some useful tools for system administrators. Now it contains:

backup.sh — simple bash script to do MySQL databases backup, intended to put to crontab. It saves daily, yesterday, weekly and monthly copies of the bases and sends notification to email if backup failed for some reasons. The data and structure of the bases are stored separately and REPLACE statement is used to make partial recovery of data more easily.

mysqlcompare.sh — script for MySQL databases structure comparision. Requires mysqldiff to be installed. Can operate in two modes:
* prefixed, when tables from database2 with name starting prefix2 in names are compared with tables from database1 with names starting prefix1 (e.g. if prefix1 is ib_ and prefix2 is intb_ database1.ib_forum compared with database2.intb_forum).
* prefixless, when table from database2 compared with table from database1 with same name.
Scipt will print to STDOUT MySQL commands to make structure database1 the same as database2, so the order of databases is important.
Usage for prefixed mode: 
./mysqlcompare.sh database1 prefix1 database2 prefix2
Usage for prefixless mode: 
./mysqlcompare.sh database1 "" database2 ""
