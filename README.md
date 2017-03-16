# AdminTools
This repository is for some useful tools for system administrators. Now it contains:

backup.sh — simple bash script to do MySQL databases backup, intended to put to crontab. It saves daily, yesterday, weekly and monthly copies of the bases and sends notification to email if backup failed for some reasons. The data and structure of the bases are stored separately and REPLACE statement is used to make partial recovery of data more easily.
