#!/bin/bash

#This script reads the .csv file in Source folder and adds data to table created in MySQL of our AWS instance and also appends store id from name and populates store id column of all tables# Divya, Koteswar, Tarun 08-10-2021

#login credentials of one's MySQL server where we want our data to be stored in
MYSQLu=SaiKotesh
MYSQLp=ChSa@0102
MYSQLd=koteswara

# Creates Processing Folder if it doesn't exist
if [ ! -d ~/Processing ]
then
        mkdir ~/Processing
fi

# creates Processed folder if doesn't exist
if [ ! -d ~/Processed ]
then
        mkdir ~/Processed
fi

# if consumption script is run first, then it stops the script and asks to run data_generation script first
# it also creates tables in specified DB when running it for the first time
if [ `du ~/Source/ | cut -f 1` -eq 0 ]
then
        echo 'Please run data_generation.sh script first'
        exit
elif [ `du ~/Processed/ | cut -f 1` -eq 0 ];
then
        echo "Creating required tables in $MYSQLd Database"
        ~/bash_scripts/table_creation.sh
fi

# STORES variable stores store-ids of different .csv files in Source folder. TABLES variable stores names of all tables present in DB
STORES=`basename -s .csv Source/* | cut -d '-' -f 2 | sort | uniq`
TABLES='Customers Offices Employees Payments Orders OrderDetails Products ProductLines'

# this loop creates temparory tables required for storing data from .csv files in Source folder
for TABLE in $TABLES
do
        mysql -u $MYSQLu -p$MYSQLp -s <<QUERY

        CREATE TABLE IF NOT EXISTS $MYSQLd.t$TABLE
        AS SELECT * FROM $MYSQLd.$TABLE;
        TRUNCATE TABLE $MYSQLd.t$TABLE;
QUERY
done

