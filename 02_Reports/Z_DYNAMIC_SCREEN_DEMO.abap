*&---------------------------------------------------------------------*
*& Report Z_DYNAMIC_SCREEN_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_dynamic_screen_demo.

TABLES: vbak.

*---------------------------------------------------------------------*
* SELECTION SCREEN
*---------------------------------------------------------------------*

"Block to group fields together
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

"Radio buttons (only one can be selected at a time)
PARAMETERS: r1 RADIOBUTTON GROUP g1 DEFAULT 'X' USER-COMMAND uc,
            r2 RADIOBUTTON GROUP g1.

"Input fields
PARAMETERS: p_vbeln TYPE vbak-vbeln MODIF ID so,   "Sales Order
            p_auart TYPE vbak-auart MODIF ID dt.   "Document Type

"Push button
SELECTION-SCREEN PUSHBUTTON /10(20) btn1 USER-COMMAND btn.

SELECTION-SCREEN END OF BLOCK b1.

*---------------------------------------------------------------------*
* INITIALIZATION (Runs when screen loads first time)
*---------------------------------------------------------------------*
INITIALIZATION.

  btn1 = 'Execute'.   "Text for push button

*---------------------------------------------------------------------*
* DYNAMIC SCREEN CONTROL (Main Logic)
*---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

  "SCREEN is a system table that contains all screen fields
  LOOP AT SCREEN.

    "If Radio Button 1 is selected
    IF r1 = 'X'.

      "Show Sales Order field
      IF screen-group1 = 'SO'.
        screen-invisible = 0.   "Visible
        screen-input     = 1.   "Editable

      "Hide Document Type field
      ELSEIF screen-group1 = 'DT'.
        screen-invisible = 1.   "Hidden
        screen-input     = 0.   "Not editable
      ENDIF.

    "If Radio Button 2 is selected
    ELSEIF r2 = 'X'.

      "Hide Sales Order field
      IF screen-group1 = 'SO'.
        screen-invisible = 1.
        screen-input     = 0.

      "Show Document Type field
      ELSEIF screen-group1 = 'DT'.
        screen-invisible = 0.
        screen-input     = 1.
      ENDIF.

    ENDIF.

    "Apply changes to screen
    MODIFY SCREEN.

  ENDLOOP.

*---------------------------------------------------------------------*
* BUTTON CLICK EVENT
*---------------------------------------------------------------------*
AT SELECTION-SCREEN.

  CASE sy-ucomm.

    WHEN 'BTN'.   "When push button is clicked

      IF r1 = 'X'.
        MESSAGE 'Sales Order Selected' TYPE 'I'.
      ELSE.
        MESSAGE 'Document Type Selected' TYPE 'I'.
      ENDIF.

  ENDCASE.

*---------------------------------------------------------------------*
* MAIN PROGRAM
*---------------------------------------------------------------------*
START-OF-SELECTION.

  IF r1 = 'X'.
    WRITE: / 'You entered Sales Order:', p_vbeln.
  ELSE.
    WRITE: / 'You entered Document Type:', p_auart.
  ENDIF.
