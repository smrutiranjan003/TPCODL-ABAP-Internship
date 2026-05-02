*&---------------------------------------------------------------------*
*& Report ZAR_ALV_EVENTS_DISPLAY
*&---------------------------------------------------------------------*

REPORT zar_alv_events_display.

TYPE-POOLS: slis.

TABLES: vbak, vbap.

*---------------------------------------------------------------------*
* SELECT-OPTIONS
*---------------------------------------------------------------------*
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln DEFAULT '1000'. "OBLIGATORY MEMORY_ID MODIF_ID

*SELECT-OPTIONS: s_vbeln FOR vbak-vbeln NO INTERVALS. "only single value
*SELECT-OPTIONS: s_vbeln FOR vbak-vbeln NO-EXTENSION. "no multiple entries
*---------------------------------------------------------------------*
* PARAMETERS
*---------------------------------------------------------------------*
PARAMETERS: p_ernam TYPE ernam DEFAULT sy-uname OBLIGATORY,
            p_erdat TYPE vbak-erdat DEFAULT sy-datum MEMORY ID dat,
            p_time  TYPE erzet.
PARAMETERS: p_text TYPE char20 LOWER CASE.   "allow lowercase

PARAMETERS: p_hide TYPE char10 NO-DISPLAY.   "hidden field
PARAMETERS: p_check AS CHECKBOX DEFAULT 'X'. "checkbox
*PARAMETERS: r1 RADIOBUTTON GROUP g1 DEFAULT 'X',
*            r2 RADIOBUTTON GROUP g1.         "radio buttons

*PARAMETERS: r1 RADIOBUTTON GROUP g1 USER-COMMAND uc,
*           r2 RADIOBUTTON GROUP g1.

PARAMETERS: p_vbeln TYPE vbak-vbeln MODIF ID so,   "Sales Order
            p_auart TYPE vbak-auart MODIF ID dt.   "Document Type

*PARAMETERS: p_mod TYPE char10 MODIF ID m1.   "for screen control
*---------------------------------------------------------------------*
* TYPES
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_vbak,
         mandt TYPE vbak-mandt,
         vbeln TYPE vbak-vbeln,
         auart TYPE vbak-auart,
         vkorg TYPE vbak-vkorg,
         erdat TYPE vbak-erdat,
         ernam TYPE vbak-ernam,
       END OF ty_vbak.

TYPES: BEGIN OF ty_vbap,
         vbeln  TYPE vbap-vbeln,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         werks  TYPE vbap-werks,
         kwmeng TYPE vbap-kwmeng,
       END OF ty_vbap.

TYPES: BEGIN OF ty_final,
         vbeln  TYPE vbak-vbeln,
         auart  TYPE vbak-auart,
         vkorg  TYPE vbak-vkorg,
         erdat  TYPE vbak-erdat,
         ernam  TYPE vbak-ernam,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         werks  TYPE vbap-werks,
         kwmeng TYPE vbap-kwmeng,
       END OF ty_final.

*---------------------------------------------------------------------*
* DATA
*---------------------------------------------------------------------*
DATA: it_vbak  TYPE TABLE OF ty_vbak,
      it_vbap  TYPE TABLE OF ty_vbap,
      it_final TYPE TABLE OF ty_final.

DATA: ls_vbak  TYPE ty_vbak,
      ls_vbap  TYPE ty_vbap,
      ls_final TYPE ty_final.

DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
      ls_fieldcat TYPE slis_fieldcat_alv.

DATA: ls_layout TYPE slis_layout_alv.

*---------------------------------------------------------------------*
* INITIALIZATION
*---------------------------------------------------------------------*
INITIALIZATION.

*  DATA: s_vbeln TYPE RANGE OF vbak-vbeln.

  CLEAR s_vbeln.

  "Include single value
  s_vbeln-sign   = 'I'.      " Include
  s_vbeln-option = 'EQ'.     " Equal
  s_vbeln-low    = '1000'.
  APPEND s_vbeln.
*
*  CLEAR s_vbeln.
*
*  "Include range
*  s_vbeln-sign   = 'I'.
*  s_vbeln-option = 'BT'.     " Between
*  s_vbeln-low    = '1000'.
*  s_vbeln-high   = '2000'.
*  APPEND s_vbeln.
*
*  CLEAR s_vbeln.
*
*  "Exclude value
*  s_vbeln-sign   = 'E'.      " Exclude
*  s_vbeln-option = 'EQ'.
*  s_vbeln-low    = '1500'.
*  APPEND s_vbeln.

  "Default parameter values
  p_ernam = sy-uname.
  p_erdat = sy-datum.
  p_time  = sy-uzeit.


