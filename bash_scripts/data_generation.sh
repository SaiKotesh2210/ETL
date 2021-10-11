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

if [ "$2" = 1 ]
then
        tables='Employees'
elif [ "$2" = 3 ] || [ -z "$2" ]
then
        tables='Customers Employees Products'
elif [ "$2" = 5 ]
then
        tables='Customers Employees Products Offices Productlines'
else
        echo 'Enter 1 or 3 or 5 for those number of fact tables to be randomized'
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
        cat ~/Data/$TABLE.sh | sed 's/,/ /g' | sed 's/\t/,/g' | tail -n +2 > ~/Data/$TABLE.csm
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
for TABLE in $tables
do
        random=`shuf -n 1 -i 10-100`
        ORECORDS=`wc -l < ~/Data/$TABLE.csv`     #original number of records
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

TABLES='Customers Employees Orders Products OrderDetails ProductLines Offices Payments'

for TABLE in $TABLES
do

	mysql -u $MYSQLu -p$MYSQLp <<QUERY

	 	SET GLOBAL SQL_MODE='';

	 	SET GLOBAL LOCAL_INFILE=1;

		CREATE TABLE IF NOT EXISTS $MYSQLd.p$TABLE AS
		SELECT *
		FROM $MYSQLd.$TABLE;

		TRUNCATE TABLE $MYSQLd.p$TABLE;
		
		LOAD DATA LOCAL INFILE '~/Data/$TABLE-$STORES.csv'
		INTO TABLE $MYSQLd.p$TABLE
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '"'
		LINES TERMINATED BY '\n';

		UPDATE $MYSQLd.p$TABLE
		SET p$TABLE.update_timestamp = current_timestamp(),
			p$TABLE.create_timestamp = current_timestamp();
		
		
QUERY
    
done

mysql -u $MYSQLu -p$MYSQLp <<QUERY

INSERT INTO $MYSQLd.pEmployees
 
WITH temp AS (SELECT E.employeeNumber,
E.lastName,
E.firstName,
E.extension,
E.email,
E.reportsTo,
E.jobTitle,
E.officeCode,
101104 AS store_id,
E.create_timestamp,
E.update_timestamp
			FROM $MYSQLd.pEmployees E
			LEFT JOIN $MYSQLd.pEmployees E1 ON E.reportsTo = E1.employeeNumber
			WHERE E1.employeeNumber IS NOT NULL
			OR E.reportsTo IS NULL) 

SELECT DISTINCT t.* FROM temp t;

DELETE FROM $MYSQLd.pEmployees WHERE store_id IS NULL;

UPDATE $MYSQLd.pEmployees SET store_id = NULL;

INSERT INTO $MYSQLd.pOffices

WITH t AS (SELECT O.officeCode,
O.city,
O.phone,
O.addressLine1,
O.addressLine2,
O.state,
O.country,
O.postalCode,
O.territory,
101104 AS store_id,
O.create_timestamp,
O.update_timestamp
			FROM $MYSQLd.pOffices O
			INNER JOIN $MYSQLd.pEmployees E ON O.officeCode = E.officeCode) 

SELECT DISTINCT * FROM t;

DELETE FROM $MYSQLd.pOffices WHERE store_id IS NULL;

UPDATE $MYSQLd.pOffices SET store_id = NULL;

INSERT INTO $MYSQLd.pCustomers
 
WITH t AS (SELECT C.customerNumber, 
C.customerName, 
C.contactLastName, 
C.contactFirstName, 
C.phone,
C.addressLine1,
C.addressLine2,
C.city,
C.state,
C.postalCode,
C.country,
C.salesRepEmployeeNumber,
C.creditLimit,
101104 AS store_id,
C.create_timestamp,
C.update_timestamp
			FROM $MYSQLd.pCustomers C
			LEFT JOIN $MYSQLd.pEmployees E ON C.salesRepEmployeeNumber = E.employeeNumber
			WHERE E.employeeNumber IS NOT NULL
			OR C.salesRepEmployeeNumber IS NULL) 

SELECT DISTINCT t.* FROM t;

DELETE FROM $MYSQLd.pCustomers WHERE store_id IS NULL;

UPDATE $MYSQLd.pCustomers SET store_id = NULL;

INSERT INTO $MYSQLd.pPayments
 
WITH t AS (SELECT P.checkNumber,
P.paymentDate,
P.amount,
P.customerNumber,
101104 AS store_id,
P.create_timestamp,
P.update_timestamp
			FROM $MYSQLd.pPayments P
			INNER JOIN $MYSQLd.pCustomers C ON P.customerNumber = C.customerNumber
			) 

SELECT DISTINCT t.* FROM t;

DELETE FROM $MYSQLd.pPayments WHERE store_id IS NULL;

UPDATE $MYSQLd.pPayments SET store_id = NULL;

INSERT INTO $MYSQLd.pOrders
 
WITH t AS (SELECT O.orderNumber,
O.orderDate,
O.requiredDate,
O.shippedDate,
O.status,
O.comments,
O.customerNumber,
101104 AS store_id,
O.create_timestamp,
O.update_timestamp
			FROM $MYSQLd.pOrders O
			INNER JOIN $MYSQLd.pCustomers C ON O.customerNumber = C.customerNumber
			) 

SELECT DISTINCT t.* FROM t;

DELETE FROM $MYSQLd.pOrders WHERE store_id IS NULL;

UPDATE $MYSQLd.pOrders SET store_id = NULL;

INSERT INTO $MYSQLd.pOrderDetails

WITH t AS (SELECT OD.orderNumber,
OD.productCode,
OD.quantityOrdered,
OD.priceEach,
OD.orderLineNumber,
101104 AS store_id,
OD.create_timestamp,
OD.update_timestamp
			FROM $MYSQLd.pOrders O
			INNER JOIN $MYSQLd.pOrderDetails OD ON O.orderNumber = OD.orderNumber
			INNER JOIN $MYSQLd.pProducts P ON OD.productCode = P.productCode) 

SELECT DISTINCT t.* FROM t;

DELETE FROM $MYSQLd.pOrderDetails WHERE store_id IS NULL;

UPDATE $MYSQLd.pOrderDetails SET store_id = NULL;

INSERT INTO $MYSQLd.pProductLines
 
WITH t AS (SELECT PL.productLine,
PL.textDescription,
PL.htmlDescription,
PL.image,
101104 AS store_id,
PL.create_timestamp,
PL.update_timestamp
			FROM $MYSQLd.pProductLines PL
			INNER JOIN $MYSQLd.pProducts P ON PL.productLine = P.productLine
			) 

SELECT DISTINCT t.* FROM t;

DELETE FROM $MYSQLd.pProductLines WHERE store_id IS NULL;

UPDATE $MYSQLd.pProductLines SET store_id = NULL;

QUERY
for TABLE in $TABLES	
do
	mysql -u $MYSQLu -p$MYSQLp -B -e "SELECT * FROM $MYSQLd.p$TABLE;" > ~/Source/$TABLE-$STORES.sh
	cat ~/Source/$TABLE-$STORES.sh | sed 's/\t/,/g' > ~/Source/$TABLE-$STORES.csv
	rm ~/Source/$TABLE-$STORES.sh
	mysql -u $MYSQLu -p$MYSQLp -e "DROP TABLE $MYSQLd.p$TABLE;"
done

DATE=`date +"%d-%m-%Y %T"`
echo $DATE,$1,Data_generation > ~/bash_scripts/history.log
tr "," "\t" < ~/bash_scripts/history.log >> ~/bash_scripts/batch.log

rm -r ~/Data/
