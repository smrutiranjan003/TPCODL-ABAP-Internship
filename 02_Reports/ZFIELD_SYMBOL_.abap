*&---------------------------------------------------------------------*
*& Report ZFIELD_SYMBOL_
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfield_symbol_.

DATA : lv_name(30) TYPE c VALUE 'AKASH DASH'.

*&1. Define the field symbol
FIELD-SYMBOLS : <fs_name> TYPE c.

*&2. Assign the variable to the field symbol.
ASSIGN lv_name TO <fs_name>.

*&3. Check if the assigning is done or not.
IF <fs_name> IS ASSIGNED.

  <fs_name> = 'Rahul Jena'.
  WRITE :/ lv_name.
  WRITE :/ <fs_name>.


ENDIF.