*---------------------------------------------------------------------*
* DYNAMIC SCREEN CONTROL
*---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.

    "R1 # Show Sales Order, Hide Document Type
    IF r1 = 'X'.

      IF screen-group1 = 'SO'.
        screen-invisible = 0.
        screen-input     = 1.
      ELSEIF screen-group1 = 'DT'.
        screen-invisible = 1.
        screen-input     = 0.
      ENDIF.

    "R2 # Show Document Type, Hide Sales Order
    ELSEIF r2 = 'X'.

      IF screen-group1 = 'SO'.
        screen-invisible = 1.
        screen-input     = 0.
      ELSEIF screen-group1 = 'DT'.
        screen-invisible = 0.
        screen-input     = 1.
      ENDIF.

    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.

*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* START-OF-SELECTION
*---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM display_data.

* Validation
  IF s_vbeln IS INITIAL.
    MESSAGE 'Please Enter Sales Org!' TYPE 'E'.
  ELSE.
    MESSAGE 'Data Exist.' TYPE 'S'.
  ENDIF.

*---------------------------------------------------------------------*
* FETCH DATA
*---------------------------------------------------------------------*
FORM fetch_data.

* Header Data
  SELECT mandt vbeln auart vkorg erdat ernam
    FROM vbak
    INTO TABLE it_vbak
    WHERE vbeln IN s_vbeln.

* Item Data
  IF it_vbak IS NOT INITIAL.
    SELECT vbeln posnr matnr werks kwmeng
      FROM vbap
      INTO TABLE it_vbap
      FOR ALL ENTRIES IN it_vbak
      WHERE vbeln = it_vbak-vbeln.
  ENDIF.

*---------------------------------------------------------------------*
* COMBINE DATA
*---------------------------------------------------------------------*
  LOOP AT it_vbak INTO ls_vbak.
    LOOP AT it_vbap INTO ls_vbap WHERE vbeln = ls_vbak-vbeln.

      ls_final-vbeln = ls_vbak-vbeln.
      ls_final-auart = ls_vbak-auart.
      ls_final-vkorg = ls_vbak-vkorg.
      ls_final-erdat = ls_vbak-erdat.
      ls_final-ernam = ls_vbak-ernam.
      ls_final-posnr = ls_vbap-posnr.
      ls_final-matnr = ls_vbap-matnr.
      ls_final-werks = ls_vbap-werks.
      ls_final-kwmeng = ls_vbap-kwmeng.

      APPEND ls_final TO it_final.
      CLEAR ls_final.

    ENDLOOP.
  ENDLOOP.



ENDFORM.

FORM display_data.

*---------------------------------------------------------------------*
* LAYOUT
*---------------------------------------------------------------------*
  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.
  ls_layout-window_titlebar = 'ALV SALES ORDER REPORT'.

*---------------------------------------------------------------------*
* FIELD CATALOG
*---------------------------------------------------------------------*
*vbeln (hotspot)
  ls_fieldcat-fieldname = 'VBELN'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Order'.
  ls_fieldcat-hotspot = 'X'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* AUART
  ls_fieldcat-fieldname = 'AUART'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Doc Type'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* VKORG
  ls_fieldcat-fieldname = 'VKORG'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Org'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* ERDAT
  ls_fieldcat-fieldname = 'ERDAT'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Created Date'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* ERNAM
  ls_fieldcat-fieldname = 'ERNAM'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Created By'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* POSNR
  ls_fieldcat-fieldname = 'POSNR'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Item'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* MATNR
  ls_fieldcat-fieldname = 'MATNR'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Material'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* WERKS
  ls_fieldcat-fieldname = 'WERKS'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Plant'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* KWMENG (Quantity)
  ls_fieldcat-fieldname = 'KWMENG'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Order Qty'.
  ls_fieldcat-do_sum = 'X'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

*---------------------------------------------------------------------*
* ALV DISPLAY
*---------------------------------------------------------------------*

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
    I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
      i_callback_top_of_page = 'TOP_OF_PAGE_FORM'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
     I_GRID_TITLE           = 'Sales Report' "Title of ALV screen
*     I_GRID_SETTINGS        =
      is_layout              = ls_layout
      it_fieldcat            = lt_fieldcat
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
     I_SAVE                 = 'A' "Allows user to save layout
*     IS_VARIANT             = ls_variant "Load saved layout
*     IT_EVENTS              = lt_events "Used for advanced ALV events
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = it_final.

* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
  .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*---------------------------------------------------------------------*

ENDFORM.

FORM add_field USING p_field p_text.

  ls_fieldcat-fieldname = p_field.
  ls_fieldcat-tabname   = 'IT_FINAL'.
  ls_fieldcat-seltext_l = p_text.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

ENDFORM.

AT SELECTION-SCREEN.

  IF r1 = 'X'.
    CLEAR p_auart.
  ELSEIF r2 = 'X'.
    CLEAR p_vbeln.
  ENDIF.

*---------------------------------------------------------------------*
FORM top_of_page_form.

  WRITE: / 'VBAK ALV REPORT'.
  WRITE: / 'User:', p_ernam.
  WRITE: / 'Date:', p_erdat.
*  WRITE: / 'Checkbox:', p_check.
  WRITE: / 'Radio1:', r1, 'Radio2:', r2.

ENDFORM.
