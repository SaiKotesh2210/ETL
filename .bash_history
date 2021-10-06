ls -al
mkdir bash_scripts
ls
cd bash_scripts
vi transfer.sh
cat transfer.sh
./transfer.sh
sudo ./transfer.sh
sudo systemctl status mysqld
vi transfer.sh
which bash
echo $SHELL
mysql -u SaiKotesh -pChSa@0102
vi transfer.sh
./transfer.sh
ls -al
chmod 777 transfer.sh
sudo ./transfer.sh
vi transfer.sh
sudo ./transfer.sh
vi transfer.sh
./transfer.sh
vi transfer.sh
./transfer.sh
exit
ls
cat bash_scripts/transfer.sh 
EXIT
exit
vi bash_scripts/transfer.sh 
exit
pwd
mkdir data
chmod 777 data
ls -al
cd ..
ls -al
exit
ls
ls -al
exit
cd ..
ls -al
chmod 777 SaiKotesh/
ls -al
exit
ls
rm -r data
ls
cd CM_20050610
ls
cat Customers.csv 
exit
history
mysql -u SaiKotesh -pChSa@0102
ls
vi bash_scripts/t
cd bash_scripts/
ls
vi transfer.sh 
pwd
./transfer.sh 
cd ..
ls
rm -r CM_20050609
ls
rm -r CM_20050610
rm -r CM_20050611
rm -r CM_20050612
rm -r CM_20050613
rm -r CM_20050614
ls
exit
ls
exit
ls
pwd
ls -al
cd ..
ls -al
exit
ls
cd ..
ls
ls -al
exit
ls
vi bash_scripts/transfer.sh 
SET GLOBAL LOCAL_INFILE = 1
mysql -u SaiKotesh -p ChSa@0102
mysql -u SaiKotesh -p
exit
ls
vi bash_scripts/transfer.sh 
exit
ls
cd Data
ls
cd CM_20050609
ls
awk 'int(100*rand())%5<1' customers.csv
cat customers.csv
awk 'int(100*rand())%5<1' customers.csv > data.txt
ls
cat data.txt
wc data.txt
wc -l data.txt
rm -l data.txt
rm data.txt
exit
history
exit
ls
vi bash_scripts/transfer.sh 
exit
vi bash_scripts/transfer.sh 
exit
vi bash_scripts/transfer.sh 
mysql -u SaiKotesh -p
MYSQLu=SaiKotesh
MYSQLp=ChSa@0102
MYSQLd=koteswara_dwstage
mysql -u $MYSQLu -p $MYSQLp -e "SET GLOBAL LOCAL_INFILE=1;"
mysql -u $MYSQLu -p$MYSQLp -e "SET GLOBAL LOCAL_INFILE=1;"
mysql -u $MYSQLu -p$MYSQLp -e 
FILE '~/Source/customers_$i.csv'
TO TABLE $MYSQLd.customers
ATED BY ','
ALLY ENCLOSED BY '"'
ES TERMINATED BY '\r\n'
ORE 1 ROWS;"



clear
mysql -u $MYSQLu -p$MYSQLp -e "LOAD DATA LOCAL INFILE '~/Source/customers_$i.csv' INTO TABLE $MYSQLd.customers FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;"

mysql -u $MYSQLu -p$MYSQLp -e
mysql -u $MYSQLu -p$MYSQLp -e "LOAD DATA LOCAL INFILE '~/Source/customers_$i.csv' INTO TABLE $MYSQLd.customers FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;"
vi bash_scripts/transfer.sh 
mysql -u SaiKotesh -pChSa@0102 <<SCRIPT

LOAD DATA LOCAL INFILE '/home/SaiKotesh/Data/CM_20050609/customers.csv'
INTO TABLE koteswara_dwstage.customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SCRIPT

mysql -u SaiKotesh -pChSa@0102 <<SCRIPT

LOAD DATA LOCAL INFILE '/home/SaiKotesh/Data/CM_20050609/customers.csv'
INTO TABLE koteswara_dwstage.customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SCRIPT

mysql -u SaiKotesh -pChSa@0102 <<SCRIPT

LOAD DATA LOCAL INFILE '/home/SaiKotesh/Data/CM_20050609/customers.csv'
INTO TABLE koteswara_dwstage.customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SCRIPT

exit
ls
rm -r data
rm -r Data
ls
cd bash_scripts/
ls
exit
cd bash_scripts/
mv transfer.sh table_creation.sh
ls
vi data_generation.sh
ls
vi data_generation.sh
vi etl_process_dwstage.sh
vi table_creation.sh 
vi etl_process_dwstage.sh
vi data_generation.sh
ls
vi data_generation.sh
chmod 777 data_generation.sh 
chmod 777 etl_process_dwstage.sh 
vi table_creation.sh 
ls
vi data_generation.sh
vi table_creation.sh 
vi etl_process_dwstage.sh
cd ~
ls
vi bash_scripts/table_creation.sh 
cd bash_scripts/
./table_creation.sh 
vi table_creation.sh 
./table_creation.sh 
vi table_creation.sh 
exit
vi bash_scripts/etl_process_dwstage.sh 
exit
vi bash_scripts/data_generation.sh 
ls bash_scripts/data_generation.sh 
cd bash_scripts/
ls
vi data_generation.sh 
exit
cd bash_scripts/
./data_generation.sh 
ls
vi data_generation.sh 
vi table_creation.sh 
exit
