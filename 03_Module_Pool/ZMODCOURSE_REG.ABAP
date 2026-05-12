*&---------------------------------------------------------------------*
*& Modulpool  ZMODCOURSE_REG
*&---------------------------------------------------------------------*
*& Course Registration Management System
*&---------------------------------------------------------------------*

PROGRAM zmodcourse_reg.

TABLES:
  zstudentt,
  zcourse,
  zfeedetails.


*---------------------------------------------------------------------*
* Internal Tables
*---------------------------------------------------------------------*

DATA:
  gt_student TYPE TABLE OF zstudentt,
  gt_course  TYPE TABLE OF zcourse,
  gt_fee     TYPE TABLE OF zfeedetails.


*---------------------------------------------------------------------*
* Work Areas
*---------------------------------------------------------------------*

DATA:
  gs_student TYPE zstudentt,
  gs_course  TYPE zcourse,
  gs_fee     TYPE zfeedetails.


*---------------------------------------------------------------------*
* Table Controls
*---------------------------------------------------------------------*

CONTROLS:
  tc_student TYPE TABLEVIEW USING SCREEN 0200,
  tc_course  TYPE TABLEVIEW USING SCREEN 0300,
  tc_fee     TYPE TABLEVIEW USING SCREEN 0400.


*---------------------------------------------------------------------*
* Variables
*---------------------------------------------------------------------*

DATA:
  gv_mode TYPE c LENGTH 1.


*---------------------------------------------------------------------*
* Selection Screen Variables
*---------------------------------------------------------------------*

DATA:
  gv_student_id TYPE zstudentt-student_id,
  gv_course_id  TYPE zcourse-course_id,
  gv_reg_id     TYPE zfeedetails-reg_id.



START-OF-SELECTION.

  CALL SCREEN 0100.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR 'TITLE_100'.

ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.

    WHEN 'BTN1'.
      CALL SCREEN 0200.

    WHEN 'BTN2'.
      CALL SCREEN 0300.

    WHEN 'BTN3'.
      CALL SCREEN 0400.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'STATUS_200'.
  SET TITLEBAR 'TITLE_200'.



* View Mode

  IF gv_mode = 'V'.

    LOOP AT SCREEN.

      screen-input = 0.
      MODIFY SCREEN.

    ENDLOOP.

  ELSE.

* Create and Change Mode

    LOOP AT SCREEN.

      screen-input = 1.
      MODIFY SCREEN.

    ENDLOOP.

  ENDIF.



* Table Control Display

  LOOP AT gt_student INTO gs_student
       WITH CONTROL tc_student.

  ENDLOOP.

ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE sy-ucomm.



*---------------------------------------------------------------------*
* Create Student
*---------------------------------------------------------------------*

    WHEN 'CREA'.

      gv_mode = 'C'.

      CLEAR gt_student.
      REFRESH gt_student.

      APPEND INITIAL LINE TO gt_student.

      LEAVE TO SCREEN 0200.



*---------------------------------------------------------------------*
* Change Student
*---------------------------------------------------------------------*

    WHEN 'CHNG'.

      gv_mode = 'E'.

      SELECT *
        INTO TABLE gt_student
        FROM zstudentt
        WHERE student_id = gv_student_id.

      LEAVE TO SCREEN 0200.



*---------------------------------------------------------------------*
* View Student
*---------------------------------------------------------------------*

    WHEN 'VIEW'.

      gv_mode = 'V'.

      SELECT *
        INTO TABLE gt_student
        FROM zstudentt
        WHERE student_id = gv_student_id.

      LEAVE TO SCREEN 0200.



*---------------------------------------------------------------------*
* Save Student
*---------------------------------------------------------------------*

    WHEN 'SAVE'.

      LOOP AT gt_student INTO gs_student.

        MODIFY zstudentt FROM gs_student.

      ENDLOOP.

      COMMIT WORK.

      MESSAGE 'Student Data Saved Successfully'
      TYPE 'S'.



*---------------------------------------------------------------------*
* Back
*---------------------------------------------------------------------*

    WHEN 'BACK'.

      LEAVE TO SCREEN 0100.

  ENDCASE.

ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.

  SET PF-STATUS 'STATUS_300'.
  SET TITLEBAR 'TITLE_300'.



