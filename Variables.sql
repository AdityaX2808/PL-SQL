-- PL/SQL data variable
DECLARE
    a INTEGER := 10;
    b INTEGER := 20;
    c INTEGER;
    f REAL;

BEGIN
    c := a + b;
    DBMS_OUTPUT.PUT_LINE('Value of c: ' || c);

    f := 70.0 / 3.0;
    DBMS_OUTPUT.PUT_LINE('Value of f: ' || f);
END;
/

-- Global and Local Variables
DECLARE
    num1 NUMBER := 95;
    num2 NUMBER := 85;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Outer Variable num1: ' || num1);
    DBMS_OUTPUT.PUT_LINE('Outer Variable num2 ' || num2);

    DECLARE
        num1 NUMBER := 195;
        num2 NUMBER := 185;
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Inner Variable num1: ' || num1);
        DBMS_OUTPUT.PUT_LINE('Inner Variable num2: ' || num2);
    END;
END;
/

