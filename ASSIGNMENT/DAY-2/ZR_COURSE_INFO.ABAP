*&---------------------------------------------------------------------*
*& Report ZR_COURSE_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_COURSE_INFO.

TYPE-POOLS: slis.

TABLES:
  zcourse,
  zregistration.


* Selection Screen

SELECT-OPTIONS:
  s_cour FOR zcourse-course_id,
  s_date FOR zcourse-created_date.


* Type Declaration

TYPES: BEGIN OF ty_course,

         course_id       TYPE zcourse-course_id,
         course_name     TYPE zcourse-course_name,
         faculty         TYPE zcourse-faculty,
         max_strength    TYPE zcourse-max_strength,
         created_date    TYPE zcourse-created_date,
         no_seats_filled TYPE i,
         no_avail_seats  TYPE i,

       END OF ty_course.


* Internal Tables

DATA:
  lt_course   TYPE TABLE OF ty_course,
  lt_zcourse  TYPE TABLE OF zcourse,
  lt_fieldcat TYPE slis_t_fieldcat_alv.


* Work Areas

DATA:
  ls_course   TYPE ty_course,
  ls_zcourse  TYPE zcourse,
  ls_fieldcat TYPE slis_fieldcat_alv.


* Variables

DATA:
  lv_count TYPE i,
  lv_repid TYPE sy-repid.

START-OF-SELECTION.


* Fetch Course Data

SELECT *
  INTO TABLE lt_zcourse
  FROM zcourse
  WHERE course_id IN s_cour
  AND created_date IN s_date.

IF lt_zcourse IS INITIAL.
  MESSAGE 'No Course Data Found' TYPE 'I'.
  EXIT.
ENDIF.


* Final Internal Table


LOOP AT lt_zcourse INTO ls_zcourse.

  CLEAR:
    ls_course,
    lv_count.


* Move Course Data

  ls_course-course_id    = ls_zcourse-course_id.
  ls_course-course_name  = ls_zcourse-course_name.
  ls_course-faculty      = ls_zcourse-faculty.
  ls_course-max_strength = ls_zcourse-max_strength.
  ls_course-created_date = ls_zcourse-created_date.



* Count Seats Filled

  SELECT COUNT(*)
    INTO lv_count
    FROM zregistration
    WHERE course_id = ls_zcourse-course_id.

  ls_course-no_seats_filled = lv_count.



* Calculate Available Seats

  ls_course-no_avail_seats =
      ls_course-max_strength - ls_course-no_seats_filled.



* Append Final Data

  APPEND ls_course TO lt_course.

ENDLOOP.


* No Data Check

IF lt_course IS INITIAL.
  MESSAGE 'No Data Found' TYPE 'I'.
  EXIT.
ENDIF.


* Field Catalog

CLEAR ls_fieldcat.
ls_fieldcat-fieldname = 'COURSE_ID'.
ls_fieldcat-seltext_m = 'Course ID'.
APPEND ls_fieldcat TO lt_fieldcat.

CLEAR ls_fieldcat.
ls_fieldcat-fieldname = 'COURSE_NAME'.
ls_fieldcat-seltext_m = 'Course Name'.
APPEND ls_fieldcat TO lt_fieldcat.

CLEAR ls_fieldcat.
ls_fieldcat-fieldname = 'FACULTY'.
ls_fieldcat-seltext_m = 'Faculty'.
APPEND ls_fieldcat TO lt_fieldcat.

CLEAR ls_fieldcat.
ls_fieldcat-fieldname = 'MAX_STRENGTH'.
ls_fieldcat-seltext_m = 'Maximum Strength'.
APPEND ls_fieldcat TO lt_fieldcat.

CLEAR ls_fieldcat.
ls_fieldcat-fieldname = 'CREATED_DATE'.
ls_fieldcat-seltext_m = 'Created Date'.
APPEND ls_fieldcat TO lt_fieldcat.

CLEAR ls_fieldcat.
ls_fieldcat-fieldname = 'NO_SEATS_FILLED'.
ls_fieldcat-seltext_m = 'Seats Filled'.
APPEND ls_fieldcat TO lt_fieldcat.

CLEAR ls_fieldcat.
ls_fieldcat-fieldname = 'NO_AVAIL_SEATS'.
ls_fieldcat-seltext_m = 'Available Seats'.
APPEND ls_fieldcat TO lt_fieldcat.



* ALV Display

lv_repid = sy-repid.


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = lv_repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = lt_fieldcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = lt_course
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
