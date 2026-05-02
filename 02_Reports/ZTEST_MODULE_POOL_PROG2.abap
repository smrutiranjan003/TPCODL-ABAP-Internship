*&---------------------------------------------------------------------*
*& Modulpool  ZTEST_MODULE_POOL_PROG2
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM ztest_module_pool_prog2.

*TABLES : zar_employee_tab.
*
DATA: ok_code TYPE sy-ucomm.
*
*TYPES : BEGIN OF ty_employee,
*          emp_id     TYPE zar_employee_id,
*          emp_name   TYPE zar_employee_name,
*          department TYPE zar_department,
*          manager    TYPE zar_manager,
*          salary     TYPE zar_salary,
*        END OF ty_employee.
*
*
*DATA : lt_employee TYPE TABLE OF ty_employee,
*       ls_employee TYPE ty_employee.
*
*DATA: lv_empid  TYPE  zar_employee_id.

START-OF-SELECTION.

* Radio Buttons
  DATA: r1 TYPE c VALUE 'X',
        r2 TYPE c,
        r3 TYPE c.

* Checkboxes (Left side)
  DATA: c1 TYPE c,
        c2 TYPE c,
        c3 TYPE c.

* Checkboxes (Right side)
  DATA: c11 TYPE c,
        c21 TYPE c,
        c31 TYPE c.

  DATA : lv_test TYPE char1 VALUE IS INITIAL.


* Input Fields
  DATA: lv_input1 TYPE char20,
        lv_input2 TYPE char30,
        lv_input3 TYPE char40.
*
** Input Fields
  DATA: lv_input11 TYPE char20,
        lv_input21 TYPE char30,
        lv_input31 TYPE char40.

  DATA: lv_input_scr1 TYPE  char20,
        lv_input_scr2 TYPE  char30,
        lv_input_scr3 TYPE  char40.

  DATA: lv_input_scr11 TYPE  char20,
        lv_input_scr21 TYPE  char30,
        lv_input_scr31 TYPE  char40.

* Control Variable for MODIF
*  DATA: gv_active TYPE c.


  CALL SCREEN 101.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
  SET PF-STATUS 'SUB_SCREEN'.
  SET TITLEBAR 'SUBS'.
*
**  LOOP AT SCREEN.
*
*    screen-invisible = 0.
*    screen-input     = 1.
*
**  IF gv_active IS INITIAL.
**    CLEAR: r1, r2, r3.
**  ENDIF.
  IF r1 = 'X'.
**     MESSAGE 'Radio Button 1 is clicked'(007) TYPE 'I'.
**          ELSE.
**            MESSAGE 'Please select R1'(008) TYPE 'E'.
*
    LOOP AT SCREEN.
      IF screen-group1 = 'M2' OR screen-group1 = 'M3'.

        screen-invisible = 1.
        screen-input = 0.
        MODIFY SCREEN.

      ENDIF.
    ENDLOOP.
  ENDIF.
*
  IF r2 = 'X'.
*
**    MESSAGE 'Radio Button 2 is clicked'(001) TYPE 'I'.
**          ELSE.
**            MESSAGE 'Please select R2'(002) TYPE 'E'.
*
    LOOP AT SCREEN.
      IF screen-group1 = 'M1' OR screen-group1 = 'M3'.

        screen-invisible = 1.
        screen-input = 0.
        MODIFY SCREEN.

      ENDIF.
    ENDLOOP.
  ENDIF.

  IF r3 = 'X'.
**        MESSAGE 'Radio Button 3 is clicked'(009) TYPE 'I'.
**          ELSE.
**            MESSAGE 'Please select R3'(010) TYPE 'E'.
    LOOP AT SCREEN.
      IF screen-group1 = 'M1' OR screen-group1 = 'M2'.

        screen-invisible = 1.
        screen-input = 0.
        MODIFY SCREEN.

      ENDIF.
    ENDLOOP.
  ENDIF.
**      ENDLOOP.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0102  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0102 OUTPUT.
  SET PF-STATUS 'STS_102'.
  SET TITLEBAR '102'.


  IF lv_input1 IS NOT INITIAL.
    lv_input_scr1 = |{ lv_input1 } { lv_input11 }|.
  ENDIF.

*  IF lv_input1 IS NOT INITIAL.
*    lv_input_scr1 = lv_input1.
*  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0102 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0101.


  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.

  CASE sy-ucomm.
*    WHEN 'FCT'.
*      lv_test = '1'.
    WHEN 'BACK'.

      LEAVE TO SCREEN 0.

    WHEN 'BUTTON1'.

      CALL SCREEN 0102.

    WHEN 'BUTTON2'.
      CALL SCREEN 0103.

    WHEN 'BUTTON3'.
      CALL SCREEN 0104.


  ENDCASE.

ENDMODULE.

*    WHEN 'SUBMIT'.
*
*      IF zar_employee_tab-emp_id IS INITIAL.
*        MESSAGE 'Please enter Employee ID' TYPE 'E'.
*      ENDIF.
*
*
*  SELECT * FROM zar_employee_tab
*     INTO CORRESPONDING FIELDS OF TABLE lt_employee
*     WHERE emp_id = zar_employee_tab-emp_id.
*
*
*  IF lt_employee IS NOT INITIAL.
*    READ TABLE lt_employee INTO ls_employee INDEX 1.
*    IF sy-subrc EQ 0.
*
*      zar_employee_tab-emp_name = ls_employee-emp_name.
*      zar_employee_tab-department = ls_employee-department.
*      zar_employee_tab-manager = ls_employee-manager.
*      zar_employee_tab-salary = ls_employee-salary.
*
*    ENDIF.
*  ENDIF.
*      CALL SCREEN 102.
*
*  ENDCASE.
**
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0103  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0103 OUTPUT.
  SET PF-STATUS 'SCREEN2'.
  SET TITLEBAR 'SCR2'.


  IF lv_input2 IS NOT INITIAL.
    lv_input_scr2 = |{ lv_input2 } { lv_input21 }|.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0104  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0104 OUTPUT.
  SET PF-STATUS 'SCREEN3'.
  SET TITLEBAR 'SCR3'.

  IF lv_input3 IS NOT INITIAL.
    lv_input_scr3 = |{ lv_input3 } { lv_input31 }|.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0103 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK'.

      LEAVE TO SCREEN 0101.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0104  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0104 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.

      LEAVE TO SCREEN 0101.
  ENDCASE.
*  ENDCASE.





ENDMODULE.
