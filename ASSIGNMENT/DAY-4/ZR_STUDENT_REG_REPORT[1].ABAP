*&---------------------------------------------------------------------*
*& Report ZR_STUDENT_REG_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_student_reg_report.

TYPE-POOLS: slis.

TABLES:
  zstudentt,
  zstudent_address,
  zregistration,
  zcourse,
  zfeedetails.


* Selection Screen

SELECT-OPTIONS:
  s_stid FOR zstudentt-student_id,
  s_reg  FOR zregistration-reg_id,
  s_dept FOR zstudentt-department,
  s_cour FOR zregistration-course_id,
  s_date FOR zstudentt-created_date.


* Type Declaration

TYPES: BEGIN OF ty_final,

         student_id       TYPE zstudentt-student_id,
         reg_id           TYPE zregistration-reg_id,
         student_name     TYPE zstudentt-name,
         department       TYPE zstudentt-department,
         course_id        TYPE zregistration-course_id,
         course_name      TYPE zcourse-course_name,

         address          TYPE zstudent_address-address,
         parent_name      TYPE zstudent_address-parent_name,
         parent_mobile_no TYPE zstudent_address-parent_mobile_no,
         parent_email_id  TYPE zstudent_address-parent_email_id,

         term_no          TYPE zfeedetails-term_no,
         item_no          TYPE zfeedetails-item_no,
         fee_amount       TYPE zfeedetails-fee_amount,
         created_date     TYPE zfeedetails-created_date,

       END OF ty_final.


* Internal Tables

DATA:
  lt_student      TYPE TABLE OF zstudentt,
  lt_address      TYPE TABLE OF zstudent_address,
  lt_registration TYPE TABLE OF zregistration,
  lt_course       TYPE TABLE OF zcourse,
  lt_fee          TYPE TABLE OF zfeedetails,
  lt_final        TYPE TABLE OF ty_final.


* Work Areas

DATA:
  ls_student      TYPE zstudentt,
  ls_address      TYPE zstudent_address,
  ls_registration TYPE zregistration,
  ls_course       TYPE zcourse,
  ls_fee          TYPE zfeedetails,
  ls_final        TYPE ty_final.


* ALV Objects

DATA:
  lt_fieldcat TYPE slis_t_fieldcat_alv,
  ls_fieldcat TYPE slis_fieldcat_alv,
  lv_repid    TYPE sy-repid.


START-OF-SELECTION.

* Fetch Student Data

  SELECT *
    INTO TABLE lt_student
    FROM zstudentt
    WHERE student_id   IN s_stid
    AND   department   IN s_dept
    AND   created_date IN s_date.

  IF sy-subrc <> 0.
    CLEAR lt_student.
  ENDIF.

* If no filter entered for student table then fetch all

  IF s_stid[] IS INITIAL
  AND s_dept[] IS INITIAL
  AND s_date[] IS INITIAL.

    SELECT *
      INTO TABLE lt_student
      FROM zstudentt.

  ENDIF.


  IF lt_student IS INITIAL.
    MESSAGE 'No Student Data Found'
    TYPE 'I'.
    EXIT.
  ENDIF.


* Fetch Address Data


  SELECT *
    INTO TABLE lt_address
    FROM zstudent_address
    FOR ALL ENTRIES IN lt_student
    WHERE student_id = lt_student-student_id.


* Fetch Registration Data

  SELECT *
    INTO TABLE lt_registration
    FROM zregistration
    FOR ALL ENTRIES IN lt_student
    WHERE student_id = lt_student-student_id
    AND   reg_id     IN s_reg
    AND   course_id  IN s_cour.


* If no registration filter entered fetch all registration data


  IF s_reg[] IS INITIAL
  AND s_cour[] IS INITIAL.

    SELECT *
      INTO TABLE lt_registration
      FROM zregistration
      FOR ALL ENTRIES IN lt_student
      WHERE student_id = lt_student-student_id.

  ENDIF.


* If student side empty and only registration fields entered

  IF lt_registration IS INITIAL.

    SELECT *
      INTO TABLE lt_registration
      FROM zregistration
      WHERE reg_id    IN s_reg
      AND   course_id IN s_cour.

  ENDIF.


  IF lt_registration IS INITIAL.
    MESSAGE 'No Registration Data Found'
    TYPE 'I'.
    EXIT.
  ENDIF.


* Fetch Course Data

  SELECT *
    INTO TABLE lt_course
    FROM zcourse
    FOR ALL ENTRIES IN lt_registration
    WHERE course_id = lt_registration-course_id.


* Fetch Fee Details
  SELECT *
    INTO TABLE lt_fee
    FROM zfeedetails
    FOR ALL ENTRIES IN lt_registration
    WHERE reg_id = lt_registration-reg_id.



*Final Internal Table


  LOOP AT lt_registration INTO ls_registration.

    CLEAR ls_final.


* Registration Data

    ls_final-reg_id     = ls_registration-reg_id.
    ls_final-student_id = ls_registration-student_id.
    ls_final-course_id  = ls_registration-course_id.


* Student Data

    READ TABLE lt_student INTO ls_student
    WITH KEY student_id = ls_registration-student_id.

    IF sy-subrc = 0.

      ls_final-student_name = ls_student-name.
      ls_final-department   = ls_student-department.

    ENDIF.