* View Mode

  IF gv_mode = 'V'.

    LOOP AT SCREEN.

      screen-input = 0.
      MODIFY SCREEN.

    ENDLOOP.

  ELSE.

    LOOP AT SCREEN.

      screen-input = 1.
      MODIFY SCREEN.

    ENDLOOP.

  ENDIF.



* Table Control Display

  LOOP AT gt_course INTO gs_course
       WITH CONTROL tc_course.

  ENDLOOP.

ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  CASE sy-ucomm.



*---------------------------------------------------------------------*
* Create Course
*---------------------------------------------------------------------*

    WHEN 'CREA'.

      gv_mode = 'C'.

      CLEAR gt_course.
      REFRESH gt_course.

      APPEND INITIAL LINE TO gt_course.

      LEAVE TO SCREEN 0300.



*---------------------------------------------------------------------*
* Change Course
*---------------------------------------------------------------------*

    WHEN 'CHNG'.

      gv_mode = 'E'.

      SELECT *
        INTO TABLE gt_course
        FROM zcourse
        WHERE course_id = gv_course_id.

      LEAVE TO SCREEN 0300.



*---------------------------------------------------------------------*
* View Course
*---------------------------------------------------------------------*

    WHEN 'VIEW'.

      gv_mode = 'V'.

      SELECT *
        INTO TABLE gt_course
        FROM zcourse
        WHERE course_id = gv_course_id.

      LEAVE TO SCREEN 0300.



*---------------------------------------------------------------------*
* Save Course
*---------------------------------------------------------------------*

    WHEN 'SAVE'.

      LOOP AT gt_course INTO gs_course.

        MODIFY zcourse FROM gs_course.

      ENDLOOP.

      COMMIT WORK.

      MESSAGE 'Course Data Saved Successfully'
      TYPE 'S'.



*---------------------------------------------------------------------*
* Back
*---------------------------------------------------------------------*

    WHEN 'BACK'.

      LEAVE TO SCREEN 0100.

  ENDCASE.

ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0400 OUTPUT.

  SET PF-STATUS 'STATUS_400'.
  SET TITLEBAR 'TITLE_400'.



* View Mode

  IF gv_mode = 'V'.

    LOOP AT SCREEN.

      screen-input = 0.
      MODIFY SCREEN.

    ENDLOOP.

  ELSE.

    LOOP AT SCREEN.

      screen-input = 1.
      MODIFY SCREEN.

    ENDLOOP.

  ENDIF.



* Table Control Display

  LOOP AT gt_fee INTO gs_fee
       WITH CONTROL tc_fee.

  ENDLOOP.

ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0400 INPUT.

  CASE sy-ucomm.



*---------------------------------------------------------------------*
* Create Fee
*---------------------------------------------------------------------*

    WHEN 'CREA'.

      gv_mode = 'C'.

      CLEAR gt_fee.
      REFRESH gt_fee.

      APPEND INITIAL LINE TO gt_fee.

      LEAVE TO SCREEN 0400.



*---------------------------------------------------------------------*
* Change Fee
*---------------------------------------------------------------------*

    WHEN 'CHNG'.

      gv_mode = 'E'.

      SELECT *
        INTO TABLE gt_fee
        FROM zfeedetails
        WHERE reg_id = gv_reg_id.

      LEAVE TO SCREEN 0400.



*---------------------------------------------------------------------*
* View Fee
*---------------------------------------------------------------------*

    WHEN 'VIEW'.

      gv_mode = 'V'.

      SELECT *
        INTO TABLE gt_fee
        FROM zfeedetails
        WHERE reg_id = gv_reg_id.

      LEAVE TO SCREEN 0400.



*---------------------------------------------------------------------*
* Save Fee
*---------------------------------------------------------------------*

    WHEN 'SAVE'.

      LOOP AT gt_fee INTO gs_fee.

        MODIFY zfeedetails FROM gs_fee.

      ENDLOOP.

      COMMIT WORK.

      MESSAGE 'Fee Data Saved Successfully'
      TYPE 'S'.



*---------------------------------------------------------------------*
* Back
*---------------------------------------------------------------------*

    WHEN 'BACK'.

      LEAVE TO SCREEN 0100.

  ENDCASE.

ENDMODULE.
