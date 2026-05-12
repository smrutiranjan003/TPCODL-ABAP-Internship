*&---------------------------------------------------------------------*
*& Report ZR_STUDENT_REG_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_STUDENT_REG_REPORT.

TABLES:
  zstudentt,
  zstudent_address,
  zregistration,
  zcourse,
  zfeedetails.

*---------------------------------------------------------------------*
* Selection Screen
*---------------------------------------------------------------------*

SELECT-OPTIONS:
  s_stid FOR zstudent-student_id,
  s_reg  FOR zregistration-reg_id,
  s_dept FOR zstudent-department,
  s_cour FOR zregistration-course_id,
  s_date FOR zstudent-created_date.

*---------------------------------------------------------------------*
* Type Declaration
*---------------------------------------------------------------------*

TYPES: BEGIN OF ty_final,

         student_id       TYPE zstudent-student_id,
         reg_id           TYPE zregistration-reg_id,
         student_name     TYPE zstudent-student_name,
         course_name      TYPE zcourse-course_name,
         address          TYPE zstudent_address-address,
         parent_name      TYPE zstudent_address-parent_name,
         parent_mobile_no TYPE zstudent_address-parent_mobile_no,
         parent_email_id  TYPE zstudent_address-parent_email_id,
         course_id        TYPE zregistration-course_id,
         term_no          TYPE zfeedetails-term_no,
         item_no          TYPE zfeedetails-item_no,
         fee_amount       TYPE zfeedetails-fee_amount,
         created_date     TYPE zfeedetails-created_date,

       END OF ty_final.

*---------------------------------------------------------------------*
* Internal Tables
*---------------------------------------------------------------------*

DATA:
  lt_student      TYPE TABLE OF zstudent,
  lt_address      TYPE TABLE OF zstudent_address,
  lt_registration TYPE TABLE OF zregistration,
  lt_course       TYPE TABLE OF zcourse,
  lt_fee          TYPE TABLE OF zfeedetails,
  lt_final        TYPE TABLE OF ty_final.

*---------------------------------------------------------------------*
* Work Areas
*---------------------------------------------------------------------*

DATA:
  ls_student      TYPE zstudent,
  ls_address      TYPE zstudent_address,
  ls_registration TYPE zregistration,
  ls_course       TYPE zcourse,
  ls_fee          TYPE zfeedetails,
  ls_final        TYPE ty_final.

*---------------------------------------------------------------------*
* START OF SELECTION
*---------------------------------------------------------------------*

START-OF-SELECTION.

*---------------------------------------------------------------------*
* Fetch Student Data
*---------------------------------------------------------------------*

SELECT *
  INTO TABLE lt_student
  FROM zstudent
  WHERE student_id IN s_stid
  AND department IN s_dept
  AND created_date IN s_date.

IF lt_student IS INITIAL.
  MESSAGE 'No Student Data Found' TYPE 'I'.
  EXIT.
ENDIF.

*---------------------------------------------------------------------*
* Fetch Address Data
*---------------------------------------------------------------------*

SELECT *
  INTO TABLE lt_address
  FROM zstudent_address
  FOR ALL ENTRIES IN lt_student
  WHERE student_id = lt_student-student_id.

*---------------------------------------------------------------------*
* Fetch Registration Data
*---------------------------------------------------------------------*

SELECT *
  INTO TABLE lt_registration
  FROM zregistration
  FOR ALL ENTRIES IN lt_student
  WHERE student_id = lt_student-student_id
  AND reg_id IN s_reg
  AND course_id IN s_cour.

IF lt_registration IS INITIAL.
  MESSAGE 'No Registration Data Found' TYPE 'I'.
  EXIT.
ENDIF.

*---------------------------------------------------------------------*
* Fetch Course Data
*---------------------------------------------------------------------*

SELECT *
  INTO TABLE lt_course
  FROM zcourse
  FOR ALL ENTRIES IN lt_registration
  WHERE course_id = lt_registration-course_id.

*---------------------------------------------------------------------*
* Fetch Fee Details
*---------------------------------------------------------------------*

SELECT *
  INTO TABLE lt_fee
  FROM zfeedetails
  FOR ALL ENTRIES IN lt_registration
  WHERE reg_id = lt_registration-reg_id.

*---------------------------------------------------------------------*
* Final Internal Table Preparation
*---------------------------------------------------------------------*

LOOP AT lt_registration INTO ls_registration.

  CLEAR ls_final.

  ls_final-reg_id     = ls_registration-reg_id.
  ls_final-student_id = ls_registration-student_id.
  ls_final-course_id  = ls_registration-course_id.

*---------------------------------------------------------------------*
* Read Student Data
*---------------------------------------------------------------------*

  READ TABLE lt_student INTO ls_student
  WITH KEY student_id = ls_registration-student_id.

  IF sy-subrc = 0.
    ls_final-student_name = ls_student-student_name.
  ENDIF.

*---------------------------------------------------------------------*
* Read Address Data
*---------------------------------------------------------------------*

  READ TABLE lt_address INTO ls_address
  WITH KEY student_id = ls_registration-student_id.

  IF sy-subrc = 0.

    ls_final-address          = ls_address-address.
    ls_final-parent_name      = ls_address-parent_name.
    ls_final-parent_mobile_no = ls_address-parent_mobile_no.
    ls_final-parent_email_id  = ls_address-parent_email_id.

  ENDIF.

*---------------------------------------------------------------------*
* Read Course Data
*---------------------------------------------------------------------*

  READ TABLE lt_course INTO ls_course
  WITH KEY course_id = ls_registration-course_id.

  IF sy-subrc = 0.
    ls_final-course_name = ls_course-course_name.
  ENDIF.

*---------------------------------------------------------------------*
* Read Fee Data
*---------------------------------------------------------------------*

  LOOP AT lt_fee INTO ls_fee
  WHERE reg_id = ls_registration-reg_id.

    ls_final-term_no      = ls_fee-term_no.
    ls_final-item_no      = ls_fee-item_no.
    ls_final-fee_amount   = ls_fee-fee_amount.
    ls_final-created_date = ls_fee-created_date.

    APPEND ls_final TO lt_final.

  ENDLOOP.

ENDLOOP.

*---------------------------------------------------------------------*
* No Data Check
*---------------------------------------------------------------------*

IF lt_final IS INITIAL.
  MESSAGE 'No Data Found' TYPE 'I'.
  EXIT.
ENDIF.

*---------------------------------------------------------------------*
* ALV Display
*---------------------------------------------------------------------*

DATA:
  lr_alv TYPE REF TO cl_salv_table.

TRY.

    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = lr_alv
      CHANGING
        t_table      = lt_final ).

    lr_alv->display( ).

  CATCH cx_salv_msg.

ENDTRY.
