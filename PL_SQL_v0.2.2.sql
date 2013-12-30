-- DB PROJECT CONOR RYAN - 94412413 - APRIL 2013
-- STOCK EXCHANGE DATABASE SYSTEM
--
-- Part 1 - Four Inner Join Queries
--
-- Q 1.1
-- Note: In this query we wish to returns details of the status of all orders the clients have placed in the system.
--
SELECT c.fname, c.lname, c.client_id, o.order_id, o.share_id, o.status 
FROM Clients c 
INNER JOIN Orders o 
ON c.client_id=o.client_id; 
--
-- Q 1.2
-- Note: In this query we wish to return details of the business transactions(shares actually sold and bought) each Broker has done. This information is important for evaluating how Brokers are performing from a sales point of view.
--
SELECT b.fname AS "FIRST NAME", b.lname AS "SURNAME", b.broker_id AS "BROKER ID", t.tr_id AS "TRANSACTION #", t.share_id AS "TCKR", t.total_sale AS "TOTAL SALE" 
FROM Brokers b 
INNER JOIN Transactions t 
ON b.broker_id=t.broker_id; 
--
-- Q 1.3
-- Note: In this query the Exchange wishes to know the auditors of all companies in the exchange
SELECT a.name AS AUDITOR_NAME, a.address AS AUDITOR_ADDRESS, c.name AS COMPANY_NAME, c.address AS COMPANY_ADDRESS 
FROM Auditors a 
INNER JOIN Companies c 
ON a.auditor_id=c.auditor_id; 
--
--Q 1.4
-- Note: In this query we return the balance that clients have in their trading accounts
--
SELECT c.fname, c.lname, c.client_id, t.balance 
FROM Clients c 
INNER JOIN Trading_Accounts t 
ON c.client_id=t.client_id; 
--
--
-- Part 2 - Six OUTER JOIN queries 
--
-- Q 2.1
-- Note: In this query we wish to returns details of all the clients in the system with their placed orders as well as those who have not yet placed orders.
--
SELECT c.fname, c.lname, c.client_id, o.order_id, o.share_id, o.status 
FROM Clients c 
LEFT OUTER JOIN Orders o 
ON c.client_id=o.client_id
ORDER BY c.client_id; 
--
-- Q 2.2
-- Note: In this query we wish to return details of all the clients in the system who have trading accounts set up and those who have not set up accounts yet.
--
SELECT c.fname, c.lname, c.client_id, t.account_id, t.balance 
FROM Clients c 
LEFT OUTER JOIN Trading_Accounts t 
ON c.client_id=t.client_id; 
--
-- Q 2.3
-- Note: In this query we wish to return details of completed transactions against All Orders in the system to determine which orders are completed and which are outstanding
--
SELECT t.tr_id, t.order_type, t.date_time, t.units, t.share_price, o.order_id, o.date_time, o.broker_id 
FROM Transactions t 
RIGHT OUTER JOIN Orders o 
ON t.order_id=o.order_id;
--
-- Q 2.4
-- Note: In this query we wish to return details of the shareholdings for each ticker. Some tickers, when new, may not have shareholdings yet so a RIGHT OUTER JOIN is appropriate.
--
SELECT sh.client_id, sh.units, s.share_id AS TICKER 
FROM Shareholdings sh 
RIGHT OUTER JOIN Shares s 
ON sh.share_id=s.share_id; 
--
-- Q 2.5
-- Note: In this query we wish to return details of the shares in issue against the trading orders to date.
--
SELECT * 
FROM Shares s 
FULL OUTER JOIN Orders o  
ON s.share_id=o.share_id;
--
-- Q 2.6
-- Note: In this query we wish to return details of orders and transactions in terms of shares, prices offers and units offered and transacted
--
SELECT o.order_id, o.order_type, o.client_id, o.units, o.share_price_limit AS Price_Limit, o.transaction_amount AS Amount, o.status, t.tr_id, t.share_price, t.total_sale 
FROM Orders o 
FULL OUTER JOIN Transactions t 
ON o.order_id=t.order_id; 
--
--
-- Part 3 - 1 CUBE Query
--
-- Q 3.1
-- Note: In this query we wish to return details of sales to Clients
--
SELECT t.tr_id, t.share_id, t.client_id,
SUM(total_sale) AS TOTAL_SALES
FROM Transactions t JOIN Brokers b ON t.broker_id=b.broker_id
GROUP BY CUBE(tr_id, share_id, client_id);
--
--
-- Part 4 - Five Subqueries
--
-- Q 4.1
-- Note: Subquery 1 Returns the Client(s) with the Largest Sale
--
SELECT Clients.client_id, fname, lname, tr_id, broker_id, share_id, total_sale
FROM Clients
JOIN Transactions ON Clients.client_id=Transactions.client_id
WHERE total_sale = (SELECT MAX(total_sale) FROM Transactions);
--
-- Q 4.2
-- Note: Subquery 2 Returns the Brokers(s) with the Largest Sale
--
SELECT Brokers.broker_id, fname, lname, tr_id, share_id, total_sale
FROM Brokers
JOIN Transactions ON Brokers.broker_id=Transactions.broker_id
WHERE total_sale = (SELECT MAX(total_sale) FROM Transactions);
--
-- Q 4.3
-- Note: Subquery 3 Returns the Average Sale
SELECT share_id, total_sale AS Average_Sale
FROM Transactions
WHERE total_sale = (SELECT AVG(total_sale) FROM Transactions WHERE order_type = 'SELL-FULL' OR order_type = 'SELL-PART');
--
-- Q 4.4
-- Note: Subquery 4 Returns the Highest Commission paid to a broker
SELECT Brokers.broker_id, fname, lname, commission
FROM Transactions
JOIN Brokers ON Transactions.broker_id=Brokers.broker_id
WHERE commission = (SELECT MAX(commission) FROM Transactions);
--
-- Q 4.5
-- Note: Subquery 4 Returns the Average Commission paid to a broker
SELECT Brokers.broker_id, fname, lname, commission
FROM Transactions
JOIN Brokers ON Transactions.broker_id=Brokers.broker_id
WHERE commission = (SELECT AVG(commission) FROM Transactions);
--
--
-- Part 5 - Five Procedures
--
-- Q 5.1
-- Note: Procedure 1 Deposit
CREATE OR REPLACE PROCEDURE deposit_proc(account IN NUMBER, amount IN NUMBER)
IS
  curr   NUMBER;
  final  NUMBER;
  negative_funds EXCEPTION;
