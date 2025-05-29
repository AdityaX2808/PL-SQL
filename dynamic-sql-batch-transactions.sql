-- PL/SQL Joins , Dynamic SQL , Transactions & Batches
-- Joins
-- Inner Join
BEGIN
    FOR rec IN (
        SELECT e.EMP_ID , e.FIRST_NAME , d.DEPT_NAME
        FROM EMPLOYEES e
        INNER JOIN DEPARTMENTS d ON e.DEPT_ID = d.DEPT_ID
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE: ' || rec.FIRST_NAME || ' DEPT: ' || rec.DEPT_NAME);
    END LOOP;
END;
/

-- LEFT JOIN
BEGIN 
    FOR rec IN (
        SELECT e.EMP_ID , e.FIRST_NAME , p.NET_SALARY
        FROM EMPLOYEES e
        LEFT JOIN PAYROLL p ON e.EMP_ID = p.EMP_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || rec.EMP_ID || 
                             ', Name: ' || rec.FIRST_NAME || 
                             ', Salary: ' || rec.NET_SALARY);
    END LOOP;
END;
/

-- RIGHT JOIN
BEGIN 
    FOR rec IN (
        SELECT e.EMP_ID , e.FIRST_NAME , p.NET_SALARY
        FROM EMPLOYEES e
        RIGHT JOIN PAYROLL p ON e.EMP_ID = p.EMP_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || rec.EMP_ID || 
                             ', Name: ' || rec.FIRST_NAME || 
                             ', Salary: ' || rec.NET_SALARY);
    END LOOP;
END;
/

-- CROSS JOIN
BEGIN
   FOR rec IN (
      SELECT e.FIRST_NAME AS EMPLOYEE, d.DEPT_NAME
      FROM EMPLOYEES e
      CROSS JOIN DEPARTMENTS d
   ) LOOP
      DBMS_OUTPUT.PUT_LINE('Employee: ' || rec.EMPLOYEE || ' | Dept: ' || rec.DEPT_NAME);
   END LOOP;
END;
/


-- SELF JOIN
BEGIN
   FOR rec IN (
      SELECT e.FIRST_NAME AS EMPLOYEE, m.FIRST_NAME AS MANAGER
      FROM EMPLOYEES e
      JOIN EMPLOYEES m ON e.MANAGER_ID = m.EMP_ID
   ) LOOP
      DBMS_OUTPUT.PUT_LINE('Employee: ' || rec.EMPLOYEE || ' | Manager: ' || rec.MANAGER);
   END LOOP;
END;
/

-- TRANSACTIONS AND BATCHES
-- COMMIT 
BEGIN
    UPDATE PAYROLL
    SET NET_SALARY = NET_SALARY + 5000
    WHERE EMP_ID = 203;

    INSERT INTO PAYROLL_AUDIT (EMP_ID, ACTION_TYPE, ACTION_DATE)
    VALUES (203, 'SALARY_UPDATE', SYSDATE);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Salary updated and audit logged.');
END;
/

-- ROLLBACK (MANNUAL ABORT)
BEGIN
    UPDATE PAYROLL
    SET NET_SALARY = NET_SALARY - 10000
    WHERE EMP_ID = 205;

    -- Condition to undo
    IF SQL%ROWCOUNT = 0 THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Rollback as no rows were updated.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Salary decreased and committed.');
    END IF;
END;
/


-- SAVEPOINTS (PARTIAL ROLLBACKS)
BEGIN
    SAVEPOINT before_bonus;

    UPDATE PAYROLL SET NET_SALARY = NET_SALARY + 2000 WHERE EMP_ID = 201;

    SAVEPOINT after_bonus;

    UPDATE PAYROLL SET NET_SALARY = NET_SALARY + 3000 WHERE EMP_ID = 999;  -- invalid

    ROLLBACK TO after_bonus;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Rolled back to after_bonus point.');
END;
/


-- BATCH PROCESSING 
-- BATCH UPDATE EXAMPLE
BEGIN
    UPDATE PAYROLL
    SET NET_SALARY = NET_SALARY + 1000
    WHERE EMP_ID IN (SELECT EMP_ID FROM EMPLOYEES WHERE DEPT_ID = 101);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('All salaries in department 101 updated.');
END;
/


-- BATCH INSERT
DECLARE
    v_emp_id EMPLOYEES.EMP_ID%TYPE;
BEGIN
    FOR v_emp_id IN 201..215 LOOP
        INSERT INTO LEAVE_RECORDS (LEAVE_ID, EMP_ID, LEAVE_TYPE, START_DATE, END_DATE, STATUS)
        VALUES (LEAVE_SEQ.NEXTVAL, v_emp_id, 'CASUAL', SYSDATE, SYSDATE+2, 'PENDING');
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Leave records created for employees.');
END;
/