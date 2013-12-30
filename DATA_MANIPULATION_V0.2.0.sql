-- SE v0.1.1 - INSERTS

-- OK
INSERT INTO Auditors (auditor_id, name, address, telephone, email, website) VALUES (1, 'Corruptex', '123 Sly Street', '1234567', 'a@c.com', 'c.com');
INSERT INTO Auditors (auditor_id, name, address, telephone, email, website) VALUES (2, 'Offshore Auditors', '321 Tax Loophole Street', '2345678', 'a@o.com', 'o.com');
INSERT INTO Auditors (auditor_id, name, address, telephone, email, website) VALUES (3, 'Barking Mad', '345 Grifter Ave', '4325675', 'a@g.com', 'g.com');
INSERT INTO Auditors (auditor_id, name, address, telephone, email, website) VALUES (4, 'Shafter Inc', '234 Wall Street', '4325678', 'a@s.com', 'a@shafter.com');
-- OK
INSERT INTO Brokers (broker_id, fname, lname, address, phone, email, fax) VALUES (1, 'George', 'Soros', '123 Wall  Street, New York, USA', '001 123 4567', 'g@soros.com', NULL);
INSERT INTO Brokers (broker_id, fname, lname, address, phone, email, fax) VALUES (2, 'Linda', 'Bellafonte', '23 World Trade Centre, New York, USA', '001 442 9876', 'l@hsbc.com', NULL);
INSERT INTO Brokers (broker_id, fname, lname, address, phone, email, fax) VALUES (3, 'George', 'Martin', '55 Wall street, NY, USA', '001 234 6546', 'a@sb.com', NULL);
INSERT INTO Brokers (broker_id, fname, lname, address, phone, email, fax) VALUES (4, 'Mary', 'Sweetman', '66 World Trade Centre, NY', '001 324 5678', 'a@wtc.com', NULL);

-- OK
INSERT INTO Client_Type (client_type) VALUES ('Private');
INSERT INTO Client_Type (client_type) VALUES ('Broker');
INSERT INTO Client_Type (client_type) VALUES ('Corporate');
INSERT INTO Client_Type (client_type) VALUES ('Non_profit');
INSERT INTO Client_Type (client_type) VALUES ('Underwrite');

-- OK
INSERT INTO Clients (client_id, client_type, tax_number, fname, lname, address, phone, email, fax) VALUES (1, 'Private', '345675', 'Joe', 'Black', '123 Main Street, Dublin 1, Ireland', '00353198765432', 'j@black.com', NULL);
INSERT INTO Clients (client_id, client_type, tax_number, fname, lname, address, phone, email, fax) VALUES (2, 'Private', '534667', 'Jane', 'Dough', '321 Sweet Street, London Xw1 Yt3, UK', '00441234567', 'j@dough.com', NULL);
INSERT INTO Clients (client_id, client_type, tax_number, fname, lname, address, phone, email, fax) VALUES (3, 'Private', '1234567', 'George', 'Foreman', '4325 Happy Lane', '001 8765678', 'a@foreman.com', NULL);
INSERT INTO Clients (client_id, client_type, tax_number, fname, lname, address, phone, email, fax) VALUES (4, 'Private', '2346789', 'Mary', 'Contrarty', '234 Low Brow Ave', '00353 8734539', 'sales@anderson.com', NULL);
INSERT INTO Clients (client_id, client_type, tax_number, fname, lname, address, phone, email, fax) VALUES (5, 'Underwrite', '9346789', 'Anderson', 'Consulting', '234 IFSC 5ublin', '001 8734539', 'a@low.com', NULL);

-- OK
INSERT INTO Brokers_Clients (broker_id, client_id) VALUES (1, 1);
INSERT INTO Brokers_Clients (broker_id, client_id) VALUES (2, 2);
INSERT INTO Brokers_Clients (broker_id, client_id) VALUES (1, 3);
INSERT INTO Brokers_Clients (broker_id, client_id) VALUES (2, 4);
INSERT INTO Brokers_Clients (broker_id, client_id) VALUES (2, 5);

-- OK
INSERT INTO Companies (company_id, name, address, telephone, email, website, fax, auditor_id) VALUES (1, 'Aryana', '123 Main Street', '1234567', 'a@aryanna.com', 'aryanna.com', NULL, 1);
INSERT INTO Companies (company_id, name, address, telephone, email, website, fax, auditor_id) VALUES (2, 'Computexx', '321 Alpha Liner', '3214567', 'a@compp.com', 'comp.com', NULL, 1);
INSERT INTO Companies (company_id, name, address, telephone, email, website, fax, auditor_id) VALUES (3, 'Azuretek', '21 Silicon St', '4214567', 'a@aztk.com', 'azure.com', NULL, 1);
INSERT INTO Companies (company_id, name, address, telephone, email, website, fax, auditor_id) VALUES (4, 'Morphex', '31 gold Plaza', '3217567', 'a@morph.com', 'morph.com', NULL, 1);

-- OK
INSERT INTO Order_Status (order_status) VALUES ('Open');
INSERT INTO Order_Status (order_status) VALUES ('Matched');
INSERT INTO Order_Status (order_status) VALUES ('Rejected');
INSERT INTO Order_Status (order_status) VALUES ('Stopped');
INSERT INTO Order_Status (order_status) VALUES ('Expired');