BEGIN
  -- Get the account balance
  SELECT balance INTO curr
  FROM   Trading_Accounts
  WHERE  client_id = account;
  -- Check that a negative amount is not being entered
  IF (amount < 0) THEN
	 RAISE negative_funds;
  ELSE
     -- Add the deposit to the account and update db 
	 final := curr + amount;
	 UPDATE Trading_Accounts
	 SET    balance = final
	 WHERE  client_id = account;
	 COMMIT;
	 dbms_output.put_line('Final balance: ' || final);
  END IF;
  -- Angdle the exception above
  EXCEPTION
	WHEN negative_funds THEN
	dbms_output.put_line('Error! Positive Funds Only. Transaction Cancelled');
END deposit_proc;
/
-- Example Execution
EXECUTE deposit_proc(1,10);
--
--
-- Q 5.2
-- Note: Procedure 2 Withdrawal
CREATE OR REPLACE PROCEDURE withdraw_proc(account IN NUMBER, amount IN NUMBER)
IS
  curr   NUMBER;
  final  NUMBER;
  insufficient_funds EXCEPTION;
BEGIN
  -- Same as above only we are withdrawing funds 
  SELECT balance INTO curr
  FROM   Trading_Accounts
  WHERE  client_id = account;
  IF (amount > curr) THEN
	 RAISE insufficient_funds;
  ELSE
	 final := curr - amount;
	 UPDATE Trading_Accounts
	 SET    balance = final
	 WHERE  client_id = account AND balance > amount;
	 COMMIT;
	 dbms_output.put_line('Final balance: ' || final);
  END IF;
  EXCEPTION
    WHEN insufficient_funds THEN
    dbms_output.put_line('Transaction Cancelled! Insufficient Funds.');
