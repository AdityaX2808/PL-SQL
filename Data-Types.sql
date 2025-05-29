-- Data Types in PL/SQL
DECLARE
    num1 INTEGER := 100;
    num2 REAL := 12.34;
    num3 DOUBLE PRECISION := 123.456;

BEGIN
    DBMS_OUTPUT.PUT_LINE('num1 = ' || num1);
    DBMS_OUTPUT.PUT_LINE('num2 = ' || num2);
    DBMS_OUTPUT.PUT_LINE('num3 = ' || num3);

END;
/

--PL/SQL Subtype
DECLARE
    SUBTYPE name IS CHAR(20);
    SUBTYPE message IS VARCHAR2(100);
    salutation name;
    greetings message;
BEGIN
    salutation := 'Reader ';
    greetings := 'Welcome to the World of PL/SQL';
    DBMS_OUTPUT.PUT_LINE('Hello ' || salutation || greetings);
END;
/