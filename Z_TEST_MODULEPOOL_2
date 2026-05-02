*&---------------------------------------------------------------------*
*& Report Z_TEST_MODULEPOOL_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_modulepool_2.

TABLES : zar_employee_tab.

DATA : p_department        TYPE zar_employee_tab-department,
       ls_zar_employee_tab TYPE zar_employee_tab.

START-OF-SELECTION.
  CALL SCREEN 400.


*&---------------------------------------------------------------------*
*&      Module  STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0400 OUTPUT.
  SET PF-STATUS 'PF'.
  SET TITLEBAR 'TITLE'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.

  CASE sy-ucomm.
    WHEN 'PQR_DISPLAY'.
      IF NOT p_department IS INITIAL.

        SELECT SINGLE *
         INTO ls_zar_employee_tab
         FROM zar_employee_tab
         WHERE department = p_department.

      ENDIF.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.

*WHEN OTHERS.
  ENDCASE.

ENDMODULE.
