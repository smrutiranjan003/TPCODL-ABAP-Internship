*&---------------------------------------------------------------------*
*& Report Z_STRING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_STRING.

DATA : LV_STRING1 type string value '                 Welcome',
       LV_STRING2 type string value 'To',
       LV_STRING3 type string value '       SAP.'.
DATA : LV_LENGTH type i.
DATA : LV_OUTPUT type string.
CONCATENATE LV_STRING1 LV_STRING2 LV_STRING3 into LV_OUTPUT SEPARATED BY SPACE.
LV_LENGTH = STRLEN( LV_OUTPUT ).

WRITE :/ LV_OUTPUT.
WRITE :/ LV_LENGTH.

CONDENSE LV_OUTPUT.
LV_LENGTH = STRLEN( LV_OUTPUT ).
WRITE :/ LV_OUTPUT.
WRITE :/ LV_LENGTH.

CONDENSE LV_OUTPUT NO-GAPS.
LV_LENGTH = STRLEN( LV_OUTPUT ).
WRITE :/ LV_OUTPUT.
WRITE :/ LV_LENGTH.
