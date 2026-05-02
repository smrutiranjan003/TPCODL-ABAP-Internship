*&---------------------------------------------------------------------*
*& Report ZAR_CLASSICAL_REPORT_DEEP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zar_classical_report_deep.
*REPORT zar_classical_report_deep LINE-COUNT 10(2).

*PARAMETERS: p_matnr TYPE mara-matnr.
*
*DATA: lt_mara TYPE TABLE OF mara,
*      ls_mara TYPE mara.
*
*START-OF-SELECTION.
*
*  SELECT * FROM mara
*    INTO TABLE lt_mara
*    WHERE matnr = p_matnr.
*
*  IF lt_mara IS INITIAL.
*    MESSAGE 'No data found' TYPE 'I'.
*  ELSE.
*    LOOP AT lt_mara INTO ls_mara.
*      WRITE: / ls_mara-matnr, ls_mara-mtart.
*    ENDLOOP.
*  ENDIF.

*DATA : lv_output(3) TYPE n.
*
*PARAMETERS: p_input1(2) TYPE n,
*            p_input2(2) TYPE n.
*
*INITIALIZATION. "use for default input.
*p_input1 = 10.
*
*START-OF-SELECTION.
*
*
**lv_output = 98 + 99.
*IF p_input1 IS INITIAL OR p_input2 IS INITIAL. "IS INITIAL refers to -
**MESSAGE a000(ZAR_MESSAGE_CLASS). "globally declare "aeiswx
*  MESSAGE 'Please Give Input in all Parameters!' TYPE 'I'.
*
*ELSE.
*  lv_output = p_input1 + p_input2.
*  WRITE :/ 'result' , lv_output.
*ENDIF.

*Requirement:- Display Details Of Sales Document Number form VBAK table.
*9 types of classical reports events
*1. Initialization: This event calls before displaying the selection screen/input screen.
*         the purpose of this event is to assign the default values to parameters and select options.
*Lets create a program, so that we can understand the events easily.

*REPORT zar_classical_report_events.

**---------------------------------------------------------------------*
** TYPES & DATA
**---------------------------------------------------------------------*
*TYPES: BEGIN OF ty_vbak,
*         vbeln TYPE vbak-vbeln,
*         erdat TYPE vbak-erdat,
*         erzet TYPE vbak-erzet,
*         ernam TYPE vbak-ernam,
*         vbtyp TYPE vbak-vbtyp,
*       END OF ty_vbak.
*
*DATA: lt_vbak TYPE STANDARD TABLE OF ty_vbak,
*      ls_vbak TYPE ty_vbak.
*
INCLUDE ZINCLUDE_PROGRAM.  "all the declaration part here.
*---------------------------------------------------------------------*
* SELECTION SCREEN
*---------------------------------------------------------------------*
SELECT-OPTIONS: s_vbeln FOR ls_vbak-vbeln.

PARAMETERS: p_ernam TYPE ernam,
            p_erdat TYPE vbak-erdat,
            p_time  TYPE erzet.

*---------------------------------------------------------------------*
* 1. INITIALIZATION
*---------------------------------------------------------------------*
INITIALIZATION.
  p_ernam = sy-uname.
  p_erdat = sy-datum.
  p_time = sy-uzeit.



*---------------------------------------------------------------------*
* 2. VALIDATION
*---------------------------------------------------------------------*
AT SELECTION-SCREEN.
  IF s_vbeln IS INITIAL.
    MESSAGE 'Please enter at least one Sales Document.' TYPE 'E'.
  ELSE.
    MESSAGE 'Data Exist.' TYPE 'S'.
  ENDIF.


*if at selection fails then data doesnot/ not working
*---------------------------------------------------------------------*
* 3. MAIN LOGIC
*---------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT vbeln erdat erzet ernam vbtyp
    FROM vbak
    INTO TABLE lt_vbak
    WHERE vbeln IN s_vbeln.

*---------------------------------------------------------------------*
* 4. HEADER
*---------------------------------------------------------------------*
TOP-OF-PAGE.

  WRITE: / 'Sales Document Report',
         / 'Run Date:', sy-datum,
         / 'Run Time:', sy-uzeit.


*---------------------------------------------------------------------*
* 5. DISPLAY
*---------------------------------------------------------------------*
*END-OF-SELECTION.

  IF lt_vbak IS INITIAL.
    MESSAGE 'No data found for given selection.' TYPE 'I' DISPLAY LIKE 'W'.
  ELSE.
    LOOP AT lt_vbak INTO ls_vbak.
      WRITE: / '|', ls_vbak-vbeln,
               '|', ls_vbak-erdat,
               '|', ls_vbak-erzet,
               '|', ls_vbak-ernam,
               '|', ls_vbak-vbtyp.
    ULINE.
    ENDLOOP.
  ENDIF.

*---------------------------------------------------------------------*
* 6. FOOTER
*---------------------------------------------------------------------*
END-OF-PAGE.
  WRITE: / '--- End of Report ---'.
