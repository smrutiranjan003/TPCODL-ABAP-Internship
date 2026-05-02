*&---------------------------------------------------------------------*
*& Report ZAR_DEMO_ALV_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zar_demo_alv_report.

TYPE-POOLS: slis.

TABLES: vbak.

*----------------------*
* Selection Screen
*----------------------*
PARAMETERS: p_vbeln TYPE vbak-vbeln.

*----------------------*
* Data Declarations
*----------------------*
DATA: lt_vbak     TYPE TABLE OF vbak,
      lt_fieldcat TYPE slis_t_fieldcat_alv,
      ls_layout   TYPE slis_layout_alv,
      lt_sort     TYPE slis_t_sortinfo_alv,
      ls_sort     TYPE slis_sortinfo_alv,
      lt_toolbar  TYPE slis_t_extab. "Toolbar table

*----------------------*
* INITIALIZATION
*----------------------*
INITIALIZATION.
*  p_vbeln = '4900000014'.

*----------------------*
* F4 Help
*----------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vbeln.
  PERFORM f4_help_vbeln.

*----------------------*
* Start Selection
*----------------------*
START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM build_fieldcat.
  PERFORM build_layout.
  PERFORM build_sort.
  PERFORM display_alv.

*----------------------*
* Fetch Data
*----------------------*
FORM get_data.
  SELECT * FROM vbak
    INTO TABLE lt_vbak
    UP TO 20 ROWS.
ENDFORM.

*----------------------*
* F4 Help Logic
*----------------------*
FORM f4_help_vbeln.

  TYPES: BEGIN OF ty_vbak,
           vbeln TYPE  vbak-vbeln,
         END OF ty_vbak.

  DATA: lt_values TYPE TABLE OF ty_vbak,
        lt_return TYPE TABLE OF ddshretval.

  SELECT vbeln FROM vbak INTO TABLE lt_values UP TO 20 ROWS.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'VBELN'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'P_VBELN'
      value_org       = 'S'
      multiple_choice = 'X'
    TABLES
      value_tab       = lt_values
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*----------------------*
* Field Catalog
*----------------------*
FORM build_fieldcat.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'LT_VBAK'
      i_structure_name       = 'VBAK'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME             =
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*----------------------*
* Layout
*----------------------*
FORM build_layout.
  ls_layout-zebra      = 'X'.  " Alternate row colors
  ls_layout-colwidth_optimize = 'X'.  " Auto column width optimization
* ls_layout-grid_title = 'ALV with Toolbar'.
ENDFORM.
*----------------------*
* Sorting
*----------------------*
FORM build_sort.

  ls_sort-fieldname = 'ERDAT'.  " Sort by created date
  ls_sort-up        = 'X'.      " Ascending
  APPEND ls_sort TO lt_sort.

ENDFORM.

*----------------------*
* Display ALV
*----------------------*
FORM display_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid "system varriable --> ZAR_DEMO_ALV_REPORT
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      is_layout          = ls_layout
      it_fieldcat        = lt_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
      it_sort            = lt_sort
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = lt_vbak.
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
  .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*----------------------*
* Set PF Status (Toolbar)
*----------------------*
FORM set_pf_status USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'ZALV_STATUS'.

ENDFORM.

*----------------------*
* User Command
*----------------------*
FORM user_command USING r_ucomm     LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  CASE r_ucomm.

    WHEN 'BTN1'.
      MESSAGE 'Custom Button 1 Pressed' TYPE 'I'.

    WHEN 'BTN2'.
      MESSAGE 'Custom Button 2 Pressed' TYPE 'I'.

    WHEN '&IC1'.
      READ TABLE lt_vbak INTO DATA(ls_vbak) INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.
        MESSAGE |Clicked: { ls_vbak-vbeln }| TYPE 'I'.
      ENDIF.

    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.

ENDFORM.