* Address Data

    READ TABLE lt_address INTO ls_address
    WITH KEY student_id = ls_registration-student_id.

    IF sy-subrc = 0.

      ls_final-address          = ls_address-address.
      ls_final-parent_name      = ls_address-parent_name.
      ls_final-parent_mobile_no = ls_address-parent_mobile_no.
      ls_final-parent_email_id  = ls_address-parent_email_id.

    ENDIF.

* Course Data

    READ TABLE lt_course INTO ls_course
    WITH KEY course_id = ls_registration-course_id.

    IF sy-subrc = 0.

      ls_final-course_name = ls_course-course_name.

    ENDIF.


* Fee Data

    READ TABLE lt_fee INTO ls_fee
    WITH KEY reg_id = ls_registration-reg_id.

    IF sy-subrc = 0.

      LOOP AT lt_fee INTO ls_fee
        WHERE reg_id = ls_registration-reg_id.

        ls_final-term_no      = ls_fee-term_no.
        ls_final-item_no      = ls_fee-item_no.
        ls_final-fee_amount   = ls_fee-fee_amount.
        ls_final-created_date = ls_fee-created_date.

        APPEND ls_final TO lt_final.

      ENDLOOP.

    ELSE.

      APPEND ls_final TO lt_final.

    ENDIF.

  ENDLOOP.


* Final Data Check

  IF lt_final IS INITIAL.

    MESSAGE 'No Data Found'
    TYPE 'I'.

    EXIT.

  ENDIF.

* If No Fee Record Exists

  IF sy-subrc <> 0.

    APPEND ls_final TO lt_final.

  ENDIF.

*ENDLOOP.
**Final Internal Table
*
*  LOOP AT lt_registration INTO ls_registration.
*
*    CLEAR ls_final.
*
** Registration Data
*
*    ls_final-reg_id     = ls_registration-reg_id.
*    ls_final-student_id = ls_registration-student_id.
*    ls_final-course_id  = ls_registration-course_id.
*
*
** Read Student Data
*
*    READ TABLE lt_student INTO ls_student
*    WITH KEY student_id = ls_registration-student_id.
*
*    IF sy-subrc = 0.
*
*      ls_final-student_name = ls_student-name.
*      ls_final-department   = ls_student-department.
*
*    ENDIF.
*
*
** Read Address Data
*
*    READ TABLE lt_address INTO ls_address
*    WITH KEY student_id = ls_registration-student_id.
*
*    IF sy-subrc = 0.
*
*      ls_final-address          = ls_address-address.
*      ls_final-parent_name      = ls_address-parent_name.
*      ls_final-parent_mobile_no = ls_address-parent_mobile_no.
*      ls_final-parent_email_id  = ls_address-parent_email_id.
*
*    ENDIF.
*
*
** Read Course Data
*
*    READ TABLE lt_course INTO ls_course
*    WITH KEY course_id = ls_registration-course_id.
*
*    IF sy-subrc = 0.
*
*      ls_final-course_name = ls_course-course_name.
*
*    ENDIF.
*
*
** Read Fee Data
*
*
*    READ TABLE lt_fee INTO ls_fee
*    WITH KEY reg_id = ls_registration-reg_id.
*
*    IF sy-subrc = 0.
*
*      LOOP AT lt_fee INTO ls_fee
*        WHERE reg_id = ls_registration-reg_id.
*
*        ls_final-term_no      = ls_fee-term_no.
*        ls_final-item_no      = ls_fee-item_no.
*        ls_final-fee_amount   = ls_fee-fee_amount.
*        ls_final-created_date = ls_fee-created_date.
*
*        APPEND ls_final TO lt_final.
*
*      ENDLOOP.
*
*    ELSE.
*
*      APPEND ls_final TO lt_final.
*
*    ENDIF.
*
*  ENDLOOP.
*


* Final Data Check

  IF lt_final IS INITIAL.

    MESSAGE 'No Data Found'
    TYPE 'I'.

    EXIT.

  ENDIF.

* Field Catalog

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'STUDENT_ID'.
  ls_fieldcat-seltext_m = 'Student ID'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'REG_ID'.
  ls_fieldcat-seltext_m = 'Registration ID'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'STUDENT_NAME'.
  ls_fieldcat-seltext_m = 'Student Name'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'DEPARTMENT'.
  ls_fieldcat-seltext_m = 'Department'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'COURSE_ID'.
  ls_fieldcat-seltext_m = 'Course ID'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'COURSE_NAME'.
  ls_fieldcat-seltext_m = 'Course Name'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'ADDRESS'.
  ls_fieldcat-seltext_m = 'Address'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'PARENT_NAME'.
  ls_fieldcat-seltext_m = 'Parent Name'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'PARENT_MOBILE_NO'.
  ls_fieldcat-seltext_m = 'Mobile No'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'PARENT_EMAIL_ID'.
  ls_fieldcat-seltext_m = 'Email ID'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'TERM_NO'.
  ls_fieldcat-seltext_m = 'Term No'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'ITEM_NO'.
  ls_fieldcat-seltext_m = 'Item No'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'FEE_AMOUNT'.
  ls_fieldcat-seltext_m = 'Fee Amount'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CREATED_DATE'.
  ls_fieldcat-seltext_m = 'Created Date'.
  APPEND ls_fieldcat TO lt_fieldcat.


* ALV Display

  lv_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = lv_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = lt_fieldcat
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
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = lt_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE 'ALV Display Error'
  TYPE 'E'.
  ENDIF.
