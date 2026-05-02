*&---------------------------------------------------------------------*
*& REPORT ZDRINK_CLASSICAL_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdrink_classical_report.

*---------------------------------------------------------------------*
* Step 1: Define structure (like one row of data)
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_drink,
         drink_code  TYPE zdrink_detail-drink_code,
         drink_type  TYPE zdrink_detail-drink_type,
         drink_group TYPE zdrink_detail-drink_group,
         created_by  TYPE zdrink_detail-created_by,
       END OF ty_drink.

*---------------------------------------------------------------------*
* Step 2: Internal table & work area
*---------------------------------------------------------------------*
DATA: lt_drinks TYPE TABLE OF ty_drink,
      ls_drink  TYPE ty_drink.

*---------------------------------------------------------------------*
* Step 3: Selection Screen
*---------------------------------------------------------------------*
PARAMETERS: p_code TYPE zdrink_detail-drink_code.

*---------------------------------------------------------------------*
* Step 4: Fetch Data
*---------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT drink_code drink_type drink_group created_by
    FROM zdrink_detail
    INTO TABLE lt_drinks
    WHERE drink_code = p_code.

*---------------------------------------------------------------------*
* Step 5: Display Header
*---------------------------------------------------------------------*
  WRITE: / 'Drink Code', 15 'Drink Type', 35 'Group', 50 'Created By'.
  WRITE: / '-------------------------------------------------------------'.

*---------------------------------------------------------------------*
* Step 6: Loop & Display Data
*---------------------------------------------------------------------*
  LOOP AT lt_drinks INTO ls_drink.

    WRITE: / ls_drink-drink_code,
             15 ls_drink-drink_type,
             35 ls_drink-drink_group,
             50 ls_drink-created_by.

  ENDLOOP.

*---------------------------------------------------------------------*
* Step 7: No Data Handling
*---------------------------------------------------------------------*
  IF lt_drinks IS INITIAL.
    WRITE: / 'No data found'.
  ENDIF.
