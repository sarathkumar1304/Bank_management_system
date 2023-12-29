/*
What is collection ?

--> A collection is an ordered group of logically related elements

1.What is %rowtype?

The % rowtype attribute is used to define a record with fields corresponding to all of the columns that are fetched from a cursor or cusor variable

SYNTAX
*/

DECLARE 
V_EMP_REC EMPLOYEES%ROWTYPE;
BEGIN
SELECT * 
INTO V_EMP_REC
FROM EMPLOYEES WHERE EMPLOYEE_ID=100;
DBMS_OUTPUT.PUT_LINE('EMP_ID    ='||V_EMP_REC.EMPLOYEE_ID);
DBMS_OUTPUT.PUT_LINE('NAME      ='||V_EMP_REC.FIRST_NAME);
DBMS_OUTPUT.PUT_LINE('SAL       ='||V_EMP_REC.SALARY);
DBMS_OUTPUT.PUT_LINE('DEP_ID    ='||V_EMP_REC.DEPARTMENT_ID);
DBMS_OUTPUT.PUT_LINE('HIRE_DATE ='||V_EMP_REC.HIRE_DATE);
END;




declare 
type v_array_type is varray(7) of varchar2(30);
v_day v_array_type := v_array_type(NULL,NULL,NULL,NULL,NULL,NULL,NULL);
BEGIN
V_DAY(1):='MONDAY';
V_DAY(2):='TUESDAY';
V_DAY(3):='WEDNESDAY';
V_DAY(4):='THURSDAY';
V_DAY(5):='FRIDAY';
V_DAY(6):='SATURDAY';
V_DAY(7):='SUNDAY';
DBMS_OUTPUT.PUT_LINE('V_DAY(1) = '||' '||V_DAY(1));
DBMS_OUTPUT.PUT_LINE('V_DAY(2) = '||' '||V_DAY(2));
DBMS_OUTPUT.PUT_LINE('V_DAY(3) = '||' '||V_DAY(3));
END;
/


/*
>Subscript outside of limit          --> Error that we got when the extend arg got greater then initalize value 
----------------------------------
*/
declare 
type v_array_type is varray(7) of varchar2(30);
v_day v_array_type := v_array_type(NULL);
BEGIN
V_DAY.EXTEND(8);
V_DAY(1):='MONDAY';                    
V_DAY(3):='WEDNESDAY';
DBMS_OUTPUT.PUT_LINE('V_DAY(1)'||V_DAY(1));
DBMS_OUTPUT.PUT_LINE('V_DAY(2)'||V_DAY(2));
DBMS_OUTPUT.PUT_LINE('V_DAY(3)'||V_DAY(3));
END;
/

/*
COLLECTIONS METHODS
=====================
1.LIMIT
2.COUNT
3.FIRST
4.LAST
5.TRIM
6.TRIM(N)
7.DELETE
8.EXTEND
9.EXTEND(N)
10.PRIOR(N)
11.NEXT
*/







DECLARE 
TYPE V_ARRAY_TYPE IS VARRAY(7) OF VARCHAR2(30);
V_DAY V_ARRAY_TYPE := V_ARRAY_TYPE(NULL,NULL,NULL);
BEGIN
V_DAY(1):='MONDAY';                    
V_DAY(2):='TUESDAY';
V_DAY(3):='WEDNESDAY';
DBMS_OUTPUT.PUT_LINE('V_DAY.LIMIT = '||V_DAY.LIMIT);  -->7
DBMS_OUTPUT.PUT_LINE('V_DAY.COUNT = '||V_DAY.COUNT);  -->NO.OF ALLOCATED MEMORY ==> 3 (NULL INITALIZED)
DBMS_OUTPUT.PUT_LINE('V_DAY.FIRST = '||V_DAY.FIRST);  --> RETURN INDEX NUMBER
DBMS_OUTPUT.PUT_LINE('V_DAY.LAST = '||V_DAY.LAST);    --> RETURN LAST INDEX POS
V_DAY.TRIM(2);  --> IT DELETS THE LAST OCCARNEC ELEMENT
DBMS_OUTPUT.PUT_LINE('V_DAY.COUNT AFTER TRIM = '||V_DAY.COUNT); 
--V_DAY.DELETE;   --> IT DELETS THE TOTAL RECORD INTHE VARIBALE
DBMS_OUTPUT.PUT_LINE('V_DAY.COUNT AFTER DELETE = '||V_DAY.COUNT);
DBMS_OUTPUT.PUT_LINE('V_DAY.PRIOR = '||V_DAY.PRIOR(3));
DBMS_OUTPUT.PUT_LINE('V_DAY.NEXT = '||V_DAY.NEXT(1));
END;
/

--REF CURSOR
DECLARE
TYPE REF_CUR_TYPE IS REF CURSOR;
RC_EMP_LIST REF_CUR_TYPE;
V_NAME VARCHAR2(30);
V_SALARY NUMBER;
BEGIN
OPEN RC_EMP_LIST FOR SELECT FIRST_NAME,SALARY FROM EMPLOYEES;
LOOP
FETCH RC_EMP_LIST INTO V_NAME,V_SALARY;
EXIT WHEN RC_EMP_LIST%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('EMP_NAME  = '||V_NAME||'  '||'SALARY  = '||V_SALARY);
END LOOP;
CLOSE RC_EMP_LIST;
END;
/

