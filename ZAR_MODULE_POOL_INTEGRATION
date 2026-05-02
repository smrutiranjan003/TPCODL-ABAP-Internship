*&---------------------------------------------------------------------*
*& Modulpool  ZAR_MODULE_POOL_INTEGRATION
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM zar_module_pool_integration.

DATA : r1 TYPE c, "c = char.
       r2 TYPE c,
       r3 TYPE c,
       r4 TYPE c.

DATA: ok_code TYPE sy-ucomm.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE TO SCREEN 0.



    WHEN 'SUBMIT'.
      IF r1 = 'X'.
        PERFORM display_r1.

      ELSEIF r2 = 'X'.

        PERFORM display_r2.

      ELSEIF r3 = 'X'.
        PERFORM display_r3.

      ELSEIF r4 = 'X'.
        PERFORM display_r4.
      ENDIF.

  ENDCASE.





ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'TITLE'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_R1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_r1 .
  MESSAGE 'R1 button is clicked' TYPE 'I'.
ENDFORM.

FORM display_r2 .
  MESSAGE 'R2 button is clicked' TYPE 'I'.
ENDFORM.

FORM display_r3 .
  MESSAGE 'R3 button is clicked' TYPE 'I'.
ENDFORM.

FORM display_r4 .
  MESSAGE 'R4 button is clicked' TYPE 'I'.
ENDFORM.
*
*
*MODULE user_command_0100 INPUT.
*
*  ok_code = sy-ucomm.   "IMPORTANT LINE
*
*  CASE ok_code.
*    WHEN 'SUBMIT'.
*
*      IF r1 = 'X'.
*        PERFORM display_r1.
*
*      ELSEIF r2 = 'X'.
*        PERFORM display_r2.
*
*      ELSEIF r3 = 'X'.
*        PERFORM display_r3.
*
*      ELSEIF r4 = 'X'.
*        PERFORM display_r4.
*      ENDIF.
*
*  ENDCASE.
*
*ENDMODULE.
