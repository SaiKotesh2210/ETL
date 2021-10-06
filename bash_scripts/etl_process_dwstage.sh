#!/bin/bash

MYSQLu=SaiKotesh
MYSQLp=ChSa@0102
MYSQLd=koteswara_dwstage

mysql -u $MYSQLu -p$MYSQLp -e "SET GLOBAL LOCAL_INFILE=1;"

TABLES='customers employees offices payments orders orderdetails products productlines'

mv -r ~/Source/* ~/Processing/ 

for TABLE in $TABLES
do
	i=1
	while [ $i -le $STORES ]
	do
		mysql -u $MYSQLu -p$MYSQLp <<QUERY 
			"LOAD DATA LOCAL INFILE '~/Processing/$TABLE_$i.csv'
			INTO TABLE $MYSQLd.$TABLE
			FIELDS TERMINATED BY ','
			OPTIONALLY ENCLOSED BY '"'
			LINES TERMINATED BY '\r\n'
			IGNORE 1 ROWS;"
 
			"UPDATE $MYSQLd.$TABLE 
			SET store_id = $i
			SET create_timestamp = NULL
			SET update_timestamp = NULL;"
		QUERY

		(( i++ ))
	done
done

