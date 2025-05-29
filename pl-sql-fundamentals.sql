-- 1. PL/SQL Blocks
DECLARE
    emp_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO emp_count from EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE('Total Employees: ' || emp_count);
END;
/

-- PL/SQL blocks with exception
DECLARE
   first_name EMPLOYEES.FIRST_NAME%TYPE;
   last_name  EMPLOYEES.LAST_NAME%TYPE;
BEGIN
   SELECT FIRST_NAME, LAST_NAME
   INTO first_name, last_name
   FROM EMPLOYEES
   WHERE EMP_ID = 999; 

   DBMS_OUTPUT.PUT_LINE('Employee Name: ' || first_name || ' ' || last_name);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No employee found with ID 999.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

-- 2. Data Types
-- DATA TYPES(EXPLICIT TYPES)
DECLARE
    emp_id NUMBER(6) := 110;
    salary NUMBER(8 , 2) := 55000.75;
    join_date DATE := TO_DATE('2023-01-15' , 'YYYY-MM-DD');
    is_active CHAR(1) := 'Y';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_id);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || salary);
    DBMS_OUTPUT.PUT_LINE('Joining Date: ' || join_date);
    DBMS_OUTPUT.PUT_LINE('Active: ' || is_active);
END;
/


-- Achoring to Columns
DECLARE
    emp_name EMPLOYEES.FIRST_NAME%TYPE;
    net_salary PAYROLL.NET_SALARY%TYPE;
BEGIN
    SELECT FIRST_NAME INTO emp_name
    FROM EMPLOYEES
    WHERE EMP_ID = 201;

    SELECT NET_SALARY INTO net_salary
    FROM PAYROLL
    WHERE EMP_ID = 201;

    DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_name || ' | Salary: ' || net_salary);
END;
/


-- Whole row from EMPLOYESS (%ROWTYPE)
DECLARE
    emp_rec EMPLOYEES%ROWTYPE;
BEGIN
    SELECT * INTO emp_rec
    FROM EMPLOYEES
    WHERE EMP_ID = 202;

     DBMS_OUTPUT.PUT_LINE(
      'Name: ' || emp_rec.FIRST_NAME || ' ' || emp_rec.LAST_NAME ||
      ', Email: ' || emp_rec.EMAIL ||
      ', Department ID: ' || emp_rec.DEPT_ID
   );
END;
/


-- 3. Records & Nested Structures in PL/SQL
-- User Defined Record Type
DECLARE
    TYPE emp_rec_type IS RECORD (
        emp_id NUMBER,
        first_name VARCHAR2(50),
        last_name VARCHAR2(50),
        salary NUMBER(10 , 2)
    );

    emp_rec emp_rec_type;
BEGIN
    emp_rec.emp_id := 101;
    emp_rec.first_name := 'Ravi';
    emp_rec.last_name := 'Verma';
    emp_rec.salary := 50000;

    DBMS_OUTPUT.PUT_LINE('ID: ' || emp_rec.emp_id ||
                        ', Name: ' || emp_rec.first_name || ' ' || emp_rec.last_name ||
                        ', Salary: ' || emp_rec.salary);
END;
/


-- Record Based on a Table Row (%ROWTYPE)
DECLARE
    emp_rec EMPLOYEES%ROWTYPE;
BEGIN
    SELECT * INTO emp_rec
    FROM EMPLOYEES
    WHERE EMP_ID = 201;

    DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_rec.FIRST_NAME || ' ' || emp_rec.LAST_NAME);
END;
/


-- Nested Records Example
DECLARE
    TYPE payroll_type IS RECORD(
        basic_salary NUMBER,
        hra NUMBER,
        net_salary NUMBER
    );

    TYPE emp_with_payroll_type IS RECORD (
        emp_id NUMBER,
        full_name VARCHAR2(50),
        payroll payroll_type
    );

    emp_data emp_with_payroll_type;
BEGIN
    emp_data.emp_id := 105;
    emp_data.full_name := 'Ananya Iyer';
    emp_data.payroll.basic_salary := 40000;
    emp_data.payroll.hra := 8000;
    emp_data.payroll.net_salary := 48000;

    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_data.emp_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || emp_data.full_name);
    DBMS_OUTPUT.PUT_LINE('Net Salary: ' || emp_data.payroll.net_salary);
END;
/


-- 4. Control Statement
-- IF...THEN...ELSE
DECLARE
    salary NUMBER := 50000;
BEGIN
    IF salary > 70000 THEN
        DBMS_OUTPUT.PUT_LINE('High Salary');
    ELSIF salary BETWEEN 40000 AND 70000 THEN
        DBMS_OUTPUT.PUT_LINE('Average Salary');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Low Salary');
    END IF;
END;
/


-- Case Statement
DECLARE
grade CHAR := 'B';
BEGIN
    CASE grade
    WHEN 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('Good');
    WHEN 'C' THEN DBMS_OUTPUT.PUT_LINE('Fair');
    ELSE DBMS_OUTPUT.PUT_LINE('Needs Improvement');
    END CASE;
END;
/

-- Loop Types
-- a. Simple LOOP  with EXIT
DECLARE
i NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Counter:: ' || i);
        i := i + 1;
        EXIT WHEN i > 5;
    END LOOP;
END;
/


-- b. WHILE LOOP
DECLARE 
i NUMBER := 1;
BEGIN
    WHILE i <= 5 LOOP
    DBMS_OUTPUT.PUT_LINE('WHILE LOOP - Count: ' || i);
    i := i + 1;
    END LOOP;
END;
/


-- c. FOR LOOP
begin
    for i in 1..5 loop
        dbms_output.put_line('FOR Loop - Iteration: ' || i);
    end loop;
end;
/


-- Example on Payroll Table
DECLARE
salary PAYROLL.NET_SALARY%TYPE;
BEGIN
    for i in 101..105 loop
        begin
            SELECT NET_SALARY into salary
            from PAYROLL
            where EMP_ID = i;

            dbms_output.put_line('Employee ' || i || 'Salary: ' || salary);
        EXCEPTION
        when NO_DATA_FOUND then
            dbms_output.put_line('No Data for EMP_ID: ' || i);
        end;
    end loop;
end;
/