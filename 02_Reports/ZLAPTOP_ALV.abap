*&---------------------------------------------------------------------*
*& REPORT ZLAPTOP_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlaptop_alv.

TYPE-POOLS: slis.

TABLES: zpurchase_itm.

*---------------------------------------------------------------------*
* Selection Screen
*---------------------------------------------------------------------*

SELECT-OPTIONS: s_ser  FOR zpurchase_itm-serial_no,
                s_bill FOR zpurchase_itm-vendor_bill_no.

*PARAMETERS: p_ser  TYPE zpurchase_itm-serial_no,
*            p_bill TYPE zpurchase_itm-vendor_bill_no.

*---------------------------------------------------------------------*
* Internal Tables
*---------------------------------------------------------------------*
DATA: it_pur_itm TYPE TABLE OF zpurchase_itm,
      it_pur_hdr TYPE TABLE OF zpurchase_hdr,
      it_inv     TYPE TABLE OF zinventory.

*TYPES: BEGIN OF ty_hdr,
*         vendor_bill_no TYPE zpurchase_hdr-vendor_bill_no,
*         purchase_date   TYPE zpurchase_hdr-purchase_date,
*       END OF ty_hdr.
*
*DATA: it_pur_hdr TYPE TABLE OF ty_hdr.
*---------------------------------------------------------------------*
* Final Structure
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_final,
         serial_no   TYPE zpurchase_itm-serial_no,
         ven_bill_no TYPE zpurchase_itm-vendor_bill_no,
         brand       TYPE zpurchase_itm-brand,
         created_on  TYPE zpurchase_hdr-purchase_date,
         matnr       TYPE zinventory-matnr,
         status      TYPE zinventory-status,
       END OF ty_final.

DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.

*---------------------------------------------------------------------*
* ALV
*---------------------------------------------------------------------*
DATA: it_fcat   TYPE slis_t_fieldcat_alv,
      wa_fcat   TYPE slis_fieldcat_alv,
      wa_layout TYPE slis_layout_alv.
**

*---------------------------------------------------------------------*
* STEP 1: Base data (Purchase Item)
*---------------------------------------------------------------------*
 SELECT serial_no
         vendor_bill_no
         brand
    INTO TABLE it_pur_itm
    FROM zpurchase_itm
    WHERE serial_no     IN S_ser
       OR vendor_bill_no IN S_bill.

  IF it_pur_itm IS INITIAL.
    WRITE: 'No data found'.
    EXIT.
  ENDIF.

*---------------------------------------------------------------------*
* STEP 2: Header data
*---------------------------------------------------------------------*
  SELECT vendor_bill_no
*         purchase_date
    INTO TABLE it_pur_hdr
    FROM zpurchase_hdr
    FOR ALL ENTRIES IN it_pur_itm
    WHERE vendor_bill_no = it_pur_itm-vendor_bill_no.

*---------------------------------------------------------------------*
* STEP 3: Inventory data
*---------------------------------------------------------------------*
  SELECT serial_no
         matnr
         status
    INTO TABLE it_inv
    FROM zinventory
    FOR ALL ENTRIES IN it_pur_itm
    WHERE serial_no = it_pur_itm-serial_no.


*---------------------------------------------------------------------*
* STEP 4: Merge logic
*---------------------------------------------------------------------*
  LOOP AT it_pur_itm INTO DATA(wa_itm).

    CLEAR wa_final.

    wa_final-serial_no   = wa_itm-serial_no.
    wa_final-ven_bill_no = wa_itm-vendor_bill_no.
    wa_final-brand       = wa_itm-brand.

    READ TABLE it_pur_hdr INTO DATA(wa_hdr)
      WITH KEY vendor_bill_no = wa_itm-vendor_bill_no.

    IF sy-subrc = 0.
      wa_final-created_on = wa_hdr-purchase_date.
    ENDIF.

    READ TABLE it_inv INTO DATA(wa_inv)
      WITH KEY serial_no = wa_itm-serial_no.

    IF sy-subrc = 0.
      wa_final-matnr  = wa_inv-matnr.
      wa_final-status = wa_inv-status.
    ENDIF.

    APPEND wa_final TO it_final.

  ENDLOOP.
***---------------------------------------------------------------------*
*** Step 2: FOR ALL ENTRIES
***---------------------------------------------------------------------*
**IF it_pur_itm IS NOT INITIAL.
**
**  SELECT * INTO TABLE it_pur_hdr
**    FROM zpurchase_hdr
**    FOR ALL ENTRIES IN it_pur_itm
**    WHERE vendor_bill_no = it_pur_itm-vendor_bill_no.
**
**  SELECT * INTO TABLE it_inv
**    FROM zinventory
**    FOR ALL ENTRIES IN it_pur_itm
**    WHERE serial_no = it_pur_itm-serial_no.
**
**ENDIF.
**
***---------------------------------------------------------------------*
*** Processing
***---------------------------------------------------------------------*
**LOOP AT it_pur_itm INTO DATA(wa_itm).
**
**  CLEAR wa_final.
**
**  wa_final-serial_no   = wa_itm-serial_no.
**  wa_final-ven_bill_no = wa_itm-vendor_bill_no.
**  wa_final-brand       = wa_itm-brand.
**
**  READ TABLE it_pur_hdr INTO DATA(wa_hdr)
**    WITH KEY vendor_bill_no = wa_itm-vendor_bill_no.
**
**  IF sy-subrc = 0.
**    wa_final-created_on = wa_hdr-purchase_date.
**  ENDIF.
**
**  READ TABLE it_inv INTO DATA(wa_inv)
**    WITH KEY serial_no = wa_itm-serial_no.
**
**  IF sy-subrc = 0.
**    wa_final-matnr  = wa_inv-matnr.
**    wa_final-status = wa_inv-status.
**  ENDIF.
**
**  APPEND wa_final TO it_final.
**
**ENDLOOP.
*
START-OF-SELECTION.
**---------------------------------------------------------------------*
** INNER JOIN
**---------------------------------------------------------------------*
IF s_ser IS NOT INITIAL.

  SELECT a~serial_no,
         a~vendor_bill_no AS ven_bill_no,
         a~brand,
         b~purchase_date  AS created_on,
         c~matnr,
         c~status
    INTO TABLE @it_final
    FROM zpurchase_itm AS a
    INNER JOIN zpurchase_hdr AS b
      ON a~vendor_bill_no = b~vendor_bill_no
    INNER JOIN zinventory AS c
      ON a~serial_no = c~serial_no
    WHERE a~vendor_bill_no IN @s_bill.


  IF s_ser IS NOT INITIAL.
    DELETE it_final WHERE serial_no NOT IN s_ser.
  ENDIF.