END withdraw_proc;
/
-- Example Execution
EXECUTE withdraw_proc(1,10);
--
--
-- Q 5.3
-- Note: Procedure 3 cash transfer from one account to another
CREATE OR REPLACE PROCEDURE transfer_proc(account_from IN NUMBER, account_to IN NUMBER, amount IN NUMBER)
IS
  curr   NUMBER;
  final  NUMBER;
  insufficient_funds EXCEPTION;
BEGIN
  SELECT balance INTO curr
  FROM   Trading_Accounts
  WHERE  client_id = account_from;
  IF (amount > curr) THEN
	 RAISE insufficient_funds;
  ELSE
     -- STEP 1 - WITHDRAW
	 final := curr - amount;
	 UPDATE Trading_Accounts
	 SET    balance = final
	 WHERE  client_id = account_from AND balance > amount;
	 -- STEP 2 - DEPOSIT
	 SELECT balance INTO curr
     FROM   Trading_Accounts
     WHERE  client_id = account_to;
	 final := curr + amount;
	 UPDATE Trading_Accounts
	 SET    balance = final
	 WHERE  client_id = account_to;
	 -- COMMIT
	 COMMIT;
	 dbms_output.put_line('Completed Transfer: ' || amount);
  END IF;
  EXCEPTION
    WHEN insufficient_funds THEN
    dbms_output.put_line('Transaction Cancelled! Insufficient Funds.');
END transfer_proc;
/
-- Example Execution
EXECUTE transfer_proc(2,1,100);
--
--
-- Q 5.4
-- Note: Procedure 5.4 Share BUY-Full Orders sends a buy order to the system
CREATE OR REPLACE PROCEDURE buy_full_order_proc(client_id_in IN NUMBER, broker_id_in IN NUMBER, units_in IN NUMBER, share_price_limit_in IN NUMBER, transaction_amount_in IN NUMBER, share_id_in NVARCHAR2, expiry_in TIMESTAMP)
IS
  order_type_var  	NVARCHAR2(10);
  date_time_var		TIMESTAMP;
  status_var		NVARCHAR2(10);
  company_suspended EXCEPTION;
BEGIN
  SELECT status INTO status_var FROM Shares WHERE share_id = share_id_in;
  IF status_var = 'Suspended' THEN
    RAISE company_suspended;
  ELSE	
  order_type_var:=	'BUY-FULL';
  date_time_var:=	CURRENT_TIMESTAMP;
  status_var:=		'Open';
  INSERT INTO ORDERS (order_type, client_id, broker_id, units, share_price_limit, transaction_amount, status, share_id, date_time, expiry) VALUES(order_type_var, client_id_in, broker_id_in, units_in, share_price_limit_in, transaction_amount_in, status_var, share_id_in, date_time_var, expiry_in);
	 dbms_output.put_line('BUY ORDER COMPLETE!');
  COMMIT;
  END IF; 
  EXCEPTION
    WHEN company_suspended THEN
    dbms_output.put_line('Order Cancelled! Company Suspended from Exchange.');
END buy_full_order_proc;
/
-- Example Execution
EXECUTE buy_full_order_proc(1,1,100,20,NULL,'ARYA', '22-MAY-2013 10:45:00');
--
--
-- Q 5.5
-- Note: Procedure 5.5 Share SELL Full Orders sends a sell order to the system
CREATE OR REPLACE PROCEDURE sell_full_order_proc(client_id_in IN NUMBER, broker_id_in IN NUMBER, units_in IN NUMBER, share_price_limit_in IN NUMBER, transaction_amount_in IN NUMBER, share_id_in NVARCHAR2, expiry_in TIMESTAMP)
IS
  order_type_var  	NVARCHAR2(10);
  date_time_var		TIMESTAMP;
  status_var		NVARCHAR2(10);
  company_suspended EXCEPTION;
