*&---------------------------------------------------------------------*
*& Report ZR_STUDENT_REG_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_student_reg_report.

TABLES:
  zstudentt,
  zstudent_address,
  zregistration,
  zcourse,
  zfeedetails.

TYPE-POOLS: slis.

SELECT-OPTIONS:

s_stid FOR zstudentt-student_id,
s_reg  FOR zregistration-reg_id,
s_dept FOR zstudentt-department,
s_cour FOR zregistration-course_id,
s_date FOR zstudentt-created_date.


TYPES: BEGIN OF ty_head,

         student_id       TYPE zstudentt-student_id,
         reg_id           TYPE zregistration-reg_id,
         student_name     TYPE zstudentt-name,
         course_name      TYPE zcourse-course_name,
         address          TYPE zstudent_address-address,
         parent_name      TYPE zstudent_address-parent_name,
         parent_mobile_no TYPE zstudent_address-parent_mobile_no,
         parent_email_id  TYPE zstudent_address-parent_email_id,

       END OF ty_head.


TYPES: BEGIN OF ty_item,

         student_id   TYPE zstudentt-student_id,
         reg_id       TYPE zregistration-reg_id,
         course_id    TYPE zregistration-course_id,
         term_no      TYPE zfeedetails-term_no,
         item_no      TYPE zfeedetails-item_no,
         fee_amount   TYPE zfeedetails-fee_amount,
         created_date TYPE zfeedetails-created_date,

       END OF ty_item.


DATA:

  lt_head TYPE TABLE OF ty_head,
  lt_item TYPE TABLE OF ty_item,

  ls_head TYPE ty_head,
  ls_item TYPE ty_item.

DATA:

  lt_student TYPE TABLE OF zstudentt,
  lt_address TYPE TABLE OF zstudent_address,
  lt_reg     TYPE TABLE OF zregistration,
  lt_course  TYPE TABLE OF zcourse,
  lt_fee     TYPE TABLE OF zfeedetails.

DATA:

  ls_student TYPE zstudentt,
  ls_address TYPE zstudent_address,
  ls_reg     TYPE zregistration,
  ls_course  TYPE zcourse,
  ls_fee     TYPE zfeedetails.


START-OF-SELECTION.

  PERFORM get_data.

  PERFORM display_header.


AT LINE-SELECTION.

  CASE sy-lsind.

    WHEN 1.

      PERFORM display_item.

  ENDCASE.

FORM get_data.

  SELECT *
  INTO TABLE lt_student
  FROM zstudentt
  WHERE student_id IN s_stid
  AND department IN s_dept
  AND created_date IN s_date.

  IF lt_student IS INITIAL.

    SELECT *
    INTO TABLE lt_student
    FROM zstudentt.

  ENDIF.

  SELECT *
  INTO TABLE lt_address
  FROM zstudent_address
  FOR ALL ENTRIES IN lt_student
  WHERE student_id = lt_student-student_id.

  SELECT *
  INTO TABLE lt_reg
  FROM zregistration
  FOR ALL ENTRIES IN lt_student
  WHERE student_id = lt_student-student_id
  AND reg_id IN s_reg
  AND course_id IN s_cour.

  SELECT *
  INTO TABLE lt_course
  FROM zcourse
  FOR ALL ENTRIES IN lt_reg
  WHERE course_id = lt_reg-course_id.

  SELECT *
  INTO TABLE lt_fee
  FROM zfeedetails
  FOR ALL ENTRIES IN lt_reg
  WHERE reg_id = lt_reg-reg_id.

  LOOP AT lt_reg INTO ls_reg.

    CLEAR ls_head.

    ls_head-student_id = ls_reg-student_id.
    ls_head-reg_id = ls_reg-reg_id.

    READ TABLE lt_student
    INTO ls_student
    WITH KEY student_id = ls_reg-student_id.

    IF sy-subrc = 0.

      ls_head-student_name = ls_student-name.

    ENDIF.

    READ TABLE lt_address
    INTO ls_address
    WITH KEY student_id = ls_reg-student_id.

    IF sy-subrc = 0.

      ls_head-address = ls_address-address.

      ls_head-parent_name = ls_address-parent_name.

      ls_head-parent_mobile_no = ls_address-parent_mobile_no.

      ls_head-parent_email_id = ls_address-parent_email_id.


    ENDIF.

    READ TABLE lt_course
    INTO ls_course
    WITH KEY course_id = ls_reg-course_id.

    IF sy-subrc = 0.

      ls_head-course_name =
      ls_course-course_name.

    ENDIF.

    APPEND ls_head TO lt_head.

    LOOP AT lt_fee INTO ls_fee
    WHERE reg_id = ls_reg-reg_id.

      CLEAR ls_item.

      ls_item-student_id = ls_reg-student_id.

      ls_item-reg_id = ls_reg-reg_id.

      ls_item-course_id = ls_reg-course_id.

      ls_item-term_no = ls_fee-term_no.

      ls_item-item_no = ls_fee-item_no.

      ls_item-fee_amount = ls_fee-fee_amount.

      ls_item-created_date = ls_fee-created_date.

      APPEND ls_item TO lt_item.

    ENDLOOP.

  ENDLOOP.

  SORT lt_head BY student_id reg_id.

  DELETE ADJACENT DUPLICATES
  FROM lt_head
  COMPARING student_id reg_id.

