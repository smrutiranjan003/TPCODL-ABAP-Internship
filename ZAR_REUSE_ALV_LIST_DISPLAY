**&---------------------------------------------------------------------*
**& Report ZAR_REUSE_ALV_LIST_DISPLAY
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*
*REPORT zar_reuse_alv_list_display.
*
**&type structure create of header and item table.
*
*TYPES : BEGIN OF ty_ekko,
*          ebeln TYPE ebeln,
*          bukrs TYPE bukrs,
*          bstyp TYPE ebstyp,
*          bsart TYPE esart,
*        END OF ty_ekko.
*
*TYPES : BEGIN OF ty_ekpo,
*          ebeln TYPE ebeln,
*          ebelp TYPE ebelp,
*          matnr TYPE matnr,
*          werks TYPE ewerk,
*        END OF ty_ekpo.
*
**&final structure.
*TYPES: BEGIN OF ty_final,
*         ebeln TYPE ebeln,
*         bukrs TYPE bukrs,
*         bstyp TYPE ebstyp,
*         bsart TYPE esart,
*         ebelp TYPE ebelp,
*         matnr TYPE matnr,
*         werks TYPE ewerk,
*       END OF ty_final.
*
*DATA : lt_ekko  TYPE TABLE OF ty_ekko,
*       ls_ekko  TYPE ty_ekko,
*       lt_ekpo  TYPE TABLE OF ty_ekpo,
*       ls_ekpo  TYPE ty_ekpo,
*       lt_final TYPE TABLE OF ty_final,
*       ls_final TYPE ty_final.
*
*DATA : lt_fieldcat TYPE TABLE OF slis_fieldcat_alv.
*DATA : ls_fieldcat TYPE slis_fieldcat_alv.
*DATA : ls_layout TYPE slis_layout_alv.
*DATA: lt_commentary TYPE TABLE OF slis_listheader.
*DATA: ls_commentary TYPE slis_listheader.
*
*DATA: lv_input type string.
*
*DATA : ls_sort TYPE slis_sortinfo_alv.
*DATA : lt_sort TYPE table of slis_sortinfo_alv.
*
*DATA : lt_filter TYPE table of slis_filter_alv.
*DATA : ls_filter TYPE slis_sortinfo_alv.
*
*DATA: ls_key TYPE slis_keyinfo_alv.
*
**&user input using select option.
*DATA : lv_ebeln TYPE ebeln.
*SELECT-OPTIONS : s_ebeln FOR lv_ebeln.
*
*START-OF-SELECTION.
*
*  SELECT ebeln bukrs bstyp bsart
*    FROM ekko
*    INTO TABLE lt_ekko
*    WHERE ebeln IN s_ebeln.
*
**&look at in basis of internal table
*  IF lt_ekko IS NOT INITIAL. "IF lt_Ekko is not empty.
*
*    SELECT ebeln ebelp matnr werks
*  FROM ekpo
*  INTO TABLE lt_ekpo
*      FOR ALL ENTRIES IN lt_ekko "for all entries ?
*  WHERE ebeln = lt_ekko-ebeln.
*
*  ENDIF.
*
**&always use loop at line item table.
*  LOOP AT lt_ekpo INTO ls_ekpo.
*    ls_final-ebelp = ls_ekpo-ebelp.
*    ls_final-matnr = ls_ekpo-matnr.
*    ls_final-werks = ls_ekpo-werks.
*
**&for header use Read Table
*    READ TABLE lt_ekko INTO ls_ekko WITH KEY ebeln = ls_ekpo-ebeln.
*    IF sy-subrc EQ 0.
*      ls_final-ebeln = ls_ekko-ebeln.
*      ls_final-bukrs = ls_ekko-bukrs.
*      ls_final-bstyp = ls_ekko-bstyp.
*      ls_final-bsart = ls_ekko-bsart.
*
*    ENDIF.
*
*    APPEND ls_final TO lt_final.
*    CLEAR ls_final.
*
*
*  ENDLOOP.
**FOR SIMPLE ALV DISPLAY USE CLASS "CL_SALV_TABLE -> FACTORY METHOD, USING IT'S DISPLAY METHOD DISPLAY
*  TRY.
*      CALL METHOD cl_salv_table=>factory
*        EXPORTING
*          list_display = if_salv_c_bool_sap=>false
*         r_container  =
**         container_name =
**        IMPORTING
**          r_salv_table = DATA(lo_obj)
**        CHANGING
*          t_table      = lt_final.
*    CATCH cx_salv_msg .
*  ENDTRY.
*  lo_obj->display().
*
*  WRITE : 'X'.
*
**& for alv -> use fieldcatalog merge.
*  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*    EXPORTING
*     I_PROGRAM_NAME         =
*     I_INTERNAL_TABNAME     =
*      i_structure_name       = 'ZAR_STRUCT_PURCHASE_ORDER'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME             =
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
*    CHANGING
*      ct_fieldcat            = lt_fieldcat
*    EXCEPTIONS
*      inconsistent_interface = 1
*      program_error          = 2
*      OTHERS                 = 3.
*
*IF sy-subrc <> 0.
* Implement suitable error handling here
*ENDIF.
*
*  WRITE : 'X'.
*
*  ls_layout-zebra = 'X'.
*
*  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
*            EXPORTING
*              I_INTERFACE_CHECK              = ' '
*              I_BYPASSING_BUFFER             =
*              I_BUFFER_ACTIVE                = ' '
*              I_CALLBACK_PROGRAM             = ' '
*              I_CALLBACK_PF_STATUS_SET       = ' '
*              I_CALLBACK_USER_COMMAND        = ' '
*              I_STRUCTURE_NAME               =
*              IS_LAYOUT                      = ls_layout
*            IT_FIELDCAT                    = LT_FIELDCAT
*              IT_EXCLUDING                   =
*              IT_SPECIAL_GROUPS              =
* *            IT_SORT                        = lt_sort
*             IT_FILTER                      =
*              IS_SEL_HIDE                    =
*              I_DEFAULT                      = 'X'
*              I_SAVE                         = ' '
*              IS_VARIANT                     =
*              IT_EVENTS                      =
*              IT_EVENT_EXIT                  =
*              IS_PRINT                       =
*              IS_REPREP_ID                   =
*              I_SCREEN_START_COLUMN          = 0
*              I_SCREEN_START_LINE            = 0
*              I_SCREEN_END_COLUMN            = 0
*              I_SCREEN_END_LINE              = 0
*              IR_SALV_LIST_ADAPTER           =
*              IT_EXCEPT_QINFO                =
*              I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
*            IMPORTING
*              E_EXIT_CAUSED_BY_CALLER        =
*              ES_EXIT_CAUSED_BY_USER         =
*    TABLES
*      t_outtab = lt_final
*            EXCEPTIONS
*     PROGRAM_ERROR                  = 1
*     OTHERS   = 2
*    .
*  IF sy-subrc <> 0.
* Implement suitable error handling here
*  ENDIF.
*& for bind
*
*& manually fieldcatalog create.
*  ls_fieldcat-seltext_l = 'Document Number'.
*  ls_fieldcat-fieldname = 'EBELN'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Company Code'.
*  ls_fieldcat-fieldname = 'BUKRS'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Purchase Document Category'.
*  ls_fieldcat-fieldname = 'BSTYP'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Purchase Document Type'.
*  ls_fieldcat-fieldname = 'BSART'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Item Number'.
*  ls_fieldcat-fieldname = 'EBELP'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Material Number'.
*  ls_fieldcat-fieldname = 'MATNR'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Plant'.
*  ls_fieldcat-fieldname = 'WERKS'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*-----sorting-----*
*ls_sort-fieldname = 'Ebeln'.
*ls_sort-down = ABAP_TRUE.
*APPEND ls_sort to lt_sort.
*clear ls_sort.
*
*ls_sort-fieldname = 'Ebeln'.
*ls_sort-up = 'X'.
*APPEND ls_sort to lt_sort.
*clear ls_sort.
*
*
*  ls_layout-zebra = 'X'.
*  ls_layout-colwidth_optimize = 'X'.
*
*  LOOP AT lt_fieldcat INTO ls_fieldcat.
*    IF ls_fieldcat-fieldname = 'ebeln'.
*      ls_fieldcat-seltext_l = 'Document Number'.
*      ls_fieldcat-seltext_s = 'Doc. No.'.
*      ls_fieldcat-seltext_m = 'Document Num'.
*      MODIFY lt_fieldcat FROM ls_fieldcat TRANSPORTING seltext_l seltext_s seltext_m.
*
*    ENDIF.
*  ENDLOOP.
*
*
*  ls_fieldcat-seltext_l = 'Purchasing Document'.
*  ls_fieldcat-fieldname = 'EBELN'.
*  ls_fieldcat-tabname = 'LT_EKKO'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Company Code'.
*  ls_fieldcat-fieldname = 'BUKRS'.
*  ls_fieldcat-tabname = 'LT_EKKO'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Category'.
*  ls_fieldcat-fieldname = 'BSTYP'.
*  ls_fieldcat-tabname = 'LT_EKKO'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Type'.
*  ls_fieldcat-fieldname = 'BSART'.
*  ls_fieldcat-tabname = 'LT_EKKO'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Purchasing Document'.
*  ls_fieldcat-fieldname = 'EBELN'.
*  ls_fieldcat-tabname = 'LT_EKPO'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Item Number'.
*  ls_fieldcat-fieldname = 'EBELP'.
*  ls_fieldcat-tabname = 'LT_EKPO'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'Material Number'.
*  ls_fieldcat-fieldname = 'MATNR'.
*  ls_fieldcat-tabname = 'LT_EKPO'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_fieldcat-seltext_l = 'PLANT'.
*  ls_fieldcat-fieldname = 'WERKS'.
*  ls_fieldcat-tabname = 'LT_EKPO'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*
*  ls_layout-zebra = 'X'.
*
*  ls_key-header01 = 'EBELN'.
*  ls_key-item01 = 'EBELN'.
*
*  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
*    EXPORTING
*      i_interface_check        = ' '
*      i_callback_program       =
*      i_callback_pf_status_set = ' '
*      i_callback_user_command  = ' '
*      is_layout                =
*      it_fieldcat              = lt_fieldcat
*      it_excluding             =
*      it_special_groups        =
*      it_sort                  =
*      it_filter                =
*      is_sel_hide              =
*      i_screen_start_column    = 0
*      i_screen_start_line      = 0
*      i_screen_end_column      = 0
*      i_screen_end_line        = 0
*      i_default                = 'X'
*      i_save                   = ' '
*      is_variant               =
*      it_events                =
*      it_event_exit            =
*      i_tabname_header         = 'LT_EKKO'
*      i_tabname_item           = 'LT_EKPO'
*      i_structure_name_header  =
*      i_structure_name_item    =
*      is_keyinfo               = ls_key
*      is_print                 =
*      is_reprep_id             =
*      i_bypassing_buffer       =
*      i_buffer_active          =
*      ir_salv_hierseq_adapter  =
*      it_except_qinfo          =
*      i_suppress_empty_data    = abap_false
*    IMPORTING
*      e_exit_caused_by_caller  =
*      es_exit_caused_by_user   =
*    TABLES
*      t_outtab_header          = lt_ekko
*      t_outtab_item            = lt_ekpo
*    EXCEPTIONS
*      program_error            = 1
*      OTHERS                   = 2.
*  IF sy-subrc <> 0.
*    implement suitable error handling here
*   endif.
*
*ls_filter-fieldname = 'MATNR'.
*ls_filter-tabname = 'LT_FINAL'.
*ls_filter-sign0 = 'I'.
*ls_filter-optio = 'EQ'.
*ls_filter-valuf_int = 'EWMS4-01'.
*  APPEND ls_filter TO ls_filter.
*  CLEAR ls_filter.
*
*
*    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*      EXPORTING
*       I_INTERFACE_CHECK           = ' '
*       I_BYPASSING_BUFFER          = ' '
*       I_BUFFER_ACTIVE             = ' '
*       I_CALLBACK_PROGRAM          = ' '
*       I_CALLBACK_PF_STATUS_SET    = ' '
*       I_CALLBACK_USER_COMMAND     = ' '
*i_callback_top_of_page      = 'TOP_OF_PAGE'
*       I_CALLBACK_HTML_TOP_OF_PAGE = ' '
*        i_callback_html_end_of_list = 'ZAR_STRUCT_PURCHASE_ORDER'
*       I_STRUCTURE_NAME            =
*       I_BACKGROUND_ID             = ' '
*       I_GRID_TITLE                =
*       I_GRID_SETTINGS             =
*       IS_LAYOUT                   =
*        it_fieldcat                 = lt_fieldcat
*       IT_EXCLUDING                =
*       IT_SPECIAL_GROUPS           =
*      IT_SORT                     =
*       IT_FILTER                   =
*       IS_SEL_HIDE                 =
*       I_DEFAULT                   = 'X'
*       I_SAVE                      = ' '
*       IS_VARIANT                  =
*       IT_EVENTS                   =
*       IT_EVENT_EXIT               =
*       IS_PRINT                    =
*       IS_REPREP_ID                =
*       I_SCREEN_START_COLUMN       = 0
*       I_SCREEN_START_LINE         = 0
*       I_SCREEN_END_COLUMN         = 0
*       I_SCREEN_END_LINE           = 0
*       I_HTML_HEIGHT_TOP           = 0
*       I_HTML_HEIGHT_END           = 0
*       IT_ALV_GRAPHICS             =
*       IT_HYPERLINK                =
*       IT_ADD_FIELDCAT             =
*       IT_EXCEPT_QINFO             =
*       IR_SALV_FULLSCREEN_ADAPTER  =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER     =
*       ES_EXIT_CAUSED_BY_USER      =
*      TABLES
*        t_outtab                    = lt_final
*      EXCEPTIONS
*        program_error               = 1
*        OTHERS                      = 2.
*    IF sy-subrc <> 0.
* Implement suitable error handling here
*    ENDIF.
*
*    TYPES: BEGIN OF ty_vbak,
*             vbeln TYPE vbeln_va,
*             erdat TYPE erdat,
*             erzet TYPE erzet,
*             ernam TYPE ernam,
*             vbtyp TYPE vbtyp,
*           END OF ty_vbak.
*
*    TYPES: BEGIN OF ty_vbap,
*             vbeln TYPE vbeln_va,
*             posnr TYPE posnr_va,
*             matnr TYPE matnr,
*           END OF ty_vbap.
*
*    DATA: lt_vbak TYPE TABLE OF ty_vbak,
*          lt_vbap TYPE TABLE OF ty_vbap.
*
*    DATA: lt_fieldcat TYPE TABLE OF slis_fieldcat_alv.
*    DATA: ls_fieldcat TYPE slis_fieldcat_alv.
*    DATA: ls_key TYPE slis_keyinfo_alv.
*
*
*
*    DATA: lv_vbeln TYPE vbeln_va.
*    SELECT-OPTIONS : s_vbeln FOR lv_vbeln.
*
*START-OF-SELECTION.
*  SELECT vbeln erdat erzet ernam vbtyp
*    FROM vbak
*    INTO TABLE lt_vbak
*    WHERE vbeln IN s_vbeln.
*
*    IF lt_vbak IS NOT INITIAL.
*      SELECT vbeln posnr matnr
*        FROM vbap
*        INTO TABLE lt_vbap
*        FOR ALL ENTRIES IN lt_vbak
*        WHERE vbeln = lt_vbak-vbeln.
*
*
*        CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*          EXPORTING
*           I_PROGRAM_NAME         =
*           I_INTERNAL_TABNAME     =
*            i_structure_name       = 'ZAR_SALES_ORDER_STR'
*           I_CLIENT_NEVER_DISPLAY = 'X'
*           I_INCLNAME             =
*           I_BYPASSING_BUFFER     =
*           I_BUFFER_ACTIVE        =
*          CHANGING
*            ct_fieldcat            = lt_fieldcat
*          EXCEPTIONS
*            inconsistent_interface = 1
*            program_error          = 2
*            OTHERS                 = 3.
*IF sy-subrc <> 0.
* Implement suitable error handling here
*ENDIF.
*
*        ls_fieldcat-seltext_l = 'Sales Document Number'.
*        ls_fieldcat-fieldname = 'VBELN'.
*        ls_fieldcat-tabname = 'LT_VBAK'.
*        APPEND ls_fieldcat TO lt_fieldcat.
*        CLEAR ls_fieldcat.
*
*        ls_fieldcat-seltext_l = 'Creation Date'.
*        ls_fieldcat-fieldname = 'ERDAT'.
*        ls_fieldcat-tabname = 'LT_VBAK'.
*        APPEND ls_fieldcat TO lt_fieldcat.
*        CLEAR ls_fieldcat.
*
*        ls_fieldcat-seltext_l = 'Created On'.
*        ls_fieldcat-fieldname = 'ERZET'.
*        ls_fieldcat-tabname = 'LT_VBAK'.
*        APPEND ls_fieldcat TO lt_fieldcat.
*        CLEAR ls_fieldcat.
*
*        ls_fieldcat-seltext_l = 'Created By'.
*        ls_fieldcat-fieldname = 'ERNAM'.
*        ls_fieldcat-tabname = 'LT_VBAK'.
*        APPEND ls_fieldcat TO lt_fieldcat.
*        CLEAR ls_fieldcat.
*
*        ls_fieldcat-seltext_l = 'Document Category'.
*        ls_fieldcat-fieldname = 'VPTYP'.
*        ls_fieldcat-tabname = 'LT_VBAK'.
*        APPEND ls_fieldcat TO lt_fieldcat.
*        CLEAR ls_fieldcat.
*
*        ls_fieldcat-seltext_l = 'Sales Document Number'.
*        ls_fieldcat-fieldname = 'VBELN'.
*        ls_fieldcat-tabname = 'LT_VBAP'.
*        APPEND ls_fieldcat TO lt_fieldcat.
*        CLEAR ls_fieldcat.
*
*        ls_fieldcat-seltext_l = 'Item Number'.
*        ls_fieldcat-fieldname = 'POSNR'.
*        ls_fieldcat-tabname = 'LT_VBAP'.
*        APPEND ls_fieldcat TO lt_fieldcat.
*        CLEAR ls_fieldcat.
*
*        ls_fieldcat-seltext_l = 'Material Number'.
*        ls_fieldcat-fieldname = 'MATNR'.
*        ls_fieldcat-tabname = 'LT_VBAP'.
*        APPEND ls_fieldcat TO lt_fieldcat.
*        CLEAR ls_fieldcat.
*
*        ls_key-header01 = 'VBELN'.
*        ls_key-item01 = 'VBELN'.
*
*
*        CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
*          EXPORTING
*            i_interface_check        = ' '
*    i_callback_program       = sy-rapid "'ZAR_REUSE_ALV_LIST_DISPLAY'.
*            i_callback_pf_status_set = ' '
*            i_callback_user_command  = ' '
*            is_layout                =
*            it_fieldcat              = lt_fieldcat
*            it_excluding             =
*            it_special_groups        =
*            it_sort                  =
*            it_filter                =
*            is_sel_hide              =
*            i_screen_start_column    = 0
*            i_screen_start_line      = 0
*            i_screen_end_column      = 0
*            i_screen_end_line        = 0
*            i_default                = 'X'
*            i_save                   = ' '
*            is_variant               =
*            it_events                =
*            it_event_exit            =
*            i_tabname_header         = 'LT_VBAK'
*            i_tabname_item           = 'LT_VBAP'
*            i_structure_name_header  =
*            i_structure_name_item    =
*            is_keyinfo               = ls_key
*            is_print                 =
*            is_reprep_id             =
*            i_bypassing_buffer       =
*            i_buffer_active          =
*            ir_salv_hierseq_adapter  =
*            it_except_qinfo          =
*            i_suppress_empty_data    = abap_false
*          IMPORTING
*            e_exit_caused_by_caller  =
*            es_exit_caused_by_user   =
*          TABLES
*            t_outtab_header          = lt_vbak
*            t_outtab_item            = lt_vbap
*          EXCEPTIONS
*            program_error            = 1
*            OTHERS                   = 2.
*        IF sy-subrc <> 0.
*          implement suitable error handling here
*             endif.
*
*
*        ENDIF.
*
*REPORT zar_reuse_alv_list_display.
*
*TYPE-POOLS: slis.
*
* Data
*DATA: lt_ekko TYPE TABLE OF ekko.
*
* ALV structures
*DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
*      ls_fieldcat TYPE slis_fieldcat_alv,
*      ls_layout   TYPE slis_layout_alv,
*      lt_sort     TYPE slis_t_sortinfo_alv,
*      ls_sort     TYPE slis_sortinfo_alv,
*      lt_filter   TYPE slis_t_filter_alv,
*      ls_filter   TYPE slis_filter_alv.
*
* Fetch data
*SELECT ebeln bukrs bstyp bsart
*  INTO TABLE lt_ekko
*  FROM ekko
*  UP TO 50 ROWS.
*
*--------------------------
* FIELD CATALOG
*--------------------------
*ls_fieldcat-fieldname = 'EBELN'.
*ls_fieldcat-seltext_l = 'PO Number'.
*APPEND ls_fieldcat TO lt_fieldcat.
*CLEAR ls_fieldcat.
*
*ls_fieldcat-fieldname = 'BUKRS'.
*ls_fieldcat-seltext_l = 'Company Code'.
*APPEND ls_fieldcat TO lt_fieldcat.
*CLEAR ls_fieldcat.
*
*--------------------------
* SORTING (Ascending)
*--------------------------
*ls_sort-fieldname = 'EBELN'.
*ls_sort-up = 'X'.          "Ascending
*APPEND ls_sort TO lt_sort.
*CLEAR ls_sort.
*
*--------------------------
* FILTERING
*--------------------------
*ls_filter-fieldname = 'BUKRS'.   "Filter column
*ls_filter-sign      = 'I'.       "Include
*ls_filter-option    = 'EQ'.      "Equals
*ls_filter-low       = '1000'.    "Company code
*APPEND ls_filter TO lt_filter.
*CLEAR ls_filter.
*
*--------------------------
* LAYOUT
*--------------------------
*ls_layout-zebra = 'X'.
*
*--------------------------
* ALV DISPLAY
*--------------------------
*CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*  EXPORTING
*    i_callback_program = sy-repid
*    is_layout          = ls_layout
*    it_fieldcat        = lt_fieldcat
*    it_sort            = lt_sort
*    it_filter          = lt_filter
*  TABLES
*    t_outtab           = lt_ekko
*  EXCEPTIONS
*    program_error      = 1
*    OTHERS             = 2.
*
*
*---TOP OF PAGE---***
*WRITE SUB-ROUTINE.
*FORM top_of_page.
*
*CLEAR lt_commentary.
*
*ls_commentary-typ = 'H'.
*ls_commentary-info = 'Purchase Order Display'.
*ls_commentary-key = 'Rajesh Kumar'.
*APPEND ls_commentary TO lt_commentary.
*
*CLEAR ls_commentary.
*
*ls_commentary-typ = ''.
*
*CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
*  EXPORTING
*    it_list_commentary = lt_commentary
*   I_LOGO             =
*   I_END_OF_LIST_GRID =
*   I_ALV_FORM         =
*  .
*
*ENDFORM.

