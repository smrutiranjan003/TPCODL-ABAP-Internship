*&---------------------------------------------------------------------*
*& Modulpool  ZAR_MODULE_POOL_SUB_SCREEN
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM zar_module_pool_sub_screen.


TABLES : zar_employee_tab.

TYPES : BEGIN OF ty_employee,
          emp_id     TYPE zar_employee_id,
          emp_name   TYPE zar_employee_name,
          department TYPE zar_department,
          manager    TYPE zar_manager,
          salary     TYPE zar_salary,
        END OF ty_employee.

DATA : ls_employee TYPE ty_employee.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.


  IF sy-ucomm EQ 'SUBMIT'.

    SELECT SINGLE * FROM zar_employee_tab
      INTO CORRESPONDING FIELDS OF ls_employee
      WHERE emp_id = zar_employee_tab-emp_id.



    zar_employee_tab-emp_name = ls_employee-emp_name.
    zar_employee_tab-department = ls_employee-DEPARTMENT.
    zar_employee_tab-manager = ls_employee-manager.
    zar_employee_tab-salary = ls_employee-salary.



  ENDIF.

ENDMODULE.
