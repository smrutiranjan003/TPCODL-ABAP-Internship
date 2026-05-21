*&---------------------------------------------------------------------*
*& Modulpool  ZMODCOURSE_REG
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM zmodcourse_reg.


TABLES:
  zstudentt,
  zstudent_address,
  zregistration,
  zcourse,
  zfeedetails.

DATA:
  ok_code TYPE sy-ucomm.


TYPES: BEGIN OF ty_student,

         student_id       TYPE zde_student_id,
         name             TYPE zde_student_name,
         department       TYPE zde_department,
         academic_year    TYPE zde_year,

         parent_name      TYPE zde_parent_name,
         address          TYPE zde_address,
         parent_mobile_no TYPE zde_phone,
         parent_email_id  TYPE zde_email,

         reg_id           TYPE zde_reg_id,
         course_id        TYPE zde_course_id,
         reg_date         TYPE zde_reg_date,

       END OF ty_student.


DATA:
  lt_student TYPE TABLE OF ty_student,
  ls_student TYPE ty_student.

DATA:
  gv_date TYPE zer_date,
  gv_time TYPE zer_time,
  gv_name TYPE zer_nam.



DATA : r111 TYPE char1,
       r222 TYPE char1,
       r333 TYPE char1.


DATA:
  gv_seats_filled TYPE i,     "i = Integer
  gv_seats_avail  TYPE i.


CONTROLS:
  tbc_200 TYPE TABLEVIEW USING SCREEN 0200.

START-OF-SELECTION.

  CLEAR : r111, r222.
  r333 = 'x'.

  CALL SCREEN 0100.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0400 OUTPUT.

  SET PF-STATUS 'STATUS_400'.
  SET TITLEBAR 'TITLE_400'.


  ok_code = sy-ucomm.

  CASE ok_code.

    WHEN 'FCT3'.

      IF NOT r333 = 'X'.

        LOOP AT SCREEN.

          IF screen-group1 = 'M3'.
            screen-input = 1.
*          else.
*            screen-input = 0.
          ENDIF.

          MODIFY SCREEN.
        ENDLOOP.


      ENDIF.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'STATUS_200'.
  SET TITLEBAR 'TITLE_200'.


  ok_code = sy-ucomm.

  CASE ok_code.

    WHEN 'FCT1'.
      IF NOT r333 = 'X'.
        LOOP AT SCREEN.
          IF screen-group1 = 'M1'.
            screen-input = 1.
*          else.
*            screen-input = 0.
          ENDIF.

          MODIFY SCREEN.
        ENDLOOP.


      ENDIF.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
*break : 92322.

  ok_code = sy-ucomm.

  CASE ok_code.


    WHEN 'SAV1'.

      zstudentt-mandt = sy-mandt.
*      zstudentt-student_id =
*      zstudentt-name =
*      zstudentt-department =
*      zstudentt-academic_year =
      zstudentt-created_date = sy-datum.
      zstudentt-created_time = sy-uzeit.
      zstudentt-created_by   = sy-uname.

      MODIFY zstudentt FROM zstudentt.


      zstudent_address-mandt = sy-mandt.
      zstudent_address-student_id = zstudentt-student_id.
*      zstudent_address-parent_name =
*      zstudent_address-address =
*      zstudent_address-parent_mobile_no =
*      zstudent_address-parent_email_id =
      zstudent_address-created_date = sy-datum.
      zstudent_address-created_time = sy-uzeit.
      zstudent_address-created_by = sy-uname.


*      zstudent_address-created_date = gv_date.
*      zstudent_address-created_time = gv_time.
*      zstudent_address-created_by   = gv_name.

      MODIFY zstudent_address
      FROM zstudent_address.


      zregistration-mandt = sy-mandt.
*      zregistration-reg_id =
      zregistration-student_id = zstudentt-student_id.
*      zregistration-course_id =
*      zregistration-reg_date =
      zregistration-created_date = sy-datum.
      zregistration-created_time = sy-uzeit.
      zregistration-created_by   = sy-uname.

      INSERT zregistration FROM zregistration.

      IF sy-subrc = 0.

        COMMIT WORK.

        MESSAGE 'Registration Saved Successfully'
        TYPE 'I'.

      ELSE.

        MESSAGE 'Registration Already Exists'
        TYPE 'E'.

      ENDIF.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0100.

  ENDCASE.
ENDMODULE.

MODULE tbc_200_modify INPUT.

  MODIFY lt_student
  FROM ls_student
  INDEX tbc_200-current_line.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR 'TITLE_100'.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
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
      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0300 OUTPUT.

  SET PF-STATUS 'STATUS_300'.
  SET TITLEBAR 'TITLE_300'.

  ok_code = sy-ucomm.

  CASE ok_code.

    WHEN 'FCT2'.

      IF NOT r333 = 'X'.

        LOOP AT SCREEN.

          IF screen-group1 = 'M2'.
            screen-input = 1.
*          else.
*            screen-input = 0.
          ENDIF.

          MODIFY SCREEN.
        ENDLOOP.


      ENDIF.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.

    WHEN 'SAV2'.

      zcourse-mandt = sy-mandt.

*      zcourse-course_id =
*      zcourse-course_name =
*      zcourse-faculty =
*      zcourse-max_strength =

      zcourse-created_date = sy-datum.
      zcourse-created_time = sy-uzeit.
      zcourse-created_by   = sy-uname.

      MODIFY zcourse FROM zcourse.

      COMMIT WORK.

      MESSAGE 'Course Saved Successfully'
      TYPE 'I'.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0100.

  ENDCASE.




ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.


    WHEN 'SAV3'.
      zfeedetails-mandt = sy-mandt.

*      zfeedetails-reg_id =
*      zfeedetails-term_no =
*      zfeedetails-item_no =
*      zfeedetails-fee_amount =

      zfeedetails-created_date = sy-datum.
      zfeedetails-created_time = sy-uzeit.
      zfeedetails-created_by   = sy-uname.


      MODIFY zfeedetails FROM zfeedetails.

      COMMIT WORK.

      MESSAGE 'Fee Details Saved Successfully'
      TYPE 'I'.

    WHEN 'BACK'.

      LEAVE TO SCREEN 0100.

  ENDCASE.

ENDMODULE.