BEGIN
  SELECT status INTO status_var FROM Shares WHERE share_id = share_id_in;
  IF status_var = 'Suspended' THEN
    RAISE company_suspended;
  ELSE	
  order_type_var:=	'SELL-FULL';
  date_time_var:=	CURRENT_TIMESTAMP;
  status_var:=		'Open';
  INSERT INTO ORDERS (order_type, client_id, broker_id, units, share_price_limit, transaction_amount, status, share_id, date_time, expiry) VALUES(order_type_var, client_id_in, broker_id_in, units_in, share_price_limit_in, transaction_amount_in, status_var, share_id_in, date_time_var, expiry_in);
	 dbms_output.put_line('SELL ORDER COMPLETE!');
  COMMIT;
  END IF; 
  EXCEPTION
    WHEN company_suspended THEN
    dbms_output.put_line('Order Cancelled! Company Suspended from Exchange.');	 
END sell_full_order_proc;
/
-- Example Execution
EXECUTE sell_full_order_proc(1,1,1000,18,NULL,'ARYA', '22-MAY-2013 10:45:00');

--
--
--
-- Q 5.6
-- Note: Procedure 5.6 - Procedure Using Cursor. Procedure to check the health of client accounts. 
-- Low balances and high balances must be reviewed by Portfolio Services.
CREATE OR REPLACE PROCEDURE Q8_1_proc
IS
BEGIN
  DECLARE
	CURSOR cur_client_balance IS
	SELECT client_id, balance FROM Trading_Accounts;
	client_row cur_client_balance%ROWTYPE; 
	alert_balance_low NVARCHAR2(200);
	alert_balance_high EXCEPTION;
  BEGIN
	OPEN cur_client_balance;
	FETCH cur_client_balance INTO client_row; 
	WHILE cur_client_balance%FOUND LOOP
	  IF client_row.balance < 10 THEN
		alert_balance_low := ('Client #: ' || client_row.client_id || ' Balance: ' || client_row.balance || ' is very low!');
		dbms_output.put_line('Error! Low Balance');
		RAISE_APPLICATION_ERROR(-20000,alert_balance_low);	
	  ELSIF client_row.balance > 1000000000 THEN
		RAISE alert_balance_high;		
	  END IF;	
	  FETCH cur_client_balance INTO client_row; 
	END LOOP;
	CLOSE cur_client_balance;
	COMMIT;
	EXCEPTION 
	  WHEN alert_balance_high THEN
	  dbms_output.put_line('Client #: ' || client_row.client_id || ' Balance: ' || client_row.balance || ' Above 1,000,000,000!');
	  RAISE;
  END;

  EXCEPTION
	WHEN OTHERS THEN
	  dbms_output.put_line('Please refer client to Account Review Services!');
END Q8_1_proc;
/
--
EXECUTE Q8_1_proc();
--
-- Part 6 - 1 Function
--
-- Q 6.1
-- Note: Function 1 - Calculate and return Market Capitalisation of Company (Currency value of shares in issue multiplied by current price per share)
CREATE OR REPLACE FUNCTION Q6_1_Func (share_id_in IN NVARCHAR2)
  RETURN NUMBER
IS
  -- The variables we shall use to make our calculations
  cur_price NUMBER;
  shares NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Ticker: ' || share_id_in);
  -- Get Shares in Issue
  SELECT share_issue INTO shares
  FROM   Shares
  WHERE  share_id = share_id_in; 
  -- Get Share Price
  SELECT price INTO cur_price
  FROM   Shares
  WHERE  share_id = share_id_in;
  -- Calculate MARKET CAPITALISATION
  RETURN shares * cur_price;
END Q6_1_Func;
/
-- Call Function 6.1
--
SELECT Q6_1_Func('ARYA') AS "MARKET CAPITALISATION" FROM DUAL;
--
--
-- Q 7.1
-- Note: Function 7.1 - Checks when a Client's cash balance is over 1,000,000 currency units. This client requires specialised portfolio management of the cash
CREATE OR REPLACE TRIGGER Q7_1_trigger
  AFTER INSERT OR UPDATE ON Trading_Accounts
  FOR EACH ROW
