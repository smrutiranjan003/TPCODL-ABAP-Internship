*&---------------------------------------------------------------------*
*& Modulpool  ZMODULE_POOL_FIRST_PROGRAM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM zmodule_pool_first_program.

TABLES : zar_employee_tab.

DATA: ok_code TYPE sy-ucomm.

TYPES : BEGIN OF ty_employee,
          mandt      TYPE  sy-mandt,
          emp_id     TYPE zar_employee_id,
          emp_name   TYPE zar_employee_name,
          department TYPE zar_department,
          manager    TYPE zar_manager,
          salary     TYPE zar_salary,
        END OF ty_employee.


DATA : lt_employee TYPE TABLE OF ty_employee,
       ls_employee TYPE ty_employee.

TYPES : BEGIN OF ty_project,
          employee_id  TYPE zar_employee_id,
          project_id   TYPE zar_project_id,
          project_name TYPE zar_project_name,
        END OF ty_project.

DATA : lt_project TYPE TABLE OF ty_project,
       ls_project TYPE ty_project.

CONTROLS: zar_table TYPE TABLEVIEW USING SCREEN 0200.

DATA: lv_id1 TYPE zar_employee_tab-emp_id,
      lv_id2 TYPE zar_employee_tab-emp_id.



START-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  LOOP AT SCREEN.
    IF zar_employee_tab-emp_id = '101' OR zar_employee_tab-emp_id = '103'.
      IF screen-name = 'ZAR_EMPLOYEE_TAB-EMP_NAME' OR screen-name = 'ZAR_EMPLOYEE_TAB-DEPARTMENT'
        OR screen-name = 'ZAR_EMPLOYEE_TAB-MANAGER' OR screen-name = 'ZAR_EMPLOYEE_TAB-SALARY'.
        screen-input = 0.
        MODIFY SCREEN.
      ELSE.
      ENDIF.
      screen-input = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  SET PF-STATUS 'EMPLOYEE'.
  SET TITLEBAR 'EMP'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'EMPLOYEE'.

*      SELECT * FROM zar_employee_tab
*        INTO CORRESPONDING FIELDS OF TABLE lt_employee
*        WHERE emp_id = zar_employee_tab.
*
      SELECT emp_id emp_name department manager
         FROM zar_employee_tab
         INTO CORRESPONDING FIELDS OF TABLE lt_employee
         WHERE emp_id GE lv_id1 AND emp_id LE lv_id2.

      CALL SCREEN '200'.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'SUBMIT'.
      SELECT * FROM zar_employee_tab
        INTO CORRESPONDING FIELDS OF TABLE lt_employee
        WHERE emp_id = zar_employee_tab-emp_id.

      READ TABLE lt_employee INTO ls_employee WITH KEY emp_id = zar_employee_tab-emp_id.
      IF sy-subrc EQ 0.
        zar_employee_tab-emp_name = ls_employee-emp_name.
        zar_employee_tab-department = ls_employee-department.
        zar_employee_tab-manager = ls_employee-manager.
        zar_employee_tab-salary = ls_employee-salary.
      ENDIF.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'PROJECT'.
  SET TITLEBAR 'PRJ'.

*  modify lt_employee FROM ls_employee.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  ok_code = sy-ucomm.


*  CLEAR sy-ucomm.
  CASE ok_code.
    WHEN 'PROJECT'.
*      CALL SCREEN '200'.
    WHEN 'SAVE'.
      MODIFY zar_employee_tab FROM TABLE lt_employee.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ADD'.
      INSERT INITIAL LINE INTO TABLE lt_employee.
*      APPEND INITIAL LINE TO lt_employee.
  ENDCASE.

ENDMODULE.





MODULE tbc_200_modify.

  ls_employee-mandt = sy-mandt.
  MODIFY lt_employee FROM ls_employee INDEX zar_table-current_line.

ENDMODULE.
