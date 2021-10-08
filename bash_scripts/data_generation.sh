#!/bin/bash
# This is a script that generates data from 6 days of data of a database. This data is generated for days and different storenumbers
#Divya, Koteswar and Tarun 04/10/2021


STORES=$1

re='^[0-9]+$'
 
if [ -z "$STORES" ]
then
        echo "Please enter a number beside the script as an option, to specify store id"
        exit
elif ! [[ $STORES =~ $re ]]
then
        echo "error: Not a number"
        exit
fi

if [ ! -d ~/Data ]
then
    mkdir ~/Data/
fi

MYSQLu=koteswara
MYSQLp=koteswara@23B
MYSQLh=54.224.209.13
MYSQLd=ClassicModels

TABLES='Customers Employees Orders Products OrderDetails ProductLines Offices Payments'

for TABLE in $TABLES
do
        mysql -h $MYSQLh -u $MYSQLu -p$MYSQLp $MYSQLd -B -e "SELECT * FROM $TABLE;" > ~/Data/$TABLE.sh
        chmod 775 ~/Data/*
        cat ~/Data/$TABLE.sh | sed 's/\t/,/g' | tail -n +2 > ~/Data/$TABLE.csm
        cat ~/Data/$TABLE.csm > ~/Data/$TABLE.csv
        if [ "$TABLE" = Customers ] || [ "$TABLE" = Offices ]
        then
                COLUMNSc=`cat ~/Data/$TABLE.sh | head -n +1 | wc -w`
                COLUMNSc=$((COLUMNSc - 1))
                cut -d "," -f 1-$COLUMNSc ~/Data/$TABLE.csm > ~/Data/$TABLE.csv
        fi
        rm ~/Data/$TABLE.sh ~/Data/$TABLE.csm
done

cd ~/Data/
basename -s .csv  ./*.csv | xargs -n1 -i cp ./{}.csv ./{}-$STORES.csv
TABLES='Customers Employees Products'
for TABLE in $TABLES
do
        random=`shuf -n 1 -i 1-100`
        ORECORDS=`wc -l < ~/Data/$TABLE.csv`     #original number of records
        ((ORECORDS--))
        IRECORDS=$((ORECORDS * random))
        IRECORDS=$((IRECORDS / 100))                               #random number of records
        shuf -n $IRECORDS ~/Data/$TABLE.csv > ~/Data/$TABLE-$STORES.csv
done


if [ ! -d ~/Source ]
then
    mkdir ~/Source/
fi

MYSQLu=SaiKotesh
MYSQLp=ChSa@0102
MYSQLd=koteswara

mysql -u $MYSQLu -p$MYSQLp -e 'SET GLOBAL local_infile=1;'
TABLES='Customers Employees Orders Products OrderDetails ProductLines Offices Payments'

for TABLE in $TABLES
do

	mysql -u $MYSQLu -p$MYSQLp <<QUERY

	 SET GLOBAL SQL_MODE='';

		CREATE TABLE IF NOT EXISTS $MYSQLd.p$TABLE AS
		SELECT *
		FROM $MYSQLd.$TABLE;
		
		LOAD DATA LOCAL INFILE '~/Data/$TABLE-$STORES.csv'
		INTO TABLE $MYSQLd.p$TABLE
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '"'
		LINES TERMINATED BY '\n'
		IGNORE 1 ROWS;

		UPDATE $MYSQLd.p$TABLE
		SET p$TABLE.update_timestamp = current_timestamp(),
			p$TABLE.create_timestamp = current_timestamp();
		
		
QUERY
    
done

mysql -u $MYSQLu -p$MYSQLp <<QUERY
USE $MYSQLd;
CREATE TEMPORARY TABLE temp
AS
SELECT E.*
FROM pEmployees E;

INSERT INTO temp

SELECT E.*
FROM pEmployees E
  LEFT JOIN pEmployees E1 ON E.reportsTo = E1.employeeNumber 
WHERE E1.employeeNumber IS NOT NULL
OR    E.reportsTo IS NULL ;

TRUNCATE pEmployees;
INSERT INTO pEmployees

SELECT *
FROM temp;
DROP TEMPORARY TABLE temp; 

CREATE TEMPORARY TABLE temp
AS
SELECT O.*
FROM pOffices O;

INSERT INTO temp

SELECT O.*
FROM pOffices O
  INNER JOIN pEmployees E ON O.officeCode = E.officeCode;

TRUNCATE pOffices;
INSERT INTO pOffices

SELECT *
FROM temp;
DROP TEMPORARY TABLE temp; 

CREATE TEMPORARY TABLE temp
AS
SELECT C.*
FROM pCustomers C;

INSERT  INTO temp

SELECT C.*
FROM pEmployees E
  LEFT JOIN pCustomers C ON C.salesRepEmployeeNumber = E.employeeNumber  
  WHERE E.employeeNumber IS NOT NULL;

TRUNCATE pCustomers;
INSERT  INTO pCustomers

SELECT *
FROM temp;
DROP TEMPORARY TABLE temp; 

CREATE TEMPORARY TABLE temp
AS
SELECT P.*
FROM pPayments P;

INSERT  INTO temp

SELECT P.*
FROM pPayments P
  INNER JOIN pCustomers C ON P.customerNumber = C.customerNumber;

TRUNCATE pPayments;
INSERT  INTO pPayments

SELECT *
FROM temp;
DROP TEMPORARY TABLE temp; 

CREATE TEMPORARY TABLE temp
AS
SELECT O.*
FROM pOrders O;

INSERT  INTO temp

SELECT O.*
FROM pOrders O
  INNER JOIN pCustomers C ON O.customerNumber = C.customerNumber  ;

TRUNCATE pOrders;
INSERT  INTO pOrders

SELECT *
FROM temp;
DROP TEMPORARY TABLE temp; 

CREATE TEMPORARY TABLE temp
AS
SELECT OD.*
FROM pOrderDetails OD;

INSERT  INTO temp

SELECT OD.*
FROM pOrders O
  INNER JOIN pOrderDetails OD ON O.orderNumber = OD.orderNumber 
  INNER JOIN pProducts P ON OD.productCode = P.productCode  ;

TRUNCATE pOrderDetails;
INSERT  INTO pOrderDetails

SELECT *
FROM temp;
DROP TEMPORARY TABLE temp; 

CREATE TEMPORARY TABLE temp
AS
SELECT PL.*
FROM pProductLines PL;

INSERT  INTO temp

SELECT PL.*
FROM pProducts PD
  INNER JOIN pProductLines PL ON PD.productLine = PL.productLine  ;

TRUNCATE pProductLines;
INSERT  INTO pProductLines

SELECT *
FROM temp;
DROP TEMPORARY TABLE temp; 

QUERY
for TABLE in $TABLES	
do
	mysql -u $MYSQLu -p$MYSQLp -B -e "SELECT * FROM $MYSQLd.p$TABLE;" > ~/Source/$TABLE-$STORES.sh
	cat ~/Source/$TABLE-$STORES.sh | sed 's/\t/,/g' > ~/Source/$TABLE-$STORES.csv
	rm ~/Source/$TABLE-$STORES.sh
	#mysql -u $MYSQLu -p$MYSQLp -e "DROP TABLE $MYSQLd.p$TABLE;"
done

rm -r ~/Data/
