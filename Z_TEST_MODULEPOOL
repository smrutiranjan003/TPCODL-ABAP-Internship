*&---------------------------------------------------------------------*
*& Modulpool  Z_TEST_MODULEPOOL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM z_test_modulepool.

TABLES : mara.

DATA : p_matnr TYPE mara-matnr.

START-OF-SELECTION.
  CALL SCREEN 900.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0900  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0900 OUTPUT.
  SET PF-STATUS 'PF'.
  SET TITLEBAR 'TITLE'.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0900  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0900 INPUT.
  CASE sy-ucomm.
    WHEN 'XYZ_DISP'.
      IF NOT p_matnr IS INITIAL.
        SELECT SINGLE * FROM mara INTO @DATA(ls_mara) WHERE matnr = @p_matnr.
      ENDIF.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
