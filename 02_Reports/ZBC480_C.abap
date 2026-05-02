*&---------------------------------------------------------------------*
*& Report ZBC480_C
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc480_c.

TABLES: kna1.

DATA : itab_kna1 TYPE ztt_kna1.
gs_out type sfpoutputparams.

SELECT-OPTIONS : s_kunnr FOR kna1-kunnr.

gs_out-nodialog = space.
gs_out-preview = 'X'.

CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    ie_outputparams       = gs_out
* EXCEPTIONS
*   CANCEL                = 1
*   USAGE_ERROR           = 2
*   SYSTEM_ERROR          = 3
*   INTERNAL_ERROR        = 4
*   OTHERS                = 5
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
