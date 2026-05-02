*&---------------------------------------------------------------------*
*& Report ZAR_TYPES_OF_INTERNAL_TABLES (Fixed & Extended)
*&---------------------------------------------------------------------*
REPORT zar_types_of_internal_tables.

*---------------------------------------------------------------------*
** Structure Definition
**---------------------------------------------------------------------*
TYPES : BEGIN OF ty_mara,
          blanz TYPE i,
          mtart TYPE string,
        END OF ty_mara.

***---------------------------------------------------------------------*
*** Standard Internal Table
***---------------------------------------------------------------------*
**DATA : lt_std TYPE STANDARD TABLE OF ty_mara,
**       ls_mara TYPE ty_mara.
**---------------------------------------------------------------------*
** Sorted Internal Table
**---------------------------------------------------------------------*
**DATA : lt_sorted TYPE SORTED TABLE OF ty_mara WITH UNIQUE KEY blanz,
**ls_mara   type ty_mara.
*
**DATA : lt_sorted2 TYPE SORTED TABLE OF ty_mara WITH NON-UNIQUE SORTED KEY blanz.
*
***---------------------------------------------------------------------*
DATA : lt_hashed TYPE HASHED TABLE OF ty_mara
                    WITH UNIQUE KEY blanz,
       ls_mara   TYPE ty_mara.
**---------------------------------------------------------------------*
** Insert Data (NOT APPEND)
**---------------------------------------------------------------------*
*ls_mara-blanz = 101.
*ls_mara-mtart = 'Liam'.
*INSERT ls_mara INTO TABLE lt_sorted.
*CLEAR ls_mara.
*
*ls_mara-blanz = 122.
*ls_mara-mtart = 'Leo'.
*INSERT ls_mara INTO TABLE lt_sorted.
*CLEAR ls_mara.
*
*ls_mara-blanz = 103.
*ls_mara-mtart = 'Ryan'.
*INSERT ls_mara INTO TABLE lt_sorted.
*CLEAR ls_mara.
*
*ls_mara-blanz = 135.
*ls_mara-mtart = 'Alex'.
*INSERT ls_mara INTO TABLE lt_sorted.
*CLEAR ls_mara.
*
*ls_mara-blanz = 117.
*ls_mara-mtart = 'Lucas'.
*INSERT ls_mara INTO TABLE lt_sorted.
*CLEAR ls_mara.
*
*ls_mara-blanz = 109.
*ls_mara-mtart = 'Owen'.
*INSERT ls_mara INTO TABLE lt_sorted.
*CLEAR ls_mara.
**---------------------------------------------------------------------*
**** Fill Standard Table
*
**ls_mara-blanz = 101.
**ls_mara-mtart = 'Liam'.
**APPEND ls_mara TO lt_std.
**CLEAR ls_mara.
**
**ls_mara-blanz = 122.
**ls_mara-mtart = 'Leo'.
**APPEND ls_mara TO lt_std.
**CLEAR ls_mara.
**
**ls_mara-blanz = 103.
**ls_mara-mtart = 'Ryan'.
**APPEND ls_mara TO lt_std.
**CLEAR ls_mara.
**
**ls_mara-blanz = 135.
**ls_mara-mtart = 'Alex'.
**APPEND ls_mara TO lt_std.
**CLEAR ls_mara.
**
**ls_mara-blanz = 117.
**ls_mara-mtart = 'Lucas'.
**APPEND ls_mara TO lt_std.
**CLEAR ls_mara.
**
**ls_mara-blanz = 109.
**ls_mara-mtart = 'Owen'.
**APPEND ls_mara TO lt_std.
**CLEAR ls_mara.
*
***---------------------------------------------------------------------*
*** Output Standard Table
***---------------------------------------------------------------------*
**WRITE: / '--- Standard Internal Table ---'.
**LOOP AT lt_std INTO ls_mara.
**  WRITE: / ls_mara-blanz, ls_mara-mtart.
**ENDLOOP.
*
***---------------------------------------------------------------------*
*** Sorted Internal Table
***---------------------------------------------------------------------*
**DATA : lt_sorted TYPE SORTED TABLE OF ty_mara
**                     WITH UNIQUE KEY blanz.
**
*** Insert into Sorted Table
**ls_mara-blanz = 300.
**ls_mara-mtart = 'sorted1'.
**INSERT ls_mara INTO TABLE lt_sorted.
**
**ls_mara-blanz = 200.
**ls_mara-mtart = 'sorted2'.
**INSERT ls_mara INTO TABLE lt_sorted.
**
**ls_mara-blanz = 250.
**ls_mara-mtart = 'sorted3'.
**INSERT ls_mara INTO TABLE lt_sorted.
***
***---------------------------------------------------------------------*
** Explicit Sorting of Standard Table
**---------------------------------------------------------------------*
**SORT lt_std BY blanz.
**
***---------------------------------------------------------------------*
*** Output Standard Table (After Sorting)
***---------------------------------------------------------------------*
**WRITE: / '--- Standard Internal Table (Sorted) ---'.
**LOOP AT lt_std INTO ls_mara.
**  WRITE: / ls_mara-blanz, ls_mara-mtart.
**ENDLOOP.
***---------------------------------------------------------------------*
** Output Sorted Table (auto sorted by key)
**---------------------------------------------------------------------*
*WRITE: / '--- Sorted Internal Table ---'.
*LOOP AT lt_sorted INTO ls_mara.
*  WRITE: / ls_mara-blanz, ls_mara-mtart.
*ENDLOOP.
*
*
**READ TABLE lt_std INTO ls_mara INDEX 4.
**IF sy-subrc = 0.
**  WRITE: / ls_mara-blanz, ls_mara-mtart.
**ENDIF.
**---------------------------------------------------------------------*
** Read using KEY (NO BINARY SEARCH)
**---------------------------------------------------------------------*
*READ TABLE lt_sorted INTO ls_mara WITH KEY blanz = 109.
*IF sy-subrc = 0.
*  WRITE: / 'Found:', ls_mara-blanz, ls_mara-mtart.
*ENDIF.
**---------------------------------------------------------------------*
** Hashed Internal Table
**---------------------------------------------------------------------*
*DATA : lt_hashed TYPE HASHED TABLE OF ty_mara
*                    WITH UNIQUE KEY blanz.

* Insert into Hashed Table
ls_mara-blanz = 1.
ls_mara-mtart = 'Harsh Dubey'.
INSERT ls_mara INTO TABLE lt_hashed.

ls_mara-blanz = 3.
ls_mara-mtart = 'Hash Verma'.
INSERT ls_mara INTO TABLE lt_hashed.

ls_mara-blanz = 4.
ls_mara-mtart = 'Hashit Sharma'.
INSERT ls_mara INTO TABLE lt_hashed.

ls_mara-blanz = 2.
ls_mara-mtart = 'Hashit Rana'.
INSERT ls_mara INTO TABLE lt_hashed.

*---------------------------------------------------------------------*
* Read Hashed Table (fast access using key)
*---------------------------------------------------------------------*
WRITE: / '--- Hashed Internal Table ---'.

READ TABLE lt_hashed INTO ls_mara WITH KEY blanz = 2.
IF sy-subrc eq 0.
  WRITE: / 'Found:', ls_mara-blanz, ls_mara-mtart.
ELSE.
  WRITE: / 'Record not found'.
ENDIF.
