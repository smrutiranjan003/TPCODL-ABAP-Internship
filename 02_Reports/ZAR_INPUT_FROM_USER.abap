*&---------------------------------------------------------------------*
*& Report ZAR_INPUT_FROM_USER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*REPORT zar_input_from_user.
*
*PARAMETERS : p_input1(2) TYPE n.
*PARAMETERS : p_input2(2) TYPE n.
*
*DATA : lv_output(3) TYPE n.
*
***&---------------------------------------------------------------------*
***& Creating Radio Button
***&---------------------------------------------------------------------*
**PARAMETERS : p_r1 TYPE c RADIOBUTTON GROUP r1.
**PARAMETERS : p_r2 TYPE c RADIOBUTTON GROUP r1,
**             p_r3 TYPE c RADIOBUTTON GROUP r1,
**             p_r4 TYPE c RADIOBUTTON GROUP r1.
*
**&---------------------------------------------------------------------*
**& Check-box Button
**&---------------------------------------------------------------------*
*PARAMETERS : p_r1 AS CHECKBOX.
*PARAMETERS : p_r2 AS CHECKBOX,
*             p_r3 AS CHECKBOX,
*             p_r4 AS CHECKBOX.
*
*IF p_r1 = abap_true AND p_r2 NE abap_true AND p_r3 NE abap_true AND p_r4 NE abap_true.
*  lv_output = p_input1 + p_input2.
*  WRITE : lv_output.
*
*ELSEIF p_r2 = abap_true.
*  lv_output = p_input1 - p_input2.
*  WRITE : lv_output.
*
*ELSEIF p_r3 = abap_true.
*  lv_output = p_input1 * p_input2.
*  WRITE : lv_output.
*
*ELSEIF p_r4 = abap_true.
*  IF p_input2 EQ 0.
*    WRITE : 'cannot be 0'.
*  ELSE.
*    lv_output = p_input1 / p_input2.
*    WRITE : lv_output.
*
*  ENDIF.
*ENDIF.

REPORT zar_input_from_user.

TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbeln_va,
         erdat TYPE erdat,
         erzet TYPE erzet,
         ernam TYPE ernam,
         vbtyp TYPE vbtyp,
       END OF ty_vbak.

TYPES: BEGIN OF ty_vbrk,
         vbeln TYPE vbeln_va,
         fkart TYPE fkart,
         fktyp TYPE fktyp,
         vbtyp TYPE vbtyp,
       END OF ty_vbrk.

DATA : lt_vbak TYPE TABLE OF ty_vbak,
       ls_vbak TYPE ty_vbak,
       lt_vbrk TYPE TABLE OF ty_vbrk,
       ls_vbrk TYPE ty_vbrk.

DATA : lv_vbeln TYPE vbeln_va.

SELECT-OPTIONS : s_vbeln FOR lv_vbeln.

*SELECT-OPTIONS : s_vbeln FOR lv_vbeln NO-EXTENSION.

*SELECT-OPTIONS : s_vbeln FOR lv_vbeln no intervals.

*SELECT-OPTIONS : s_vbeln FOR lv_vbeln NO INTERVALS NO-EXTENSION.


*for radio-button
PARAMETERS : p_r1 TYPE c RADIOBUTTON GROUP r1,
             p_r2 TYPE c RADIOBUTTON GROUP r1.

IF p_r1 = abap_true.

  SELECT vbeln erdat erzet ernam vbtyp
    FROM vbak
    INTO TABLE lt_vbak
    WHERE vbeln IN s_vbeln.

  IF sy-subrc EQ 0.
    LOOP AT lt_vbak INTO ls_vbak.
      WRITE :/ ls_vbak-vbeln, ls_vbak-erdat, ls_vbak-erzet, ls_vbak-ernam, ls_vbak-vbtyp.
    ENDLOOP.

  ENDIF.

ELSEIF p_r2 = abap_true.

  SELECT vbeln fkart fktyp vbtyp
      FROM vbrk
      INTO TABLE lt_vbrk
      WHERE vbeln IN s_vbeln.

*&for checking data is in internal table or not

  IF lt_vbrk IS NOT INITIAL. "is not empty
    LOOP AT lt_vbrk INTO ls_vbrk.
      WRITE :/ ls_vbrk-vbeln, ls_vbrk-fkart, ls_vbrk-fktyp, ls_vbrk-vbtyp.

    ENDLOOP.
  ENDIF.

ENDIF.
