#!/bin/bash

mysql -u SaiKotesh -pChSa@0102 <<SCRIPT

SET GLOBAL LOCAL_INFILE=1;

SCRIPT

mysql -u SaiKotesh -pChSa@0102 <<SCRIPT

DROP DATABASE IF EXISTS koteswara_dwstage;

CREATE DATABASE koteswara_dwstage;

USE koteswara_dwstage;

DROP TABLE IF EXISTS koteswara_dwstage.customers;

CREATE TABLE koteswara_dwstage.customers
(
   customerNumber          INT                                                    NOT NULL,
   customerName            VARCHAR(50)                                            NOT NULL,
   contactLastName         VARCHAR(50)                                            NOT NULL,
   contactFirstName        VARCHAR(50)                                            NOT NULL,
   phone                   VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   addressLine1            VARCHAR(50)                                            NOT NULL,
   addressLine2            VARCHAR(50),
   city                    VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   state                   VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci,
   postalCode              VARCHAR(15),
   country                 VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   salesRepEmployeeNumber  INT,
   creditLimit             DECIMAL(10,2),
   store_id                INT,
   create_timestamp        TIMESTAMP,
   update_timestamp        TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwstage.employees;

CREATE TABLE koteswara_dwstage.employees
(
   employeeNumber    INT                                                     NOT NULL,
   lastName          VARCHAR(50)                                             NOT NULL,
   firstName         VARCHAR(50)                                             NOT NULL,
   extension         VARCHAR(10) CHARSET latin1 COLLATE latin1_swedish_ci    NOT NULL,
   email             VARCHAR(100) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   officeCode        VARCHAR(10)                                             NOT NULL,
   reportsTo         INT,
   jobTitle          VARCHAR(50)                                             NOT NULL,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwstage.offices;

CREATE TABLE koteswara_dwstage.offices
(
   officeCode        VARCHAR(10)                                            NOT NULL,
   city              VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   phone             VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   addressLine1      VARCHAR(50)                                            NOT NULL,
   addressLine2      VARCHAR(50),
   state             VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci,
   country           VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   postalCode        VARCHAR(15)                                            NOT NULL,
   territory         VARCHAR(10) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwstage.orderdetails;

CREATE TABLE koteswara_dwstage.orderdetails
(
   orderNumber       INT             NOT NULL,
   productCode       VARCHAR(15)     NOT NULL,
   quantityOrdered   INT             NOT NULL,
   priceEach         DECIMAL(10,2)   NOT NULL,
   orderLineNumber   SMALLINT        NOT NULL,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwstage.orders;

CREATE TABLE koteswara_dwstage.orders
(
   orderNumber       INT                                                    NOT NULL,
   orderDate         DATE                                                   NOT NULL,
   requiredDate      DATE                                                   NOT NULL,
   shippedDate       DATE,
   status            VARCHAR(15) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   comments          TEXT CHARSET latin1 COLLATE latin1_swedish_ci,
   customerNumber    INT                                                    NOT NULL,
   cancelledDate     DATE,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwstage.payments;

CREATE TABLE koteswara_dwstage.payments
(
   customerNumber    INT             NOT NULL,
   checkNumber       VARCHAR(50)     NOT NULL,
   paymentDate       DATE            NOT NULL,
   amount            DECIMAL(10,2)   NOT NULL,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwstage.productlines;

CREATE TABLE koteswara_dwstage.productlines
(
   productLine       VARCHAR(50)     NOT NULL,
   textDescription   VARCHAR(4000),
   htmlDescription   MEDIUMTEXT,
   image             MEDIUMBLOB,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwstage.products;

CREATE TABLE koteswara_dwstage.products
(
   productCode         VARCHAR(15)     NOT NULL,
   productName         VARCHAR(70)     NOT NULL,
   productLine         VARCHAR(50)     NOT NULL,
   productScale        VARCHAR(10)     NOT NULL,
   productVendor       VARCHAR(50)     NOT NULL,
   productDescription  TEXT            NOT NULL,
   quantityInStock     SMALLINT        NOT NULL,
   buyPrice            DECIMAL(10,2)   NOT NULL,
   MSRP                DECIMAL(10,2)   NOT NULL,
   store_id            INT,
   create_timestamp    TIMESTAMP,
   update_timestamp    TIMESTAMP
)
ENGINE=InnoDB;

SCRIPT

mysql -u SaiKotesh -pChSa@0102 <<SCRIPT

DROP DATABASE IF EXISTS koteswara_dwprod;

CREATE DATABASE koteswara_dwprod;

USE koteswara_dwprod;

DROP TABLE IF EXISTS koteswara_dwprod.customer_history;

CREATE TABLE koteswara_dwprod.customer_history
(
   dw_customer_id         INT,
   creditLimit            DECIMAL(10,2),
   effective_from_date    DATE,
   effective_to_date      DATE,
   dw_active_record_ind   INT,
   dw_create_timestamp    TIMESTAMP,
   dw_update_timestamp    TIMESTAMP,
   create_etl_batch_no    INT,
   create_etl_batch_date  DATE,
   update_etl_batch_no    INT,
   update_etl_batch_date  DATE
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.customers;

CREATE TABLE koteswara_dwprod.customers
(
   dw_customer_id          INT                                                    NOT NULL AUTO_INCREMENT,
   src_customerNumber      INT                                                    NOT NULL,
   customerName            VARCHAR(50)                                            NOT NULL,
   contactLastName         VARCHAR(50)                                            NOT NULL,
   contactFirstName        VARCHAR(50)                                            NOT NULL,
   phone                   VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   addressLine1            VARCHAR(50)                                            NOT NULL,
   addressLine2            VARCHAR(50),
   city                    VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   state                   VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci,
   postalCode              VARCHAR(15),
   country                 VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   salesRepEmployeeNumber  INT,
   creditLimit             DECIMAL(10,2),
   src_create_timestamp    TIMESTAMP,
   src_update_timestamp    TIMESTAMP,
   dw_create_timestamp     TIMESTAMP,
   dw_update_timestamp     TIMESTAMP,
   etl_batch_no            INT,
   etl_batch_date          DATE,
   PRIMARY KEY (dw_customer_id)
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.daily_customer_summary;

CREATE TABLE koteswara_dwprod.daily_customer_summary
(
   summary_date            DATE,
   dw_customer_id          INT,
   order_count             INT,
   order_apd               INT,
   order_cost_amount       DECIMAL(10,2),
   cancelled_order_count   INT,
   cancelled_order_amount  DECIMAL(10,2),
   cancelled_order_apd     INT,
   shipped_order_count     INT,
   shipped_order_amount    DECIMAL(10,2),
   shipped_order_apd       INT,
   payment_apd             INT,
   payment_amount          DECIMAL(10,2),
   products_ordered_qty    INT,
   products_items_qty      INT,
   order_mrp_amount        DECIMAL(10,2),
   new_customer_apd        INT,
   new_customer_paid_apd   INT,
   dw_create_timestamp     TIMESTAMP,
   dw_update_timestamp     TIMESTAMP,
   etl_batch_no            INT,
   etl_batch_date          DATE
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.daily_product_summary;

CREATE TABLE koteswara_dwprod.daily_product_summary
(
   summary_date           DATE,
   dw_product_id          INT,
   order_apd              INT,
   product_cost_amount    DECIMAL(10,2),
   product_mrp_amount     DECIMAL(10,2),
   cancelled_product_qty  INT,
   cancelled_cost_amount  DECIMAL(10,2),
   cancelled_mrp_amount   DECIMAL(10,2),
   cancelled_order_apd    INT,
   dw_create_timestamp    TIMESTAMP,
   dw_update_timestamp    TIMESTAMP,
   etl_batch_no           INT,
   etl_batch_date         DATE
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.employees;

CREATE TABLE koteswara_dwprod.employees
(
   dw_employee_id            INT                                                     NOT NULL AUTO_INCREMENT,
   employeeNumber            INT                                                     NOT NULL,
   lastName                  VARCHAR(50)                                             NOT NULL,
   firstName                 VARCHAR(50)                                             NOT NULL,
   extension                 VARCHAR(10) CHARSET latin1 COLLATE latin1_swedish_ci    NOT NULL,
   email                     VARCHAR(100) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   officeCode                VARCHAR(10)                                             NOT NULL,
   reportsTo                 INT,
   jobTitle                  VARCHAR(50)                                             NOT NULL,
   dw_office_id              INT,
   dw_reporting_employee_id  INT,
   src_create_timestamp      TIMESTAMP,
   src_update_timestamp      TIMESTAMP,
   dw_create_timestamp       TIMESTAMP,
   dw_update_timestamp       TIMESTAMP,
   etl_batch_no              INT,
   etl_batch_date            DATE,
   PRIMARY KEY (dw_employee_id)
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.monthly_customer_summary;

CREATE TABLE koteswara_dwprod.monthly_customer_summary
(
   start_of_the_month_date  DATE,
   dw_customer_id           INT,
   order_count              INT,
   order_apd                INT,
   order_apm                INT,
   order_cost_amount        DECIMAL(10,2),
   cancelled_order_count    INT,
   cancelled_order_amount   DECIMAL(10,2),
   cancelled_order_apd      INT,
   cancelled_order_apm      INT,
   shipped_order_count      INT,
   shipped_order_amount     DECIMAL(10,2),
   shipped_order_apd        INT,
   shipped_order_apm        INT,
   payment_apd              INT,
   payment_apm              INT,
   payment_amount           DECIMAL(10,2),
   products_ordered_qty     INT,
   products_items_qty       INT,
   order_mrp_amount         DECIMAL(10,2),
   new_customer_apd         INT,
   new_customer_apm         INT,
   new_customer_paid_apd    INT,
   new_customer_paid_apm    INT,
   dw_create_timestamp      TIMESTAMP,
   dw_update_timestamp      TIMESTAMP,
   etl_batch_no             INT,
   etl_batch_date           DATE
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.monthly_product_summary;

CREATE TABLE koteswara_dwprod.monthly_product_summary
(
   start_of_the_month_date  DATE,
   dw_product_id            INT,
   order_apd                INT,
   order_apm                INT,
   product_cost_amount      DECIMAL(10,2),
   product_mrp_amount       DECIMAL(10,2),
   cancelled_product_qty    INT,
   cancelled_cost_amount    DECIMAL(10,2),
   cancelled_mrp_amount     DECIMAL(10,2),
   cancelled_order_apd      INT,
   cancelled_order_apm      INT,
   dw_create_timestamp      TIMESTAMP,
   dw_update_timestamp      TIMESTAMP,
   etl_batch_no             INT,
   etl_batch_date           DATE
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.offices;

CREATE TABLE koteswara_dwprod.offices
(
   dw_office_id          INT                                                    NOT NULL AUTO_INCREMENT,
   officeCode            VARCHAR(10)                                            NOT NULL,
   city                  VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   phone                 VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   addressLine1          VARCHAR(50)                                            NOT NULL,
   addressLine2          VARCHAR(50),
   state                 VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci,
   country               VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   postalCode            VARCHAR(15)                                            NOT NULL,
   territory             VARCHAR(10) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   src_create_timestamp  TIMESTAMP,
   src_update_timestamp  TIMESTAMP,
   dw_create_timestamp   TIMESTAMP,
   dw_update_timestamp   TIMESTAMP,
   etl_batch_no          INT,
   etl_batch_date        DATE,
   PRIMARY KEY (dw_office_id)
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.orderdetails;

CREATE TABLE koteswara_dwprod.orderdetails
(
   dw_orderdetail_id     INT             NOT NULL AUTO_INCREMENT,
   dw_order_id           INT,
   dw_product_id         INT,
   src_orderNumber       INT             NOT NULL,
   src_productCode       VARCHAR(15)     NOT NULL,
   quantityOrdered       INT             NOT NULL,
   priceEach             DECIMAL(10,2)   NOT NULL,
   orderLineNumber       SMALLINT        NOT NULL,
   src_create_timestamp  TIMESTAMP,
   src_update_timestamp  TIMESTAMP,
   dw_create_timestamp   TIMESTAMP,
   dw_update_timestamp   TIMESTAMP,
   etl_batch_no          INT,
   etl_batch_date        DATE,
   PRIMARY KEY (dw_orderdetail_id)
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.orders;

CREATE TABLE koteswara_dwprod.orders
(
   dw_order_id           INT                                                    NOT NULL AUTO_INCREMENT,
   dw_customer_id        INT,
   src_orderNumber       INT                                                    NOT NULL,
   orderDate             DATE                                                   NOT NULL,
   requiredDate          DATE                                                   NOT NULL,
   shippedDate           DATE,
   status                VARCHAR(15) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   comments              TEXT CHARSET latin1 COLLATE latin1_swedish_ci,
   src_customerNumber    INT                                                    NOT NULL,
   src_create_timestamp  TIMESTAMP,
   src_update_timestamp  TIMESTAMP,
   dw_create_timestamp   TIMESTAMP,
   dw_update_timestamp   TIMESTAMP,
   etl_batch_no          INT,
   etl_batch_date        DATE,
   cancelledDate         DATE,
   PRIMARY KEY (dw_order_id)
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.payments;

CREATE TABLE koteswara_dwprod.payments
(
   dw_payment_id         INT             NOT NULL AUTO_INCREMENT,
   dw_customer_id        INT,
   src_customerNumber    INT             NOT NULL,
   checkNumber           VARCHAR(50)     NOT NULL,
   paymentDate           DATE            NOT NULL,
   amount                DECIMAL(10,2)   NOT NULL,
   src_create_timestamp  TIMESTAMP,
   src_update_timestamp  TIMESTAMP,
   dw_create_timestamp   TIMESTAMP,
   dw_update_timestamp   TIMESTAMP,
   etl_batch_no          INT,
   etl_batch_date        DATE,
   PRIMARY KEY (dw_payment_id)
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.product_history;

CREATE TABLE koteswara_dwprod.product_history
(
   dw_product_id          INT,
   MSRP                   DECIMAL(10,2)   NOT NULL,
   effective_from_date    DATE,
   effective_to_date      DATE,
   dw_active_record_ind   INT,
   dw_create_timestamp    TIMESTAMP,
   dw_update_timestamp    TIMESTAMP,
   create_etl_batch_no    INT,
   create_etl_batch_date  DATE,
   update_etl_batch_no    INT,
   update_etl_batch_date  DATE
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.productlines;

CREATE TABLE koteswara_dwprod.productlines
(
   dw_product_line_id    INT             NOT NULL AUTO_INCREMENT,
   productLine           VARCHAR(50)     NOT NULL,
   textDescription       VARCHAR(4000),
   htmlDescription       MEDIUMTEXT,
   image                 MEDIUMBLOB,
   src_create_timestamp  TIMESTAMP,
   src_update_timestamp  TIMESTAMP,
   dw_create_timestamp   TIMESTAMP,
   dw_update_timestamp   TIMESTAMP,
   etl_batch_no          INT,
   etl_batch_date        DATE,
   PRIMARY KEY (dw_product_line_id)
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara_dwprod.products;

CREATE TABLE koteswara_dwprod.products
(
   dw_product_id         INT             NOT NULL AUTO_INCREMENT,
   src_productCode       VARCHAR(15)     NOT NULL,
   productName           VARCHAR(70)     NOT NULL,
   productLine           VARCHAR(50)     NOT NULL,
   productScale          VARCHAR(10)     NOT NULL,
   productVendor         VARCHAR(50)     NOT NULL,
   productDescription    TEXT            NOT NULL,
   quantityInStock       SMALLINT        NOT NULL,
   buyPrice              DECIMAL(10,2)   NOT NULL,
   MSRP                  DECIMAL(10,2)   NOT NULL,
   dw_product_line_id    INT,
   src_create_timestamp  TIMESTAMP,
   src_update_timestamp  TIMESTAMP,
   dw_create_timestamp   TIMESTAMP,
   dw_update_timestamp   TIMESTAMP,
   etl_batch_no          INT,
   etl_batch_date        DATE,
   PRIMARY KEY (dw_product_id)
)
ENGINE=InnoDB;

SCRIPT

~/bash_scripts/data_generation.sh
