#!/bin/bash

mysql -u SaiKotesh -pChSa@0102 <<SCRIPT

SET GLOBAL LOCAL_INFILE=1;

SCRIPT

mysql -u SaiKotesh -pChSa@0102 <<SCRIPT

DROP DATABASE IF EXISTS koteswara;

CREATE DATABASE koteswara;

USE koteswara;

DROP TABLE IF EXISTS koteswara.Customers;

CREATE TABLE koteswara.Customers
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


DROP TABLE IF EXISTS koteswara.Employees;

CREATE TABLE koteswara.Employees
(
   employeeNumber    INT                                                     NOT NULL,
   lastName          VARCHAR(50)                                             NOT NULL,
   firstName         VARCHAR(50)                                             NOT NULL,
   extension         VARCHAR(10) CHARSET latin1 COLLATE latin1_swedish_ci    NOT NULL,
   email             VARCHAR(100) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   reportsTo         INT,
   jobTitle          VARCHAR(50)                                             NOT NULL,
   officeCode        VARCHAR(10)                                             NOT NULL,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara.Offices;

CREATE TABLE koteswara.Offices
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


DROP TABLE IF EXISTS koteswara.OrderDetails;

CREATE TABLE koteswara.OrderDetails
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


DROP TABLE IF EXISTS koteswara.Orders;

CREATE TABLE koteswara.Orders
(
   orderNumber       INT                                                    NOT NULL,
   orderDate         DATE                                                   NOT NULL,
   requiredDate      DATE                                                   NOT NULL,
   shippedDate       DATE,
   status            VARCHAR(15) CHARSET latin1 COLLATE latin1_swedish_ci   NOT NULL,
   comments          TEXT CHARSET latin1 COLLATE latin1_swedish_ci,
   customerNumber    INT                                                    NOT NULL,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara.Payments;

CREATE TABLE koteswara.Payments
(
   checkNumber       VARCHAR(50)     NOT NULL,
   paymentDate       DATE            NOT NULL,
   amount            DECIMAL(10,2)   NOT NULL,
   customerNumber    INT             NOT NULL,
   store_id          INT,
   create_timestamp  TIMESTAMP,
   update_timestamp  TIMESTAMP
)
ENGINE=InnoDB;


DROP TABLE IF EXISTS koteswara.ProductLines;

CREATE TABLE koteswara.ProductLines
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


DROP TABLE IF EXISTS koteswara.Products;

CREATE TABLE koteswara.Products
(
   productCode         VARCHAR(15)     NOT NULL,
   productName         VARCHAR(70)     NOT NULL,
   productScale        VARCHAR(10)     NOT NULL,
   productVendor       VARCHAR(50)     NOT NULL,
   productDescription  TEXT            NOT NULL,
   quantityInStock     SMALLINT        NOT NULL,
   buyPrice            DECIMAL(10,2)   NOT NULL,
   MSRP                DECIMAL(10,2)   NOT NULL,
   productLine         VARCHAR(50)     NOT NULL,
   store_id            INT,
   create_timestamp    TIMESTAMP,
   update_timestamp    TIMESTAMP
)
ENGINE=InnoDB;

SCRIPT

