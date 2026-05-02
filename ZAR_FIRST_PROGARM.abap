**&---------------------------------------------------------------------*
**& Report ZAR_FIRST_PROGARM
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*
REPORT zar_first_progarm.
*
**creating input and output variable
*DATA : lv_input1(2) TYPE n.
*
*DATA : lv_input2(2) TYPE n.
*DATA : lv_input3(2) TYPE n.
*DATA : lv_output(2) TYPE n.
*
*
**enter values in input and output variable
*lv_input1 = 40.
*lv_input2 = 40.
*lv_input3 = 50.
*
*
**processing logic:
*lv_output = lv_input1 + lv_input2 + lv_input3.
*
***output
**IF lv_input2 = 30.
**  WRITE : 'result : ' , lv_output.
**ELSEIF lv_input1 = 40.
**  WRITE : 'result : ' , lv_output.
**ELSE.
**  WRITE : 'wrong input'.
**ENDIF.
**&------------------------------------------------------------------
***&case
**CASE lv_input1.
**  WHEN 30.
**    WRITE : 'result : ' , lv_output.
**  WHEN 40.
**    WRITE : 'result : ' , lv_output.
**  WHEN OTHERS.
**    WRITE : 'wrong input'.
**ENDCASE.
*
**&---------------------------------------------------------------------
***&unconditional loop.
*DO 6 TIMES.
*
*WRITE:/ 'hello shree'.
*
*
*ENDDO.
**
***&---------------------------------------------------------------------
****&conditional loop.
*DATA : lo_count(2) TYPE n.
*lo_count = 1.
*
*WHILE lo_count <= 5.
*  WRITE:/ 'hello shree'.
*   lo_count = lo_count + 1.
*
*ENDWHILE.
*&---------------------------------------------------------------------
*creating type structure for employee
TYPES : BEGIN OF ty_employee,
          employee_id(2)    TYPE n,
          employee_name(40) TYPE c,
        END OF ty_employee.


DATA : LV_LENGTH TYPE i.
*&--------------------------------------------------------------------
*&internal table
DATA : lt_employee TYPE TABLE OF ty_employee.
*&---------------------------------------------------------------------
*&work area
DATA : ls_employee TYPE ty_employee.
*&---------------------------------------------------------------------
*&-storing some ammount of data in internal table.

ls_employee-employee_id = 10.
ls_employee-employee_name = 'Sachin'.
APPEND ls_employee TO lt_employee.
CLEAR ls_employee.

ls_employee-employee_id = 45.
ls_employee-employee_name = 'Rohit'.
APPEND ls_employee TO lt_employee.
CLEAR ls_employee.

ls_employee-employee_id = 7.
ls_employee-employee_name = 'Dhoni'.
APPEND ls_employee TO lt_employee.
CLEAR ls_employee.

ls_employee-employee_id = 18.
ls_employee-employee_name = 'Kohli'.
APPEND ls_employee TO lt_employee.
CLEAR ls_employee.

ls_employee-employee_id = 12.
ls_employee-employee_name = 'Yuvraj'.
APPEND ls_employee TO lt_employee.
CLEAR ls_employee.

ls_employee-employee_id = 33.
ls_employee-employee_name = 'Hardik'.
APPEND ls_employee TO lt_employee.
CLEAR ls_employee.

*clear lt_employee.

*&---------------------------------------------------------------------
*&delete operation
*DELETE lt_employee WHERE employee_name = 'Yuvraj'.
*DELETE lt_employee INDEX 3.


**&---------------------------------------------------------------------
**&MODIFY operation
*LOOP AT lt_employee INTO ls_employee.
*  if ls_employee-employee_id = 5.
*    ls_employee-employee_name = 'Bumrah'.
*    MODIFY lt_employee from ls_employee TRANSPORTING employee_name.
*
*    ENDIF.
*
*ENDLOOP.


**&---------------------------------------------------------------------
**&READ operation select vs read.
*READ TABLE lt_employee INTO ls_employee index 3.
*READ TABLE lt_employee INTO ls_employee with key employee_id = 3.
*IF sy-subrc eq 0.
*  write :/ ls_employee-employee_id, ls_employee-employee_name.
*
*ENDIF.
*
*collect statement
*&------------
*&DESCRIBE.
DESCRIBE TABLE LT_EMPLOYEE LINES LV_LENGTH.



*&---------------------------------------------------------------------
*&displaying internal table data
LOOP AT lt_employee INTO ls_employee.
  WRITE :/ ls_employee-employee_id, ls_employee-employee_name.

ENDLOOP.
