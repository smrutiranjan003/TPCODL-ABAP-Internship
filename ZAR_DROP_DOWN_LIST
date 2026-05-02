*&---------------------------------------------------------------------*
*& Modulpool  ZAR_DROP_DOWN_LIST
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM zar_drop_down_list.

TABLES : zar_state_city.
TYPES : BEGIN OF ty_state,
          state TYPE zar_state,
          city  TYPE zar_city,
        END OF ty_state.

DATA : lt_state TYPE TABLE OF ty_state,
       ls_state TYPE ty_state.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DROP_DOWN'.
  SET TITLEBAR 'DRP'.

  IF zar_state_city-state IS NOT INITIAL.
    DATA : lt_values TYPE TABLE OF vrm_value,
           ls_values LIKE LINE OF lt_values.

    CLEAR lt_values.
    LOOP AT lt_state INTO ls_state.
      ls_values-key = ls_state-state.
      ls_values-text = ls_state-city.
      APPEND ls_values TO lt_values.
      CLEAR ls_values.
    ENDLOOP.


    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id              = 'zar_state_city-city'
        values          = lt_values
      EXCEPTIONS
        id_illegal_name = 1
        OTHERS          = 2.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  IF sy-ucomm EQ 'BACK'.
    LEAVE TO SCREEN 0.

  ENDIF.
  IF sy-ucomm EQ 'STATE'.
    SELECT state city
      FROM zar_state_city
      INTO CORRESPONDING FIELDS OF TABLE lt_state
      WHERE state = zar_state_city-state.

  ENDIF.

ENDMODULE.
