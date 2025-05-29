-- Collections & Cursors
-- VARRAY Example ( Fixed size list of allowances for an employee)
 DECLARE
   TYPE AllowanceArray IS VARRAY(3) OF NUMBER(10,2);
   emp_allowances AllowanceArray := AllowanceArray(1500, 1200, 800);
   total NUMBER := 0;
BEGIN
   FOR i IN 1..emp_allowances.COUNT LOOP
      total := total + emp_allowances(i);
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Total Allowance: ' || total);
END;
/


-- Nested Table Example
DECLARE
    TYPE BonusTable IS TABLE OF NUMBER;
    emp_bonus BonusTable := BonusTable(1000 , 1500 , 2000 , 2500);
    total_bonus NUMBER := 0;
BEGIN 
    FOR i IN 1..emp_bonus.COUNT LOOP
        total_bonus := total_bonus + emp_bonus(i);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('total Bonus: ' || total_bonus);
END;
/


-- Associative Array Example
DECLARE
    TYPE SalaryMap IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    emp_salaries SalaryMap;
BEGIN
    emp_salaries(101) := 48000;
    emp_salaries(102) := 51000;
    emp_salaries(103) := 47000;

    FOR i IN 101..103 LOOP
        DBMS_OUTPUT.PUT_LINE('EMP_ID: ' || i || ' Salary: ' || emp_salaries(i));
    END LOOP;
END;
/

-- CURSORS
-- Implicit Cursor
DECLARE
salary PAYROLL.NET_SALARY%TYPE;
BEGIN
    SELECT NET_SALARY INTO salary
    FROM PAYROLL
    WHERE EMP_ID = 201;
    DBMS_OUTPUT.PUT_LINE('Salary: ' || salary);
END;
/


-- Explicit Cursor (Mannual control over query row by row)
DECLARE 
    CURSOR emp_cur IS
        SELECT EMP_ID , FIRST_NAME , LAST_NAME FROM EMPLOYEES;
        id  EMPLOYEES.EMP_ID%TYPE;
        fn EMPLOYEES.FIRST_NAME%TYPE;
        ln EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO id , fn , ln;
        EXIT WHEN emp_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || id || ' NAME: ' || fn || ' ' || ln);
    END LOOP;
    CLOSE emp_cur;
END;
/


-- PARAMETERIZED CURSOR
DECLARE 
CURSOR sal_cur(min_sal NUMBER) IS
SELECT EMP_ID , NET_SALARY FROM PAYROLL
WHERE NET_SALARY > min_sal;
id PAYROLL.EMP_ID%TYPE;
sal PAYROLL.NET_SALARY%TYPE;
BEGIN
    OPEN sal_cur(50000);
    LOOP
        FETCH sal_cur INTO id , sal;
        EXIT WHEN sal_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || id || ' SALARY: ' || sal);
    END LOOP;
    CLOSE sal_cur;
END;
/