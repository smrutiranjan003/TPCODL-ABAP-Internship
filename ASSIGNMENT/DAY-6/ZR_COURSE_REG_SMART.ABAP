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
  gs_final TYPE zst_smart.

DATA:
  gv_fm_name TYPE rs38l_fnam.

DATA:
  it_final TYPE zar_tt_feedetails,
  is_final TYPE zar_str_feedetails.

DATA:
  gt_reg     TYPE TABLE OF zregistration,
  gt_student TYPE TABLE OF zstudentt,
  gt_address TYPE TABLE OF zstudent_address,
  gt_course  TYPE TABLE OF zcourse,
  gt_fee     TYPE TABLE OF zfeedetails.

DATA:
  gs_reg     TYPE zregistration,
  gs_student TYPE zstudentt,
  gs_address TYPE zstudent_address,
  gs_course  TYPE zcourse,
  gs_fee     TYPE zfeedetails.

PARAMETERS:
  p_reg TYPE zde_reg_id.

START-OF-SELECTION.

  SELECT *
  INTO TABLE gt_reg
  FROM zregistration
  WHERE reg_id = p_reg.

  IF gt_reg IS INITIAL.
    MESSAGE 'Registration not found' TYPE 'E'.
  ENDIF.

  SELECT *
  INTO TABLE gt_student
  FROM zstudentt
  FOR ALL ENTRIES IN gt_reg
  WHERE student_id = gt_reg-student_id.


  SELECT *
  INTO TABLE gt_address
  FROM zstudent_address
  FOR ALL ENTRIES IN gt_reg
  WHERE student_id = gt_reg-student_id.


  SELECT *
  INTO TABLE gt_course
  FROM zcourse
  FOR ALL ENTRIES IN gt_reg
  WHERE course_id = gt_reg-course_id.


  SELECT *
  INTO TABLE gt_fee
  FROM zfeedetails
  FOR ALL ENTRIES IN gt_reg
  WHERE reg_id = gt_reg-reg_id.

  CLEAR:
    gs_final,
    it_final.


  LOOP AT gt_reg INTO gs_reg.

    READ TABLE gt_student
    INTO gs_student
    WITH KEY student_id = gs_reg-student_id.

    IF sy-subrc = 0.

      gs_final-student_id    = gs_student-student_id.
      gs_final-name          = gs_student-name.
      gs_final-department    = gs_student-department.
      gs_final-academic_year = gs_student-academic_year.

    ENDIF.

    READ TABLE gt_address
    INTO gs_address
    WITH KEY student_id = gs_reg-student_id.

    IF sy-subrc = 0.

      gs_final-parent_name = gs_address-parent_name.

      gs_final-address = gs_address-address.

      gs_final-parent_mobile_no = gs_address-parent_mobile_no.

      gs_final-parent_email_id = gs_address-parent_email_id.


    ENDIF.


    READ TABLE gt_course
    INTO gs_course
    WITH KEY course_id = gs_reg-course_id.

    IF sy-subrc = 0.

      gs_final-course_id = gs_course-course_id.

      gs_final-course_name = gs_course-course_name.

      gs_final-faculty = gs_course-faculty.


    ENDIF.

    gs_final-reg_id   = gs_reg-reg_id.
    gs_final-reg_date = gs_reg-reg_date.


    LOOP AT gt_fee INTO gs_fee
    WHERE reg_id = gs_reg-reg_id.

      CLEAR is_final.

      is_final-term_no = gs_fee-term_no.

      is_final-item_no = gs_fee-item_no.

      is_final-fee_amount = gs_fee-fee_amount.

      APPEND is_final TO it_final.

      gs_final-total_fees = gs_final-total_fees + gs_fee-fee_amount.


    ENDLOOP.


    gs_final-fee_details = it_final.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSF_COURSE_REG'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = gv_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.

* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION gv_fm_name    "'/1BCDWB/SF00000197'
      EXPORTING
*       ARCHIVE_INDEX    =
*       ARCHIVE_INDEX_TAB          =
*       ARCHIVE_PARAMETERS         =
*       CONTROL_PARAMETERS         =
*       MAIL_APPL_OBJ    =
*       MAIL_RECIPIENT   =
*       MAIL_SENDER      =
*       OUTPUT_OPTIONS   =
*       USER_SETTINGS    = 'X'
        details          = gs_final
* IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO  =
*       JOB_OUTPUT_OPTIONS         =
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.

* Implement suitable error handling here
    ENDIF.

  ENDLOOP.
