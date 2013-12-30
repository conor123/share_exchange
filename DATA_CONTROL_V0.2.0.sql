-- DATA CONTROL
--
-- CREATE USER - BROKER
--
CREATE USER broker1 IDENTIFIED BY password;
--
-- GRANT PRIVILAGES TO BROKER
--
GRANT SELECT, INSERT, UPDATE ON orders TO broker1;
GRANT SELECT, INSERT, UPDATE ON clients TO broker1;
GRANT SELECT, INSERT, UPDATE ON transactions TO broker1;
--
-- CREATE USER - SETTLEMENTS OFFICER
--
CREATE USER settlements1 IDENTIFIED BY password;
GRANT SELECT, INSERT, UPDATE ON trading_accounts TO settlements1;
--
-- Note 1
-- Passwords are for project purposes only and complex passwords using cases, punctuation marks and long strings are recommended.
--
-- END