ENDIF.
**IF s_ser[] IS NOT INITIAL OR s_bill[] IS NOT INITIAL.
**
**   Case 1: Bill is entered
**  IF s_bill[] IS NOT INITIAL.
**
**    SELECT a~serial_no,
**           a~vendor_bill_no AS ven_bill_no,
**           a~brand,
**           b~purchase_date  AS created_on,
**           c~matnr,
**           c~status
**      INTO TABLE @it_final
**      FROM zpurchase_itm AS a
**      INNER JOIN zpurchase_hdr AS b
**        ON a~vendor_bill_no = b~vendor_bill_no
**      INNER JOIN zinventory AS c
**        ON a~serial_no = c~serial_no
**      WHERE a~vendor_bill_no IN @s_bill.
**
**  ELSE.
**
**     Case 2: No bill # fetch all
**    SELECT a~serial_no,
**           a~vendor_bill_no AS ven_bill_no,
**           a~brand,
**           b~purchase_date  AS created_on,
**           c~matnr,
**           c~status
**      INTO TABLE @it_final
**      FROM zpurchase_itm AS a
**      INNER JOIN zpurchase_hdr AS b
**        ON a~vendor_bill_no = b~vendor_bill_no
**      INNER JOIN zinventory AS c
**        ON a~serial_no = c~serial_no.
**
**  ENDIF.
**
**   Filter by Serial
**  IF s_ser[] IS NOT INITIAL.
**    DELETE it_final WHERE serial_no NOT IN s_ser.
**  ENDIF.
**
**ENDIF.
*
**ENDIF.
*START-OF-SELECTION.
*
* SELECT
*    a~serial_no,
*    a~vendor_bill_no,
*    a~brand,
*    b~purchase_date,
*    c~matnr,
*    c~status
*  INTO TABLE @it_final
*  FROM zpurchase_itm AS a
*  INNER JOIN zpurchase_hdr AS b
*    ON a~vendor_bill_no = b~vendor_bill_no
*  INNER JOIN zinventory AS c
*    ON a~serial_no = c~serial_no
*  WHERE a~serial_no IN @s_ser
*    AND a~vendor_bill_no IN @s_bill.
*
*  IF it_final IS INITIAL.
*    WRITE: 'No data found'.
*    EXIT.
*  ENDIF.
***---------------------------------------------------------------------*
*** ALV
***---------------------------------------------------------------------*
***DEFINE add_fcat.
**  CLEAR wa_fcat.
**  wa_fcat-fieldname = &1.
**  wa_fcat-seltext_m = &2.
**  APPEND wa_fcat TO it_fcat.
**END-OF-DEFINITION.
*
**add_fcat 'SERIAL_NO'   'Serial No' "With macro
  CLEAR wa_fcat.
  wa_fcat-fieldname = 'SERIAL_NO'.
  wa_fcat-seltext_m = 'Serial No'.
  APPEND wa_fcat TO it_fcat.

*add_fcat 'VEN_BILL_NO' 'Bill No'.
  CLEAR wa_fcat.
  wa_fcat-fieldname = 'VEN_BILL_NO'.
  wa_fcat-seltext_m = 'Bill No'.
  APPEND wa_fcat TO it_fcat.

*add_fcat 'BRAND'       'Brand'.
  CLEAR wa_fcat.
  wa_fcat-fieldname = 'BRAND'.
  wa_fcat-seltext_m = 'Brand'.
  APPEND wa_fcat TO it_fcat.

*add_fcat 'CREATED_ON'  'Created On'.
  CLEAR wa_fcat.
  wa_fcat-fieldname = 'CREATED_ON'.
  wa_fcat-seltext_m = 'Created On'.
  APPEND wa_fcat TO it_fcat.

*add_fcat 'MATNR'       'Material No'.
  CLEAR wa_fcat.
  wa_fcat-fieldname = 'MATNR'.
  wa_fcat-seltext_m = 'Material No'.
  APPEND wa_fcat TO it_fcat.

*add_fcat 'STATUS'      'Status'.
  CLEAR wa_fcat.
  wa_fcat-fieldname = 'STATUS'.
  wa_fcat-seltext_m = 'Status'.
  APPEND wa_fcat TO it_fcat.

  wa_layout-zebra = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
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
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
