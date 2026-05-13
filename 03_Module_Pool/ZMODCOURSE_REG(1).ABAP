*&---------------------------------------------------------------------*
*& Modulpool  ZMODCOURSE_REG
*&---------------------------------------------------------------------*
*& Student Course Registration System
*&---------------------------------------------------------------------*

PROGRAM zmodcourse_reg.

*---------------------------------------------------------------------*
* Global Variables
*---------------------------------------------------------------------*

DATA:
  ok_code          TYPE sy-ucomm,
  gv_seats_filled  TYPE i,
  gv_seats_avail   TYPE i.

*---------------------------------------------------------------------*
* Table Declaration
*---------------------------------------------------------------------*

TABLES:
  zstudentt,
  zstudent_address,
  zregistration,
  zcourse,
  zfeedetails.

*---------------------------------------------------------------------*
* Start Screen
*---------------------------------------------------------------------*

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

  ok_code = sy-ucomm.

  CASE ok_code.

    WHEN 'BTN1'.

      CALL SCREEN 0200.

    WHEN 'BTN2'.

      CALL SCREEN 0300.

    WHEN 'BTN3'.

      CALL SCREEN 0400.

    WHEN 'BACK'.

      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'STATUS_200'.
  SET TITLEBAR 'TITLE_200'.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.

*---------------------------------------------------------------------*
* SAVE STUDENT REGISTRATION
*---------------------------------------------------------------------*

    WHEN 'SAV1'.

*---------------------------------------------------------------------*
* Validation
*---------------------------------------------------------------------*

      IF zstudentt-student_id IS INITIAL.

        MESSAGE 'Enter Student ID' TYPE 'E'.

      ENDIF.

      IF zstudentt-name IS INITIAL.

        MESSAGE 'Enter Student Name' TYPE 'E'.

      ENDIF.

*---------------------------------------------------------------------*
* Student Master Save
*---------------------------------------------------------------------*

      zstudentt-created_date = sy-datum.
      zstudentt-created_time = sy-uzeit.
      zstudentt-created_by   = sy-uname.

      MODIFY zstudentt FROM zstudentt.

*---------------------------------------------------------------------*
* Student Address Save
*---------------------------------------------------------------------*

      zstudent_address-student_id = zstudentt-student_id.

      zstudent_address-created_date = sy-datum.
      zstudent_address-created_time = sy-uzeit.
      zstudent_address-created_by   = sy-uname.

      MODIFY zstudent_address FROM zstudent_address.

*---------------------------------------------------------------------*
* Registration Save
*---------------------------------------------------------------------*

      zregistration-student_id = zstudentt-student_id.

      zregistration-created_date = sy-datum.
      zregistration-created_time = sy-uzeit.
      zregistration-created_by   = sy-uname.

      MODIFY zregistration FROM zregistration.

*---------------------------------------------------------------------*
* Database Commit
*---------------------------------------------------------------------*

      COMMIT WORK.

      MESSAGE 'Student Registration Saved Successfully'
      TYPE 'I'.

*---------------------------------------------------------------------*
* CREATE MODE
*---------------------------------------------------------------------*

    WHEN 'CREA'.

      CLEAR:
      zstudentt,
      zstudent_address,
      zregistration.

*---------------------------------------------------------------------*
* CHANGE MODE
*---------------------------------------------------------------------*

    WHEN 'CHAN'.

      LOOP AT SCREEN.

        screen-input = 1.

        MODIFY SCREEN.

      ENDLOOP.

*---------------------------------------------------------------------*
* VIEW MODE
*---------------------------------------------------------------------*

    WHEN 'VIEW'.

      LOOP AT SCREEN.

        screen-input = 0.

        MODIFY SCREEN.

      ENDLOOP.

*---------------------------------------------------------------------*
* BACK
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

*---------------------------------------------------------------------*
* Seats Filled
*---------------------------------------------------------------------*

  SELECT COUNT(*)
    INTO gv_seats_filled
    FROM zregistration
    WHERE course_id = zcourse-course_id.

*---------------------------------------------------------------------*
* Seats Available
*---------------------------------------------------------------------*

  gv_seats_avail =
      zcourse-max_strength - gv_seats_filled.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.

*---------------------------------------------------------------------*
* SAVE COURSE
*---------------------------------------------------------------------*

    WHEN 'SAV2'.

*---------------------------------------------------------------------*
* Validation
*---------------------------------------------------------------------*

      IF zcourse-course_id IS INITIAL.

        MESSAGE 'Enter Course ID' TYPE 'E'.

      ENDIF.

      IF zcourse-course_name IS INITIAL.

        MESSAGE 'Enter Course Name' TYPE 'E'.

      ENDIF.

*---------------------------------------------------------------------*
* Save Course Data
*---------------------------------------------------------------------*

      zcourse-created_date = sy-datum.
      zcourse-created_time = sy-uzeit.
      zcourse-created_by   = sy-uname.

      MODIFY zcourse FROM zcourse.

      COMMIT WORK.

      MESSAGE 'Course Saved Successfully'
      TYPE 'I'.

*---------------------------------------------------------------------*
* CREATE MODE
*---------------------------------------------------------------------*

    WHEN 'CREA'.

      CLEAR zcourse.

*---------------------------------------------------------------------*
* CHANGE MODE
*---------------------------------------------------------------------*

    WHEN 'CHAN'.

      LOOP AT SCREEN.

        screen-input = 1.

        MODIFY SCREEN.

      ENDLOOP.

*---------------------------------------------------------------------*
* VIEW MODE
*---------------------------------------------------------------------*

    WHEN 'VIEW'.

      LOOP AT SCREEN.

        screen-input = 0.

        MODIFY SCREEN.

      ENDLOOP.

*---------------------------------------------------------------------*
* BACK
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

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0400 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.

*---------------------------------------------------------------------*
* SAVE FEE DETAILS
*---------------------------------------------------------------------*

    WHEN 'SAV3'.

*---------------------------------------------------------------------*
* Validation
*---------------------------------------------------------------------*

      IF zfeedetails-reg_id IS INITIAL.

        MESSAGE 'Enter Registration ID'
        TYPE 'E'.

      ENDIF.

*---------------------------------------------------------------------*
* Save Fee Data
*---------------------------------------------------------------------*

      zfeedetails-created_date = sy-datum.
      zfeedetails-created_time = sy-uzeit.
      zfeedetails-created_by   = sy-uname.

      MODIFY zfeedetails FROM zfeedetails.

      COMMIT WORK.

      MESSAGE 'Fee Details Saved Successfully'
      TYPE 'I'.

*---------------------------------------------------------------------*
* CREATE MODE
*---------------------------------------------------------------------*

    WHEN 'CREA'.

      CLEAR zfeedetails.

*---------------------------------------------------------------------*
* CHANGE MODE
*---------------------------------------------------------------------*

    WHEN 'CHAN'.

      LOOP AT SCREEN.

        screen-input = 1.

        MODIFY SCREEN.

      ENDLOOP.

*---------------------------------------------------------------------*
* VIEW MODE
*---------------------------------------------------------------------*

    WHEN 'VIEW'.

      LOOP AT SCREEN.

        screen-input = 0.

        MODIFY SCREEN.

      ENDLOOP.

*---------------------------------------------------------------------*
* BACK
*---------------------------------------------------------------------*

    WHEN 'BACK'.

      LEAVE TO SCREEN 0100.

  ENDCASE.

ENDMODULE.
