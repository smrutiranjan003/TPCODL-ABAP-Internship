*&---------------------------------------------------------------------*
*& Modulpool  ZSTATE_CITY_MODULE_POOL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM zstate_city_module_pool.

TABLES : zar_state_city.

DATA: ok_code TYPE sy-ucomm.

*---------------------------------------------------------------------*
* Type declaration
*---------------------------------------------------------------------*
TYPES : BEGIN OF ty_state_city,
          mandt      TYPE sy-mandt,
          state      TYPE zar_state,
          city       TYPE zar_city,
          local_area TYPE zar_la,
          pincode    TYPE zar_pin,
        END OF ty_state_city.

DATA : lt_state_city TYPE TABLE OF ty_state_city,
       ls_state_city TYPE ty_state_city.

*DATA : lv_state TYPE zar_state.

CONTROLS: ztable TYPE TABLEVIEW USING SCREEN 0200.

START-OF-SELECTION.


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATE'.
  SET TITLEBAR 'ST'.

ENDMODULE.
*  LOOP AT SCREEN.
*    IF zar_state_city-state = 'MAH' OR zar_state_city-state = 'BIH'.
*      IF screen-name = 'ZAR_STATE_CITY-CITY'
*         OR screen-name = 'ZAR_STATE_CITY-LOCAL_AREA'
*         OR screen-name = 'ZAR_STATE_CITY-PINCODE'.
*        screen-input = 0.
*        MODIFY SCREEN.
*      ENDIF.
*  ENDLOOP.
*LOOP AT SCREEN.
*
*  IF screen-name = 'LS_STATE_CITY-STATE'
*     OR screen-name = 'LS_STATE_CITY-CITY'.
*
*    screen-input = 0.
*
*  ELSEIF screen-name = 'LS_STATE_CITY-LOCAL_AREA'
*     OR screen-name = 'LS_STATE_CITY-PINCODE'.
*
*    screen-input = 1.
*
*  ENDIF.
*
*  MODIFY SCREEN.
*
*ENDLOOP.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.

WHEN 'SUBMIT'.

  CLEAR lt_state_city.

  " Case 1: Both blank # ALL data
  IF zar_state_city-state IS INITIAL
     AND zar_state_city-pincode IS INITIAL.

    SELECT mandt state city local_area pincode
      FROM zar_state_city
      INTO TABLE lt_state_city.

  " Case 2: Only STATE
  ELSEIF zar_state_city-state IS NOT INITIAL
     AND zar_state_city-pincode IS INITIAL.

    SELECT mandt state city local_area pincode
      FROM zar_state_city
      INTO TABLE lt_state_city
      WHERE state = zar_state_city-state.

  " Case 3: Only PINCODE
  ELSEIF zar_state_city-state IS INITIAL
     AND zar_state_city-pincode IS NOT INITIAL.

    SELECT mandt state city local_area pincode
      FROM zar_state_city
      INTO TABLE lt_state_city
      WHERE pincode = zar_state_city-pincode.

  " Case 4: BOTH filled
  ELSE.

    SELECT mandt state city local_area pincode
      FROM zar_state_city
      INTO TABLE lt_state_city
      WHERE state   = zar_state_city-state
        AND pincode = zar_state_city-pincode.

  ENDIF.

  CALL SCREEN 0200.
*
*    WHEN 'SUBMIT'.
*
*      SELECT mandt state city local_area pincode
*        FROM zar_state_city
*        INTO TABLE lt_state_city
*        WHERE state EQ zar_state_city-state
*       OR pincode EQ zar_state_city-pincode.
*
*      LOOP AT lt_state_city INTO ls_state_city.
*
*        MODIFY lt_state_city FROM ls_state_city.
*      ENDLOOP.
*
*      CALL SCREEN 0200.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'CITY'.
  SET TITLEBAR 'CT'.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  ok_code = sy-ucomm.

*  CLEAR sy-ucomm.
  CASE ok_code.
*    WHEN 'PROJECT'.
**      CALL SCREEN '200'.

    WHEN 'SAVE'.
      MODIFY zar_state_city FROM TABLE lt_state_city.

    WHEN 'ADD'.
      INSERT INITIAL LINE INTO TABLE lt_state_city.
*      APPEND INITIAL LINE TO lt_state_city.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0100.

  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  TBC_200_MODIFY
*&---------------------------------------------------------------------*
MODULE tbc_200_modify.

  ls_state_city-mandt = sy-mandt.
  MODIFY lt_state_city FROM ls_state_city INDEX ztable-current_line.

ENDMODULE.
