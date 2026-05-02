*&---------------------------------------------------------------------*
*& Report ZAR_SQL_ABAP_CODE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zar_sql_abap_code.

*define structure
TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbeln_va,
          erdat TYPE erdat,
          erzet TYPE erzet,
          ernam TYPE ernam,
          audat TYPE audat,
          vbtyp TYPE vbtyp,
        END OF ty_vbak.

*&DEFINE INERNAL TABLE
DATA : lt_vbak TYPE TABLE OF ty_vbak,

*&DEFINE WORK AREA
       ls_vbak TYPE ty_vbak.

**&DEFINE PARAMETER
PARAMETERS : p_vbeln TYPE vbeln_va.
*NOW WE GO FOR DEFINE SELECT OPTION NEED VARIABLE AS USUAL
*DATA : lv_vbeln TYPE vbeln_va.
*SELECT-OPTIONS : s_vbeln FOR lv_vbeln.

*&BRING THE DATA BASED ON THE ABOVE PARAMETER VALUE.
*&DIRECT GO FOR * BUT PROBLEM IS THERE MORE DATA BECOME MEANINGLESS AND LEANTHY, APPLICATION LAYER HEAVY
*&INSTEAD OF THIS BRING THOSE WHO ARE NECESSARY

*SELECT vbeln erdat erzet ernam audat vbtyp
*  FROM vbak "NAME OF TABLE
*  INTO TABLE lt_vbak "INTO INTERNAL TABLE TO STORE
*  WHERE vbeln = p_vbeln. "WHERE VBELN - PRIMARY KEY = P_vbeln - INPUT GIVEN BY THE USER

*SELECT vbeln erdat erzet ernam audat vbtyp
*  FROM vbak "NAME OF TABLE
*  INTO TABLE lt_vbak "INTO INTERNAL TABLE TO STORE
*   WHERE vbeln IN s_vbeln.

*DIRECTLY STORE IT IN MY WORK AREA CODE
SELECT SINGLE vbeln erdat erzet ernam audat vbtyp "SINGLE KEYWORD- WHY?
  FROM vbak "NAME OF TABLE
  INTO ls_vbak "WITHOUT USE INTERNAL TABLE. STORE IN WORK AREA
  WHERE vbeln = p_vbeln.

  WRITE :/ ls_vbak-vbeln, ls_vbak-erdat, ls_vbak-erzet, ls_vbak-ernam, ls_vbak-audat, ls_vbak-vbtyp.

*3 WAYS TO BRING THE DATA 1. USE THE PARAMETER BRING THE DATA IN INTERNAL TABLE PERFORM THE LOOP AND DO WHATEVER YOU WANT 2. SELECT OPTION 3. DIRECTLY USING SINGLE RECORD AND STORE IN WORK AREA
"CAN DISPLAY DATA AND PERFORM ANY ACTION.
*
*LOOP AT lt_vbak INTO ls_vbak.
*  WRITE :/ ls_vbak-vbeln, ls_vbak-erdat, ls_vbak-erzet, ls_vbak-ernam, ls_vbak-audat, ls_vbak-vbtyp.
*
*
*ENDLOOP.
*BEST PRACTICE IS NEVER USE SELECT QUERRY INSIDE LOOP.
*WE ARE BRING 1 RECORD/1 ROW CAN I DIRECTLY STORE IT IN MY WORK AREA IF BRING ONLY 1 ROW
