*&---------------------------------------------------------------------*
*& Report ZR_COURSE_REG_SMART
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_course_reg_smart.

TABLES:
  zstudentt,
  zstudent_address,
  zregistration,
  zcourse,
  zfeedetails.

DATA:
  gt_final TYPE TABLE OF zst_smart,
  gs_final TYPE zst_smart.

DATA:
  gv_fm_name TYPE rs38l_fnam.

PARAMETERS:
  p_reg TYPE zde_reg_id.

START-OF-SELECTION.

  SELECT a~student_id
         a~name
         a~department
         a~academic_year
         b~parent_name
         b~address
         b~parent_mobile_no
         b~parent_email_id
         c~reg_id
         c~course_id
         c~reg_date
         d~course_name
         d~faculty
         e~term_no
         e~item_no
         e~fee_amount

    FROM zstudentt AS a

    INNER JOIN zstudent_address AS b
    ON a~student_id = b~student_id

    INNER JOIN zregistration AS c
    ON a~student_id = c~student_id

    INNER JOIN zcourse AS d
    ON c~course_id = d~course_id

    INNER JOIN zfeedetails AS e
    ON c~reg_id = e~reg_id

    INTO TABLE gt_final

    WHERE c~reg_id = p_reg.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZSF_COURSE_REG'
*     VARIANT  = ' '
*     DIRECT_CALL              = ' '
    IMPORTING
      fm_name  = gv_fm_name.
*  exceptions
*    no_form                  = 1
*    no_function_module       = 2
*    others                   = 3
  .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION gv_fm_name "'/1BCDWB/SF00000197'
    EXPORTING
*     ARCHIVE_INDEX    =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
*     CONTROL_PARAMETERS         =
*     MAIL_APPL_OBJ    =
*     MAIL_RECIPIENT   =
*     MAIL_SENDER      =
*     OUTPUT_OPTIONS   =
*     USER_SETTINGS    = 'X'
      iv_reg_id        = gs_final "wa
*   IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO  =
*     JOB_OUTPUT_OPTIONS         =
    tables
      it_fee           = gt_final "IT
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