*REPORT z_reuse_alv_grid.
report ZAR_REUSE_ALV_LIST_DISPLAY.

*REPORT z_hierarchical_alv.

TYPE-POOLS: slis.

DATA: lt_ekko TYPE TABLE OF ekko,
      lt_ekpo TYPE TABLE OF ekpo,
      lt_fieldcat TYPE slis_t_fieldcat_alv,
      ls_key TYPE slis_keyinfo_alv.

SELECT * INTO TABLE lt_ekko FROM ekko UP TO 10 ROWS.

IF lt_ekko IS NOT INITIAL.
  SELECT * INTO TABLE lt_ekpo FROM ekpo
    FOR ALL ENTRIES IN lt_ekko
    WHERE ebeln = lt_ekko-ebeln.
ENDIF.

ls_key-header01 = 'EBELN'.
ls_key-item01   = 'EBELN'.

CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
  EXPORTING
    i_callback_program = sy-repid
    is_keyinfo         = ls_key
    i_tabname_header   = 'LT_EKKO'
    i_tabname_item     = 'LT_EKPO'
  TABLES
    t_outtab_header    = lt_ekko
    t_outtab_item      = lt_ekpo.

*REPORT z_po_header_item.

*REPORT z_hierarchical_alv.
*
*TYPE-POOLS: slis.
*
*DATA: lt_ekko TYPE TABLE OF ekko,
*      lt_ekpo TYPE TABLE OF ekpo,
*      lt_fieldcat TYPE slis_t_fieldcat_alv,
*      ls_key TYPE slis_keyinfo_alv.
*
*SELECT * INTO TABLE lt_ekko FROM ekko UP TO 10 ROWS.
*
*IF lt_ekko IS NOT INITIAL.
*  SELECT * INTO TABLE lt_ekpo FROM ekpo
*    FOR ALL ENTRIES IN lt_ekko
*    WHERE ebeln = lt_ekko-ebeln.
*ENDIF.
*
*ls_key-header01 = 'EBELN'.
*ls_key-item01   = 'EBELN'.
*
*CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
*  EXPORTING
*    i_callback_program = sy-repid
*    is_keyinfo         = ls_key
*    i_tabname_header   = 'LT_EKKO'
*    i_tabname_item     = 'LT_EKPO'
*  TABLES
*    t_outtab_header    = lt_ekko
*    t_outtab_item      = lt_ekpo.

