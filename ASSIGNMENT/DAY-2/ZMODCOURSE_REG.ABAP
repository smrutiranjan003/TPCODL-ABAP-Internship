*&---------------------------------------------------------------------*
*& Modulpool  ZMODCOURSE_REG
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM zmodcourse_reg.

* Table Declaration
TABLES:
  zstudentt,
  zstudent_address,
  zregistration,
  zcourse,
  zfeedetails.

DATA:
  ok_code TYPE sy-ucomm.

* Type Declaration
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

* Internal Table and Work Area
DATA:
  lt_student TYPE TABLE OF ty_student,
  ls_student TYPE ty_student.

DATA:
  gv_date TYPE zer_date,
  gv_time TYPE zer_time,
  gv_name TYPE zer_nam.

* Course Variables
DATA:
  gv_seats_filled TYPE i,     "i = Integer
  gv_seats_avail  TYPE i.

* Table Control
CONTROLS:
  tbc_200 TYPE TABLEVIEW USING SCREEN 0200.

START-OF-SELECTION.

  CALL SCREEN 0100.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0400 OUTPUT.

  SET PF-STATUS 'STATUS_400'.
  SET TITLEBAR ' TITLE_400'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'STATUS_200'.
  SET TITLEBAR 'TITLE_200'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.

    WHEN 'SAV1'.

      gv_date = sy-datum.
      gv_time = sy-uzeit.
      gv_name = sy-uname.


* Student Master Save


      zstudentt-created_date = gv_date.
      zstudentt-created_time = gv_time.
      zstudentt-created_by   = gv_name.

      MODIFY zstudentt FROM zstudentt.


* Student Address Save


      zstudent_address-created_date = gv_date.
      zstudent_address-created_time = gv_time.
      zstudent_address-created_by   = gv_name.

      MODIFY zstudent_address
      FROM zstudent_address.


* Registration Save

      zregistration-created_date = gv_date.
      zregistration-created_time = gv_time.
      zregistration-created_by   = gv_name.

      MODIFY zregistration
      FROM zregistration.



      COMMIT WORK.

      MESSAGE 'Student Registration Saved Successfully'
      TYPE 'I'.


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

*      CLEAR lt_student.
*
*      IF zstudentt-student_id IS INITIAL.
**        AND zregistration-reg_id IS INITIAL.
*
*        SELECT a~student_id
*               a~name
*               a~department
*               a~academic_year
*               b~parent_name
*               b~address
*               b~parent_mobile_no
*               b~parent_email_id
*               c~reg_id
*               c~reg_date
*          FROM zstudentt AS a
*          INNER JOIN zstudent_address AS b
*          ON a~student_id = b~student_id
*          INNER JOIN zregistration AS c
*          ON a~student_id = c~student_id
*          INTO TABLE lt_student.
*
*      ENDIF.

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


*  SELECT COUNT(*)
*    INTO gv_seats_filled
*    FROM zregistration
*    WHERE course_id = zcourse-course_id.
*
*  gv_seats_avail =
*zcourse-max_strength - gv_seats_filled.

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

      gv_date = sy-datum.
      gv_time = sy-uzeit.
      gv_name = sy-uname.

      zcourse-created_date = gv_date.
      zcourse-created_time = gv_time.
      zcourse-created_by   = gv_name.

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

      gv_date = sy-datum.
      gv_time = sy-uzeit.
      gv_name = sy-uname.

      zfeedetails-created_date = gv_date.
      zfeedetails-created_time = gv_time.
      zfeedetails-created_by   = gv_name.

      MODIFY zfeedetails FROM zfeedetails.

      COMMIT WORK.

      MESSAGE 'Fee Details Saved Successfully'
      TYPE 'I'.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0100.

  ENDCASE.

ENDMODULE.
