```

====================================================================

# REPORT 2 : ZR_COURSE_INFO

====================================================================

# PURPOSE

This report displays:

* Course Information
* Seats Filled
* Available Seats

---

# STEP 1 : CREATE PROGRAM

---

Transaction:

```text
SE38
```

Program Name:

```text
ZR_COURSE_INFO
```

Create → Executable Program → Save

---

# COMPLETE REPORT CODE

---

```abap
REPORT zr_course_info.

TABLES:
  zcourse,
  zregistration.

*---------------------------------------------------------------------*
* Selection Screen
*---------------------------------------------------------------------*

SELECT-OPTIONS:
  s_cour FOR zcourse-course_id,
  s_date FOR zcourse-created_date.

*---------------------------------------------------------------------*
* Type Declaration
*---------------------------------------------------------------------*

TYPES: BEGIN OF ty_course,

         course_id       TYPE zcourse-course_id,
         course_name     TYPE zcourse-course_name,
         faculty         TYPE zcourse-faculty,
         max_strength    TYPE zcourse-max_strength,
         created_date    TYPE zcourse-created_date,
         no_seats_filled TYPE i,
         no_avail_seats  TYPE i,

       END OF ty_course.

*---------------------------------------------------------------------*
* Internal Tables
*---------------------------------------------------------------------*

DATA:
  lt_course  TYPE TABLE OF ty_course,
  lt_zcourse TYPE TABLE OF zcourse.

*---------------------------------------------------------------------*
* Work Areas
*---------------------------------------------------------------------*

DATA:
  ls_course  TYPE ty_course,
  ls_zcourse TYPE zcourse.

DATA:
  lv_count TYPE i.

*---------------------------------------------------------------------*
* START OF SELECTION
*---------------------------------------------------------------------*

START-OF-SELECTION.

*---------------------------------------------------------------------*
* Fetch Course Data
*---------------------------------------------------------------------*

SELECT *
  INTO TABLE lt_zcourse
  FROM zcourse
  WHERE course_id IN s_cour
  AND created_date IN s_date.

IF lt_zcourse IS INITIAL.
  MESSAGE 'No Course Data Found' TYPE 'I'.
  EXIT.
ENDIF.

*---------------------------------------------------------------------*
* Prepare Final Internal Table
*---------------------------------------------------------------------*

LOOP AT lt_zcourse INTO ls_zcourse.

  CLEAR:
    ls_course,
    lv_count.

*---------------------------------------------------------------------*
* Move Course Data
*---------------------------------------------------------------------*

  ls_course-course_id    = ls_zcourse-course_id.
  ls_course-course_name  = ls_zcourse-course_name.
  ls_course-faculty      = ls_zcourse-faculty.
  ls_course-max_strength = ls_zcourse-max_strength.
  ls_course-created_date = ls_zcourse-created_date.

*---------------------------------------------------------------------*
* Count Seats Filled
*---------------------------------------------------------------------*

  SELECT COUNT(*)
    INTO lv_count
    FROM zregistration
    WHERE course_id = ls_zcourse-course_id.

  ls_course-no_seats_filled = lv_count.

*---------------------------------------------------------------------*
* Calculate Available Seats
*---------------------------------------------------------------------*

  ls_course-no_avail_seats =
      ls_course-max_strength -
      ls_course-no_seats_filled.

*---------------------------------------------------------------------*
* Append Final Data
*---------------------------------------------------------------------*

  APPEND ls_course TO lt_course.

ENDLOOP.

*---------------------------------------------------------------------*
* No Data Check
*---------------------------------------------------------------------*

IF lt_course IS INITIAL.
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
        t_table      = lt_course ).

    lr_alv->display( ).

  CATCH cx_salv_msg.

ENDTRY.
```