ENDFORM.


FORM display_header.

  DATA:
    lt_fcat TYPE slis_t_fieldcat_alv,
    ls_fcat TYPE slis_fieldcat_alv.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'STUDENT_ID'.
  ls_fcat-seltext_m = 'Student ID'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'REG_ID'.
  ls_fcat-seltext_m = 'Reg ID'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'STUDENT_NAME'.
  ls_fcat-seltext_m = 'Student Name'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'COURSE_NAME'.
  ls_fcat-seltext_m = 'Course Name'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'ADDRESS'.
  ls_fcat-seltext_m = 'Address'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'PARENT_NAME'.
  ls_fcat-seltext_m = 'Parent Name'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'PARENT_MOBILE_NO'.
  ls_fcat-seltext_m = 'Parent Mobile'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'PARENT_EMAIL_ID'.
  ls_fcat-seltext_m = 'Parent Email'.
  APPEND ls_fcat TO lt_fcat.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
*     IS_LAYOUT               =
      it_fieldcat             = lt_fcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
*     I_SAVE                  = ' '
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = lt_head
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.


FORM display_item.

  DATA:

    lt_sec  TYPE TABLE OF ty_item,

    lt_fcat TYPE slis_t_fieldcat_alv,

    ls_fcat TYPE slis_fieldcat_alv.


  LOOP AT lt_item INTO ls_item

  WHERE reg_id = ls_head-reg_id.

    APPEND ls_item TO lt_sec.

  ENDLOOP.


  CLEAR ls_fcat.
  ls_fcat-fieldname = 'STUDENT_ID'.
  ls_fcat-seltext_m = 'Student ID'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'REG_ID'.
  ls_fcat-seltext_m = 'Reg ID'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'COURSE_ID'.
  ls_fcat-seltext_m = 'Course ID'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'TERM_NO'.
  ls_fcat-seltext_m = 'Term No'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'ITEM_NO'.
  ls_fcat-seltext_m = 'Item No'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'FEE_AMOUNT'.
  ls_fcat-seltext_m = 'Fee Amount'.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'CREATED_DATE'.
  ls_fcat-seltext_m = 'Created Date'.
  APPEND ls_fcat TO lt_fcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
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
      it_fieldcat        = lt_fcat
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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = lt_sec
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  CASE r_ucomm.

    WHEN '&IC1'.

      READ TABLE lt_head
      INTO ls_head
      INDEX rs_selfield-tabindex.

      IF sy-subrc = 0.

        PERFORM display_item.

      ENDIF.

  ENDCASE.

ENDFORM.
