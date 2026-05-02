*&---------------------------------------------------------------------*
*& Report Z_SMRUTI_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_smruti_report.

PARAMETERS: p_ebeln TYPE ekpo-ebeln.

TYPES: BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         txz01 TYPE ekpo-txz01,
       END OF ty_ekpo.

DATA: lt_ekpo TYPE TABLE OF ty_ekpo,
      ls_ekpo TYPE ty_ekpo.

*SELECT-OPTIONS: s_ebeln FOR ls_ekpo-ebeln.

*1. Fetch all items of a PO
SELECT ebeln ebelp matnr
  FROM ekpo
  INTO TABLE lt_ekpo
  WHERE menge > 20.

BREAK-POINT.

WRITE: / 'PO Number:', ls_ekpo-ebeln,
       / 'Item No  :', ls_ekpo-ebelp,
       / 'Text     :', ls_ekpo-txz01.