-- OK
INSERT INTO Trading_Status (status) VALUES ('Trading');
INSERT INTO Trading_Status (status) VALUES ('Suspended');
INSERT INTO Trading_Status (status) VALUES ('Floatation');
INSERT INTO Trading_Status (status) VALUES ('Split');

-- OK
INSERT INTO Order_Type (order_type) VALUES ('SELL-FULL');
INSERT INTO Order_Type (order_type) VALUES ('BUY-FULL');
INSERT INTO Order_Type (order_type) VALUES ('BUY-PART');
INSERT INTO Order_Type (order_type) VALUES ('SELL-PART');

-- OK
INSERT INTO Trading_Accounts (account_id, client_id, balance) VALUES (1, 1, 100000);
INSERT INTO Trading_Accounts (account_id, client_id, balance) VALUES (2, 2, 200000);
INSERT INTO Trading_Accounts (account_id, client_id, balance) VALUES (3, 3, 150000);
INSERT INTO Trading_Accounts (account_id, client_id, balance) VALUES (4, 4, 200000);
INSERT INTO Trading_Accounts (account_id, client_id, balance) VALUES (5, 5, 150000);

-- OK
INSERT INTO Shares (share_id, company_id, share_issue, price, status) VALUES ('ARYA', 1, 1000000, 19.125, 'Trading');
INSERT INTO Shares (share_id, company_id, share_issue, price, status) VALUES ('CMPT', 2, 2000000, 40.125, 'Trading');
INSERT INTO Shares (share_id, company_id, share_issue, price, status) VALUES ('AZTK', 3, 5000000, 40.125, 'Trading');
INSERT INTO Shares (share_id, company_id, share_issue, price, status) VALUES ('MRPX', 4, 10000000, 19.125, 'Trading');

-- !!! ENTER WITH PROCEDURE !!!
INSERT INTO Orders (order_id, order_type, share_id, client_id, broker_id, date_time, units, share_price_limit, transaction_amount, expiry, status) VALUES (1, 'BUY-FULL', 'ARYA', 1, 1, '01-JAN-2003 10:00:00', 1000, 18, NULL, '01-JAN-2003 10:00:00', 'Matched');
INSERT INTO Orders (order_id, order_type, share_id, client_id, broker_id, date_time, units, share_price_limit, transaction_amount, expiry, status) VALUES (2, 'SELL-FULL', 'ARYA', 2, 2, '22-JAN-2013 09:45:00', 1000, 20, NULL, '22-FEB-2012 09:45:00', 'Matched');
INSERT INTO Orders (order_id, order_type, share_id, client_id, broker_id, date_time, units, share_price_limit, transaction_amount, expiry, status) VALUES (3, 'BUY-FULL', 'ARYA', 1, 1, '01-JAN-2003 10:00:00', 1000, 18, NULL, '01-JAN-2003 10:00:00', 'Matched');
INSERT INTO Orders (order_id, order_type, share_id, client_id, broker_id, date_time, units, share_price_limit, transaction_amount, expiry, status) VALUES (4, 'SELL-FULL', 'ARYA', 2, 2, '22-JAN-2013 09:45:00', 1000, 20, NULL, '22-FEB-2012 09:45:00', 'Matched');

-- !!! ENTER WITH PROCEDURE !!!
INSERT INTO Transactions (tr_id, order_type, order_id, share_id, date_time, broker_id, client_id, units, share_price, commission, total_sale) VALUES (1, 'BUY-FULL', 1, 'ARYA', '01-JAN-2003 10:00:00', 1, 1, 1000, 19, 190, 19190);
INSERT INTO Transactions (tr_id, order_type, order_id, share_id, date_time, broker_id, client_id, units, share_price, commission, total_sale) VALUES (2, 'SELL-FULL', 2, 'ARYA', '22-JAN-2013 10:45:00', 2, 2, 1000, 19, 190, 19190);
INSERT INTO Transactions (tr_id, order_type, order_id, share_id, date_time, broker_id, client_id, units, share_price, commission, total_sale) VALUES (3, 'SELL-FULL', 5, 'ARYA', '05-MAY-2013 16:45:00', 1, 5, 100, 20, 200, 2200);
INSERT INTO Transactions (tr_id, order_type, order_id, share_id, date_time, broker_id, client_id, units, share_price, commission, total_sale) VALUES (4, 'BUY-FULL', 4, 'ARYA', '05-MAY-2013 16:45:01', 1, 1, 100, 20, 200, 2200);

-- !!! ENTERED AUTOMATICALLY WITH PROCEDURE !!!
INSERT INTO Shareholdings (client_id, units, share_id) VALUES (1, 1000, 'ARYA');
INSERT INTO Shareholdings (client_id, units, share_id) VALUES (5, 1000000, 'ARYA');
INSERT INTO Shareholdings (client_id, units, share_id) VALUES (5, 2000000, 'CMPT');
INSERT INTO Shareholdings (client_id, units, share_id) VALUES (5, 5000000, 'AZTK');
INSERT INTO Shareholdings (client_id, units, share_id) VALUES (5, 10000000, 'MRPX');

-- END OF CODE