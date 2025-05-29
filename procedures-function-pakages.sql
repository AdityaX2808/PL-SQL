-- STORED PROCEDURES , FUNCTIONS , PACKAGES
-- STORED PROCEDURES
CREATE OR REPLACE PROCEDURE update_salary(
    emp_id IN PAYROLL.EMP_ID%TYPE,
    new_salary IN PAYROLL.NET_SALARY%TYPE
) AS
BEGIN
    UPDATE PAYROLL
    SET NET_SALARY = new_salary
    WHERE EMP_ID = emp_id;

    DBMS_OUTPUT.PUT_LINE('Salary updated for EMP_ID ' || emp_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee not found!!');
END;
/
-- Call the procedure
BEGIN
    update_salary(201 , 60000);
END;
/


-- STORED FUNCTIONS
CREATE OR REPLACE FUNCTION get_full_name (
    emp_id IN EMPLOYEES.EMP_ID%TYPE
)
RETURN VARCHAR2 IS
    full_name VARCHAR2(100);
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME
    INTO full_name
    FROM EMPLOYEES
    WHERE EMP_ID = emp_id AND ROWNUM = 1;

    RETURN full_name;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown Employee';
END;
/

-- CALL IT
SET SERVEROUTPUT ON;
DECLARE
    name VARCHAR2(100);
BEGIN
    name := get_full_name(203);
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME : ' || name);
END;
/


-- PACKAGES
-- a. Package Specification
CREATE OR REPLACE PACKAGE payroll_pkg AS
    PROCEDURE raise_salary(emp_id IN NUMBER , amount IN NUMBER);
    FUNCTION get_salary(emp_id IN NUMBER) RETURN NUMBER;
END payroll_pkg;
/

-- b. Package Body
CREATE OR REPLACE PACKAGE BODY payroll_pkg AS

    PROCEDURE raise_salary(emp_id IN NUMBER , amount IN NUMBER) IS
    BEGIN
        UPDATE PAYROLL
        SET NET_SALARY = NET_SALARY + amount
        WHERE EMP_ID = emp_id;
    END raise_salary;

    FUNCTION get_salary(emp_id IN NUMBER) RETURN NUMBER IS
        salary PAYROLL.NET_SALARY%TYPE;
    BEGIN
        SELECT NET_SALARY INTO salary 
        FROM PAYROLL
        WHERE EMP_ID = emp_id AND ROWNUM = 1;

        RETURN salary;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END get_salary;
END payroll_pkg;
/

-- Call it
BEGIN
    payroll_pkg.raise_salary(201 , 11100);
    DBMS_OUTPUT.PUT_LINE('New Salary: ' || payroll_pkg.get_salary(202));
END;
/