#!/bin/bash
# This is a script that generates data from 6 days of data of a database. This data is generated for days and different storenumbers
#Divya, Koteswar and Tarun 04/10/2021

read -p 'Enter the number of stores for which data has to be generated for \(default is 5 stores, press "enter" for default \)' STORES

if [ -z "$STORES"]
then
 STORES=5
fi

if [! -d ~/Source]
then
  mkdir ~/Source/
fi

i=1
while [ $i -le $STORES ]
do
	randomV1=`shuf -n 1 -i 09-14` #random variable for selecting DB
        cd ~/Data/CM_200506$randomV1/
        basename -s .csv  ./*.csv | xargs -n1 -i cp ./{}.csv ~/Source/{}_$i.csv   #populates all tables in dwstage with selected DB's data
        TABLES='customers employees products'
        for TABLE in $TABLES
        do
        	randomV2=`shuf -n 1 -i 1-100`
                ORECORDS=`wc -l < ~/Data/CM_200506$randomV1/$TABLE.csv`     #original number of records
                ((ORECORDS--))
                IRECORDS=$((ORECORDS * randomV2))
                IRECORDS=$((IRECORDS / 100))                               #random number of records
                shuf -n $IRECORDS ~/Data/CM_200506$randomV1/$TABLE.csv > /Source/$TABLE_i.csv
        done
        ((i++))
done