BEGIN
  IF (:NEW.balance>1000000) THEN
    dbms_output.put_line('Attention!'|| ' Client: ' ||:NEW.account_id ||' High Net Worth Client. Balance: '||:NEW.balance);
  END IF;
END Q7_1_trigger;
/
--
--
-- Q 7.2
-- Note: Function 7.2 - Checks when a Client's cash balance is below 100 currency units. This client has low funds.
CREATE OR REPLACE TRIGGER Q7_2_trigger
  BEFORE INSERT OR UPDATE ON Trading_Accounts
  FOR EACH ROW
BEGIN
  IF (:NEW.balance<100) THEN
    dbms_output.put_line('Attention!'|| ' Client: ' ||:NEW.account_id ||' has low funds. Balance: '||:NEW.balance);
  END IF;
END Q7_2_trigger;
/
--
--
-- Q 7.3
-- Note: Function 7.3 - Checks when a Client's cash balance is below 0 currency units. This client has a debt position. Note: Only certain accounts are permitted to be overdrawn!
CREATE OR REPLACE TRIGGER Q7_3_trigger
  BEFORE INSERT OR UPDATE ON Trading_Accounts
  FOR EACH ROW
BEGIN
  IF (:NEW.balance<0) THEN
    dbms_output.put_line('Attention!'|| ' Client: ' ||:NEW.account_id ||' has a debt position. Balance: '||:NEW.balance);
  END IF;
END Q7_3_trigger;
/
--

-- EXTRA FEATURES
--
--
-- E 1.0
-- This feature is to give USER PRIVILEGES to two Groups. 
-- The first are Settlements officers who can only view cash balances, make deposits and withdrawls and transfers between client accounts.
-- The second are Brokers who can create client accounts, buy and sell shares, but may not delete tables from the system.
--
--
-- E 2.0
--
-- We wish to add orders by auto increment primary key using a sequence
-- CREATE ORDERS SEQUENCE
CREATE SEQUENCE order_seq
  MINVALUE 1
  MAXVALUE 100000000 
  START WITH 4 
  INCREMENT BY 1;
-- IMPLEMENT ORDERS TRIGGER
CREATE OR REPLACE TRIGGER order_trigger
  BEFORE INSERT ON Orders
  FOR EACH ROW
BEGIN
  SELECT order_seq.NEXTVAL INTO :NEW.ORDER_ID FROM DUAL;
END order_trigger;
/ 
--
--
-- E 2.1
--
-- We wish to add transactions by auto increment primary key using a sequence
-- CREATE ORDERS SEQUENCE
CREATE SEQUENCE transactions_seq
  MINVALUE 1
  MAXVALUE 100000000 
  START WITH 3 
  INCREMENT BY 1;
-- IMPLEMENT ORDERS TRIGGER
CREATE OR REPLACE TRIGGER transactions_trigger
  BEFORE INSERT ON Transactions
  FOR EACH ROW
BEGIN
  SELECT transactions_seq.NEXTVAL INTO :NEW.TR_ID FROM DUAL;
END order_trigger;
/ 
--
--
--
-- E 4
-- Note: create a view for full-sell orders in the system - a commonly accessed dataset
COLUMN date_time FORMAT A25 WORD WRAPPED
COLUMN expiry FORMAT A25 WORD WRAPPED
CREATE OR REPLACE VIEW sell_orders_view AS
  SELECT *
  FROM orders
  WHERE order_type = 'SELL-FULL'
  AND status = 'Open'
  ORDER BY date_time;
-- Use view
SELECT * FROM sell_orders_view;
--
--
-- E 5
-- Note: create a view for full buy orders in the system - a commonly accessed dataset
COLUMN date_time FORMAT A25 WORD WRAPPED
COLUMN expiry FORMAT A25 WORD WRAPPED
CREATE OR REPLACE VIEW buy_orders_view AS
  SELECT *
  FROM orders
  WHERE order_type = 'BUY-FULL'
  AND status = 'Open'
  ORDER BY date_time;
