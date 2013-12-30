-- SE v0.1.1

--
DROP TABLE Auditors;

CREATE TABLE Auditors (
  auditor_id NUMBER NOT NULL, 
  name NVARCHAR2(50) NOT NULL, 
  address NVARCHAR2(100) NOT NULL, 
  telephone NVARCHAR2(30) NOT NULL, 
  email NVARCHAR2(30), 
  website NVARCHAR2(20), 
  CONSTRAINT AUDITORS_PK PRIMARY KEY (auditor_id)
);

--
DROP TABLE Brokers;

CREATE TABLE Brokers (
  broker_id NUMBER NOT NULL, 
  fname NVARCHAR2(20) NOT NULL, 
  lname NVARCHAR2(30) NOT NULL, 
  address NVARCHAR2(100) NOT NULL, 
  phone NVARCHAR2(20) NOT NULL, 
  email NVARCHAR2(50), 
  fax NVARCHAR2(30), 
  CONSTRAINT BROKERS_PK PRIMARY KEY (broker_id)
);

--
DROP TABLE Client_Type;

CREATE TABLE Client_Type (
  client_type NVARCHAR2(10) NOT NULL, 
  CONSTRAINT CLIENT_TYPE_PK PRIMARY KEY (client_type)
);


--
DROP TABLE Companies;

CREATE TABLE Companies (
  company_id NUMBER NOT NULL , 
  name NVARCHAR2(50) NOT NULL, 
  address NVARCHAR2(100) NOT NULL, 
  telephone NVARCHAR2(30) NOT NULL, 
  email NVARCHAR2(50) NOT NULL, 
  website NVARCHAR2(50), 
  fax NVARCHAR2(30), 
  auditor_id NUMBER, 
  CONSTRAINT COMPANY_PK PRIMARY KEY (company_id)
);


--
DROP TABLE Order_Status;

CREATE TABLE Order_Status (
  order_status NVARCHAR2(10) NOT NULL, 
  CONSTRAINT ORDER_STATUS_PK PRIMARY KEY (order_status)
);

--
DROP TABLE Order_Type;

CREATE TABLE Order_Type (
  order_type NVARCHAR2(10) NOT NULL, 
  CONSTRAINT ORDER_TYPE_PK PRIMARY KEY (order_type)
);

--
DROP TABLE Trading_Status;

CREATE TABLE Trading_Status (
  status NVARCHAR2(10) NOT NULL, 
  CONSTRAINT TRADING_STATUS_PK PRIMARY KEY (status)
);

--
DROP TABLE Clients;

CREATE TABLE Clients (
  client_id NUMBER NOT NULL , 
  client_type NVARCHAR2(50) NOT NULL, 
  tax_number NVARCHAR2(50) NOT NULL, 
  fname NVARCHAR2(20) NOT NULL, 
  lname NVARCHAR2(30) NOT NULL, 
  address NVARCHAR2(100) NOT NULL, 
  phone NVARCHAR2(50) NOT NULL, 
  email NVARCHAR2(50), 
  fax NVARCHAR2(30), 
  CONSTRAINT CLIENTS_PK PRIMARY KEY (client_id),
  CONSTRAINT CLIENT_TYPE_FK FOREIGN KEY (client_type) REFERENCES Client_Type(client_type) ON DELETE CASCADE,
  CONSTRAINT TAX_NO_UNIQUE UNIQUE (tax_number)
);

--
DROP TABLE Brokers_Clients;

CREATE TABLE Brokers_Clients (
  broker_id NUMBER NOT NULL, 
  client_id NUMBER NOT NULL, 
  CONSTRAINT BROKERS_CLIENTS_PK PRIMARY KEY (broker_id, client_id),
  CONSTRAINT BROKERS_FK FOREIGN KEY (broker_id) REFERENCES Brokers(broker_id) ON DELETE CASCADE,
  CONSTRAINT CLIENTS_FK FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);

--
DROP TABLE Shares;