*3. HEADER + ITEM (JOIN LOGIC with LOOP)
*TYPES: BEGIN OF ty_final,
*         ebeln TYPE ebeln,
*         bukrs TYPE bukrs,
*         ebelp TYPE ebelp,
*         matnr TYPE matnr,
*       END OF ty_final.
*
*DATA: lt_ekko  TYPE TABLE OF ekko,
*      lt_ekpo  TYPE TABLE OF ekpo,
*      lt_final TYPE TABLE OF ty_final.
*
*SELECT * FROM ekko INTO TABLE lt_ekko UP TO 10 ROWS.
*
*IF lt_ekko IS NOT INITIAL.
*  SELECT * FROM ekpo INTO TABLE lt_ekpo
*    FOR ALL ENTRIES IN lt_ekko
*    WHERE ebeln = lt_ekko-ebeln.
*ENDIF.
*
*LOOP AT lt_ekpo INTO DATA(ls_ekpo).
*  READ TABLE lt_ekko INTO DATA(ls_ekko)
*       WITH KEY ebeln = ls_ekpo-ebeln.
*
*  IF sy-subrc = 0.
*    APPEND VALUE ty_final(
*      ebeln = ls_ekko-ebeln
*      bukrs = ls_ekko-bukrs
*      ebelp = ls_ekpo-ebelp
*      matnr = ls_ekpo-matnr ) TO lt_final.
*  ENDIF.
*ENDLOOP.
*
*cl_demo_output=>display( lt_final ).

*2. REUSE ALV GRID (Classic ALV)
*TYPE-POOLS: slis.
*
*DATA: lt_ekko TYPE TABLE OF ekko,
*      lt_fieldcat TYPE slis_t_fieldcat_alv,
*      ls_fieldcat TYPE slis_fieldcat_alv,
*      ls_layout TYPE slis_layout_alv.
*
*SELECT ebeln bukrs bstyp bsart
*  INTO TABLE lt_ekko
*  FROM ekko
*  UP TO 50 ROWS.
*
** Field Catalog
*ls_fieldcat-fieldname = 'EBELN'.
*ls_fieldcat-seltext_l = 'PO Number'.
*APPEND ls_fieldcat TO lt_fieldcat.
*CLEAR ls_fieldcat.
*
*ls_fieldcat-fieldname = 'BUKRS'.
*ls_fieldcat-seltext_l = 'Company Code'.
*APPEND ls_fieldcat TO lt_fieldcat.
*CLEAR ls_fieldcat.
*
** Layout
*ls_layout-zebra = 'X'.
*
*CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*  EXPORTING
*    i_callback_program = sy-repid
*    is_layout          = ls_layout
*    it_fieldcat        = lt_fieldcat
*  TABLES
*    t_outtab           = lt_ekko.