-- Use view
SELECT * FROM buy_orders_view;
--
--
--
-- E7
-- Note: function to return last sale price based on the average of buy and sell limits
CREATE OR REPLACE FUNCTION get_price_func (sell_order_id_in IN NUMBER, buy_order_id_in IN NUMBER)
  RETURN NUMBER
IS
  -- The variables we shall use to make our calculations
  sell_limit NUMBER;
  buy_limit NUMBER;
BEGIN
  -- Get sell limit
  SELECT share_price_limit INTO sell_limit
  FROM   Orders
  WHERE  order_id = sell_order_id_in; 
  -- Get buy limit
  SELECT share_price_limit INTO buy_limit
  FROM   Orders
  WHERE  order_id = buy_order_id_in; 
  -- Calculate Price
  RETURN (sell_limit + buy_limit)/2;
END get_price_Func;
/
-- Get price call
SELECT get_price_func(4,5) AS "PRICE" FROM DUAL;
--
--
--
-- E6
-- Note: Execute a FULL COMPLETE share transaction where buy and sell orders are equal
CREATE OR REPLACE PROCEDURE share_transfer_proc(share_id_in IN NVARCHAR2, account_from IN NUMBER, account_to IN NUMBER, amount IN NUMBER, sell_order_id_in IN NUMBER, buy_order_id_in IN NUMBER)
IS
  curr   REAL;
  final  REAL;
  insufficient_shares EXCEPTION;
  date_time_var	TIMESTAMP;
  sell_broker_id_var NUMBER;
  buy_broker_id_var NUMBER;
  price_var NUMBER;
  comm_var NUMBER;
  total_sale_var NUMBER;
BEGIN
  SELECT units INTO curr
  FROM   Shareholdings
  WHERE  client_id = account_from;
  IF (amount > curr) THEN
	 RAISE insufficient_shares;
  ELSE
     -- STEP 1 - DEALLOCATE SHARES
	 final := curr - amount;
	 UPDATE Shareholdings
	 SET    units = final
	 WHERE  client_id = account_from AND share_id = share_id_in AND units > amount;
	 UPDATE Orders SET status = 'Matched' WHERE order_id = sell_order_id_in;
	 date_time_var:=	CURRENT_TIMESTAMP;
	 price_var:= get_price_func(sell_order_id_in, buy_order_id_in);
	 comm_var:= (amount * price_var) * 0.02;
	 total_sale_var:= (amount * price_var) + comm_var;
	 SELECT broker_id INTO sell_broker_id_var FROM Orders WHERE  client_id = account_from;
	 INSERT INTO Transactions (order_type, order_id, share_id, date_time, broker_id, client_id, units, share_price, commission, total_sale) VALUES ('SELL-FULL', sell_order_id_in, share_id_in, date_time_var, sell_broker_id_var, account_from, amount, price_var, comm_var, total_sale_var);

	 -- STEP 2 - ALLOCATE SHARES
	 SELECT units INTO curr
     FROM   Shareholdings
     WHERE  client_id = account_to;
	 final := curr + amount;
	 UPDATE Shareholdings
	 SET    units = final
	 WHERE  client_id = account_to;
	 UPDATE Orders SET status = 'Matched' WHERE order_id = buy_order_id_in;
	 INSERT INTO Transactions (order_type, order_id, share_id, date_time, broker_id, client_id, units, share_price, commission, total_sale) VALUES ('BUY-FULL', buy_order_id_in, share_id_in, date_time_var, buy_broker_id_var, account_to, amount, price_var, comm_var, total_sale_var);
     -- STEP 3 - UPDATE LAST PRICE
	 UPDATE Shares SET price = price_var WHERE  share_id = share_id_in;
	 -- COMMIT
	 COMMIT;
	 dbms_output.put_line('Completed Share Transfer: ' || amount);
  END IF;
  EXCEPTION
    WHEN insufficient_shares THEN
    dbms_output.put_line('Transaction Cancelled! Insufficient Shares.');
END share_transfer_proc;
/
-- Example Execution
EXECUTE share_transfer_proc('ARYA',5,1,1000,5,4);
--
--
-- END OF ASSIGNMENT