CREATE TABLE Shares (
  share_id NVARCHAR2(4) NOT NULL, 
  company_id NUMBER NOT NULL, 
  share_issue NUMBER(20,3) NOT NULL, 
  price NUMBER(10,3) NOT NULL,
  status NVARCHAR2(10) NOT NULL, 
  CONSTRAINT SHARES_PK PRIMARY KEY (share_id),
  CONSTRAINT COMPANY_FK FOREIGN KEY (company_id) REFERENCES Companies(company_id) ON DELETE CASCADE,
  CONSTRAINT TRADING_STATUS_FK FOREIGN KEY (status) REFERENCES Trading_Status(status) ON DELETE CASCADE
);


--
DROP TABLE Trading_Accounts;

CREATE TABLE Trading_Accounts (
  account_id NUMBER NOT NULL, 
  client_id NUMBER NOT NULL, 
  balance NUMBER(19,2), 
  CONSTRAINT TRADING_ACC_PK PRIMARY KEY (account_id),
  CONSTRAINT CLIENT_FK FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);


--
DROP TABLE Shareholdings;

CREATE TABLE Shareholdings (
  client_id NUMBER NOT NULL, 
  share_id NVARCHAR2(4) NOT NULL, 
  units NUMBER(19,3) NOT NULL, 
  price NUMBER(10,3) NULL,
  CONSTRAINT SHAREHOLDINGS_PK PRIMARY KEY (client_id, share_id),
  CONSTRAINT SHARE_FK FOREIGN KEY (share_id) REFERENCES Shares(share_id) ON DELETE CASCADE,
  CONSTRAINT CLIENTS_SH_FK FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);


--
DROP TABLE Orders;

CREATE TABLE Orders (
  order_id NUMBER NOT NULL , 
  order_type NVARCHAR2(10) NOT NULL, 
  share_id NVARCHAR2(4) NOT NULL, 
  client_id NUMBER NOT NULL, 
  broker_id NUMBER NOT NULL, 
  date_time TIMESTAMP NOT NULL, 
  units NUMBER(19,4) NULL, 
  share_price_limit NUMBER(10,4) NULL, 
  transaction_amount NUMBER(19,4), 
  expiry TIMESTAMP NOT NULL, 
  status NVARCHAR2(10), 
  CONSTRAINT ORDERS_PK PRIMARY KEY (order_id),
  CONSTRAINT ORDER_TYPE_OR_FK FOREIGN KEY (order_type) REFERENCES Order_Type(order_type) ON DELETE CASCADE,
  CONSTRAINT SHARE_OR_FK FOREIGN KEY (share_id) REFERENCES Shares(share_id) ON DELETE CASCADE,
  CONSTRAINT CLIENT_OR_FK FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE,
  CONSTRAINT BROKER_OR_FK FOREIGN KEY (broker_id) REFERENCES Brokers(broker_id) ON DELETE CASCADE,
  CONSTRAINT ORDER_STATUS_OR_FK FOREIGN KEY (status) REFERENCES Order_Status(order_status) ON DELETE CASCADE
);


--
DROP TABLE Transactions;

CREATE TABLE Transactions (
  tr_id NUMBER NOT NULL, 
  order_type NVARCHAR2(10) NOT NULL,
  order_id NUMBER NOT NULL, 
  share_id NVARCHAR2(4) NOT NULL, 
  date_time TIMESTAMP NOT NULL, 
  broker_id NUMBER NOT NULL, 
  client_id NUMBER NOT NULL, 
  units NUMBER(19,3) NOT NULL, 
  share_price NUMBER(19,3) NOT NULL, 
  commission NUMBER(19,2) NOT NULL, 
  total_sale NUMBER(19,2) NOT NULL, 
  CONSTRAINT TRANSACTIONS_PK PRIMARY KEY (tr_id),
  CONSTRAINT ORDER_TYPE_TR_FK FOREIGN KEY (order_type) REFERENCES Order_type(order_type) ON DELETE CASCADE,
  CONSTRAINT SHARE_TR_FK FOREIGN KEY (share_id) REFERENCES Shares(share_id) ON DELETE CASCADE,
  CONSTRAINT CLIENT_TR_FK FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE,
  CONSTRAINT BROKER_TR_FK FOREIGN KEY (broker_id) REFERENCES Brokers(broker_id) ON DELETE CASCADE 
);
-- END OF CODE