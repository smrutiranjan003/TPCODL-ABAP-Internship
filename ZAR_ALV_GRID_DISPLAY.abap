*&---------------------------------------------------------------------*
*& Report ZAR_ALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zar_alv_grid_display.

TYPE-POOLS: slis.


*&type structure create of header and item table.

*---------------------------------------------------------------------*
* TYPE DECLARATIONS
*---------------------------------------------------------------------*

TYPES : BEGIN OF ty_ekko,
          ebeln TYPE ebeln,
          bsart TYPE bsart,
          lifnr TYPE elifn,
          zterm TYPE dzterm,
          bedat TYPE ebdat,
        END OF ty_ekko.

TYPES : BEGIN OF ty_ekpo,
          ebeln TYPE ebeln,
          ebelp TYPE ebelp,
          matnr TYPE matnr,
          werks TYPE ewerk,
          menge TYPE menge_d,
        END OF ty_ekpo.

TYPES: BEGIN OF ty_final,
         ebeln TYPE ebeln,
         bsart TYPE bsart,
         lifnr TYPE elifn,
         zterm TYPE dzterm,
         bedat TYPE ebdat,
         ebelp TYPE ebelp,
         matnr TYPE matnr,
         werks TYPE ewerk,
         menge TYPE menge_d,
       END OF ty_final.

*---------------------------------------------------------------------*
* DATA DECLARATIONS
*---------------------------------------------------------------------*

DATA : lt_ekko  TYPE TABLE OF ty_ekko,
       lt_ekpo  TYPE TABLE OF ty_ekpo,
       lt_final TYPE TABLE OF ty_final,
       ls_ekko  TYPE ty_ekko,
       ls_ekpo  TYPE ty_ekpo,
       ls_final TYPE ty_final.

DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
      ls_fieldcat TYPE slis_fieldcat_alv,
      ls_layout   TYPE slis_layout_alv.

DATA : lv_ebeln TYPE ebeln.

SELECT-OPTIONS : s_ebeln FOR lv_ebeln.

*---------------------------------------------------------------------*
* START-OF-SELECTION
*---------------------------------------------------------------------*

START-OF-SELECTION.

* Fetch Header Data
  SELECT ebeln bsart lifnr zterm bedat
    FROM ekko
    INTO TABLE lt_ekko
    WHERE ebeln IN s_ebeln.

* Fetch Item Data
  IF lt_ekko IS NOT INITIAL.
    SELECT ebeln ebelp matnr werks menge
      FROM ekpo
      INTO TABLE lt_ekpo
      FOR ALL ENTRIES IN lt_ekko
      WHERE ebeln = lt_ekko-ebeln.
  ENDIF.

* Combine Data
  LOOP AT lt_ekko INTO ls_ekko.
    LOOP AT lt_ekpo INTO ls_ekpo WHERE ebeln = ls_ekko-ebeln.

      ls_final-ebeln = ls_ekko-ebeln.
      ls_final-bsart = ls_ekko-bsart.
      ls_final-lifnr = ls_ekko-lifnr.
      ls_final-zterm = ls_ekko-zterm.
      ls_final-bedat = ls_ekko-bedat.
      ls_final-ebelp = ls_ekpo-ebelp.
      ls_final-matnr = ls_ekpo-matnr.
      ls_final-werks = ls_ekpo-werks.
      ls_final-menge = ls_ekpo-menge.

      APPEND ls_final TO lt_final.
      CLEAR ls_final.

    ENDLOOP.
  ENDLOOP.


*---------------------------------------------------------------------*
* LAYOUT
*---------------------------------------------------------------------*

  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.
  ls_layout-window_titlebar = 'ALV PO REPORT'.
  ls_layout-key_hotspot = 'X'.
*  ls_layout-box_fieldname = 'SEL'.   "checkbox

*---------------------------------------------------------------------*
* FIELD CATALOG
*---------------------------------------------------------------------*

* Checkbox
*  ls_fieldcat-fieldname = 'SEL'.
*  ls_fieldcat-tabname   = 'LT_FINAL'.
*  ls_fieldcat-checkbox  = 'X'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.

* EBELN (HOTSPOT + OUTPUTLEN)
  ls_fieldcat-fieldname = 'EBELN'.
  ls_fieldcat-tabname = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Purchasing Document Number'. "PO Number
  ls_fieldcat-emphasize = 'X'.
  ls_fieldcat-hotspot   = 'X'.        "hotspot
  ls_fieldcat-outputlen = 15.         "outputlen
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

*BSART
  ls_fieldcat-fieldname = 'BSART'.
  ls_fieldcat-tabname = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Purchasing Document Type'. "Doc Type
  ls_fieldcat-just = 'C'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.


  ls_fieldcat-fieldname = 'LIFNR'.
  ls_fieldcat-tabname = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Suppliers Account Number'.
  ls_fieldcat-no_out = 'X'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'ZTERM'.
  ls_fieldcat-tabname = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Terms of Payment Key'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* BEDAT (EDIT MASK)
  ls_fieldcat-fieldname = 'BEDAT'.
  ls_fieldcat-tabname = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Doc Date'.
  ls_fieldcat-edit_mask = '__/__/____'.   "edit mask
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

* MENGE (DO_SUM + QUANTITY)
  ls_fieldcat-fieldname = 'MENGE'.
  ls_fieldcat-tabname   = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Quantity'.
  ls_fieldcat-do_sum    = 'X'.        "do sum
*  ls_fieldcat-qfieldname = 'MEINS'.   "quantity reference
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'EBELP'.
  ls_fieldcat-tabname = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Item Number of Purchasing Document'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'MATNR'.
  ls_fieldcat-tabname = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Material Number'. "Material
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'WERKS'.
  ls_fieldcat-tabname = 'LT_FINAL'.
  ls_fieldcat-seltext_l = 'Plant'.
  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.


*---------------------------------------------------------------------*
* ALV CALL
*---------------------------------------------------------------------*

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_structure_name   = 'TY_FINAL'
      i_background_id    = 'SIWB_WALLPAPER'
      is_layout          = ls_layout
      it_fieldcat        = lt_fieldcat
      i_default          = 'X'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