# this loop moves .csv files from Source to Processing one store_id files once at a time. This loop also adds data to above created temporary tables and add store_id into store_id column from the name of the file.
for STORE in $STORES
do
        mv ~/Source/*-$STORE.csv ~/Processing/
        for TABLE in $TABLES
        do
                mysql -u $MYSQLu -p$MYSQLp -s <<QUERY
                SET GLOBAL LOCAL_INFILE=1;

                LOAD DATA LOCAL INFILE '~/Processing/$TABLE-$STORE.csv'
                INTO TABLE $MYSQLd.t$TABLE
                FIELDS TERMINATED BY ','
                OPTIONALLY ENCLOSED BY '"'
                LINES TERMINATED BY '\n'
                IGNORE 1 ROWS;

                UPDATE $MYSQLd.t$TABLE
                SET t$TABLE.store_id = $STORE
                WHERE t$TABLE.store_id IS NULL;
QUERY
        done
done
# This MySQL query updates old records of tables in DB or inserts new records into tables of DB from temporary tables
mysql -u $MYSQLu -p$MYSQLp -s <<QUERY
-- Customers Update and Insert
UPDATE $MYSQLd.Customers c
INNER JOIN $MYSQLd.tCustomers d ON c.customerNumber = d.customerNumber AND c.store_id = d.store_id
   SET c.customerName = d.customerName,
       c.contactLastName = d.contactLastName,
       c.contactFirstName = d.contactFirstName,
       c.phone = d.phone,
       c.addressLine1 = d.addressLine1,
       c.addressLine2 = d.addressLine2,
       c.city = d.city,
       c.state = d.state,
       c.postalCode = d.postalCode,
       c.country = d.country,
       c.salesRepEmployeeNumber = d.salesRepEmployeeNumber,
       c.creditLimit = d.creditLimit,
       c.update_timestamp = d.update_timestamp;
       
INSERT INTO $MYSQLd.Customers
SELECT t.*
FROM $MYSQLd.tCustomers as t
LEFT JOIN $MYSQLd.Customers as c ON t.customerNumber = c.customerNumber AND t.store_id = c.store_id
WHERE c.customerNumber IS NULL;

DROP TABLE $MYSQLd.tCustomers;

-- Payments Update and Insert
UPDATE $MYSQLd.Payments c
INNER JOIN $MYSQLd.tPayments d ON c.customerNumber = d.customerNumber AND c.checkNumber = d.checknumber
   SET c.update_timestamp = d.update_timestamp,
       c.paymentDate = d.paymentDate ,
       c.amount = d.amount
WHERE c.store_id = d.store_id;

INSERT INTO $MYSQLd.Payments
SELECT T.*
FROM $MYSQLd.tPayments T
 LEFT JOIN $MYSQLd.Payments P ON T.customerNumber = P.customerNumber AND T.checkNumber = P.checknumber AND T.store_id = P.store_id
WHERE P.customerNumber IS NULL;

DROP TABLE $MYSQLd.tPayments;

-- Offices Update and Insert
UPDATE $MYSQLd.Offices o
INNER JOIN $MYSQLd.tOffices t
   SET o.city = t.city,
       o.phone = t.phone,
       o.addressLine1 = t.addressLine1,
       o.addressLine2 = t.addressLine2,
       o.state = t.state,
       o.country = t.country,
       o.postalCode = t.postalCode,
       o.territory = t.territory,
       o.update_timestamp = t.update_timestamp
WHERE o.officeCode = t.officeCode AND o.store_id = t.store_id;
INSERT INTO $MYSQLd.Offices
SELECT t.*
FROM $MYSQLd.tOffices t
  LEFT JOIN $MYSQLd.Offices o ON t.officeCode = o.officeCode AND t.store_id = o.store_id
WHERE o.officeCode IS NULL;

DROP TABLE $MYSQLd.tOffices;

-- ProductLines Update and Insert
UPDATE $MYSQLd.ProductLines pl
INNER JOIN $MYSQLd.tProductLines t
   SET pl.textDescription = t.textDescription,
       pl.htmlDescription = t.htmlDescription,
       pl.image = t.image,
       pl.update_timestamp = t.update_timestamp
WHERE pl.productLine = t.productLine AND pl.store_id = t.store_id;

INSERT INTO $MYSQLd.ProductLines
SELECT t.*
FROM $MYSQLd.tProductLines t
  LEFT JOIN $MYSQLd.ProductLines p ON t.productLine = p.productLine AND t.store_id = p.store_id
WHERE p.productLine IS NULL;

DROP TABLE $MYSQLd.tProductLines;

-- Products Update and Insert
UPDATE $MYSQLd.Products p
INNER JOIN $MYSQLd.tProducts t
   SET p.productName = t.productName,
       p.productLine = t.productLine,
       p.productScale = t.productScale,
       p.productVendor = t.productVendor,
       p.productDescription = t.productDescription,
       p.quantityInStock = t.quantityInStock,
       p.buyPrice = t.buyPrice,
       p.MSRP = t.MSRP,
       p.update_timestamp = t.update_timestamp
WHERE p.productCode = t.productCode AND p.store_id = t.store_id;

INSERT INTO $MYSQLd.Products
SELECT t.*
FROM $MYSQLd.tProducts t
  LEFT JOIN $MYSQLd.Products p ON t.productCode = p.productCode AND t.store_id = p.store_id
WHERE p.productCode IS NULL;

DROP TABLE $MYSQLd.tProducts;

-- Orders Update and Insert
UPDATE $MYSQLd.Orders o
INNER JOIN $MYSQLd.tOrders t
   SET o.orderNumber = t.orderNumber,
       o.orderDate = t.orderDate,
       o.requiredDate = t.requiredDate,
       o.shippedDate = t.shippedDate,
       o.status = t.status,
       o.comments = t.comments,
       o.update_timestamp = t.update_timestamp
WHERE o.orderNumber = t.orderNumber AND o.store_id = t.store_id;

INSERT INTO $MYSQLd.Orders
SELECT t.*
FROM $MYSQLd.tOrders t
  LEFT JOIN $MYSQLd.Orders o ON t.orderNumber = o.orderNumber AND t.store_id = o.store_id
WHERE o.orderNumber IS NULL;

DROP TABLE $MYSQLd.tOrders;

-- OrderDetails Update and Insert
UPDATE $MYSQLd.OrderDetails o
INNER JOIN $MYSQLd.tOrderDetails t ON o.orderNumber = t.orderNumber AND o.productCode = t.productCode
SET  o.update_timestamp = t.update_timestamp,
         o.quantityOrdered = t.quantityOrdered,
         o.priceEach = t.priceEach;

INSERT INTO $MYSQLd.OrderDetails
SELECT t.*
FROM $MYSQLd.tOrderDetails t
  LEFT JOIN $MYSQLd.OrderDetails o ON t.productCode = o.productCode AND t.orderNumber = o.orderNumber AND t.store_id = o.store_id
WHERE o.productCode IS NULL;

DROP TABLE $MYSQLd.tOrderDetails;

-- Employees Update and Insert
UPDATE $MYSQLd.Employees o
INNER JOIN $MYSQLd.tEmployees t
SET  o.lastName = t.lastName,
        o.firstName = t.firstName,
        o.extension = t.extension,
        o.email = t.email,
        o.reportsTo = t.reportsTo,
        o.jobTitle = t.jobTitle,
        o.officeCode = t.officeCode,
        o.store_id = t.store_id,
        o.update_timestamp = t.update_timestamp
WHERE  o.employeeNumber = t.employeeNumber AND t.store_id = o.store_id;

INSERT INTO $MYSQLd.Employees
SELECT t.*
FROM $MYSQLd.tEmployees t
 LEFT JOIN $MYSQLd.Employees e ON t.employeeNumber = e.employeeNumber AND t.store_id = e.store_id
WHERE e.employeeNumber IS NULL;

DROP TABLE $MYSQLd.tEmployees;
QUERY


# moves files from Processing to Processed and renaming files during transfer
DATE=`date +"%Y-%m-%d_%T"`
cd ~/Processing/
basename -s .csv  ./*.csv | xargs -n1 -i mv ./{}.csv ~/Processed/{}-$DATE.csv

DATE=`date +"%d-%m-%Y %T"`
echo $DATE,$STORES,Consumption > ~/bash_scripts/history.log
tr "," "\t" < ~/bash_scripts/history.log >> ~/bash_scripts/batch.log

echo script ended
