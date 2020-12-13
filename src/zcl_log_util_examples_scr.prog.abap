*&-------------------------------------------------------------------------&*
*&-------------------------------------------------------------------------&*
*&                                                                         &*
*&               Include  ZCL_LOG_UTIL_EXAMPLES_SCR                        &*
*&                                                                         &*
*&-------------------------------------------------------------------------&*
*&---------------------------[   MAIN INOS   ]-----------------------------&*
*&-------------------------------------------------------------------------&*
*&                                                                         &*
*&                                                                         &*
*&  Author      : Nicolas DUPRE (NDU90045)                                 &*
*&  Release     : 25.11.2020                                              &*
*&  Revision    : rev1                                                     &*
*&  Request     : NA                                                       &*
*&                                                                         &*
*&                                                                         &*
*&-------------------------------------------------------------------------&*
*&--------------------------[   DESCRIPTION   ]----------------------------&*
*&-------------------------------------------------------------------------&*
*&                                                                         &*
*&                                                                         &*
*&                                                                         &*
*&                                                                         &*
*&                                                                         &*
*&-------------------------------------------------------------------------&*
*&---------------------------[   REVISIONS   ]-----------------------------&*
*&-------------------------------------------------------------------------&*
*&                                                                         &*
*&---------------#---------------------------------------------------------&*
*& Date / Author | Updates Descriptions                                    &*
*&---------------#---------------------------------------------------------&*
*&               |                                                         &*
*&---------------#---------------------------------------------------------&*
*&               |                                                         &*
*&---------------#---------------------------------------------------------&*
*&-------------------------------------------------------------------------&*
SELECTION-SCREEN BEGIN OF BLOCK blkdemo WITH FRAME TITLE text-t01.
  PARAMETERS: p_dem000 RADIOBUTTON GROUP seld MODIF ID rad USER-COMMAND fm ,
              p_dem010 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem020 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem030 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem040 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem050 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem060 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem065 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem070 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem080 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem090 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem100 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem110 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem120 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem130 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem140 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem150 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem160 RADIOBUTTON GROUP seld MODIF ID rad                 .
*              p_dem999 RADIOBUTTON GROUP seld MODIF ID rad                 .
SELECTION-SCREEN END   OF BLOCK blkdemo.

SELECTION-SCREEN BEGIN OF BLOCK blkdeta WITH FRAME TITLE text-t02.
  PARAMETERS: p_seldem TYPE c LENGTH 8.
    SELECTION-SCREEN COMMENT /1(79) text-t99.
    SELECTION-SCREEN COMMENT /1(79) text-v01.

  SELECTION-SCREEN BEGIN OF BLOCK blk010 WITH FRAME TITLE text-010.
    SELECTION-SCREEN COMMENT /1(75) text-v02 MODIF ID 010.
    SELECTION-SCREEN COMMENT /1(75) text-v03 MODIF ID 010.
    SELECTION-SCREEN COMMENT /1(75) text-v04 MODIF ID 010.
  SELECTION-SCREEN END   OF BLOCK blk010.

  SELECTION-SCREEN BEGIN OF BLOCK blk020 WITH FRAME TITLE text-020.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 020.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 020.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 020.
    SELECTION-SCREEN COMMENT /1(75) text-v08 MODIF ID 020.
    SELECTION-SCREEN COMMENT /1(75) text-v09 MODIF ID 020.
  SELECTION-SCREEN END   OF BLOCK blk020.

  SELECTION-SCREEN BEGIN OF BLOCK blk030 WITH FRAME TITLE text-030.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 030.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 030.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 030.
    SELECTION-SCREEN COMMENT /1(75) text-v10 MODIF ID 030.
    SELECTION-SCREEN COMMENT /1(75) text-v11 MODIF ID 030.
  SELECTION-SCREEN END   OF BLOCK blk030.

  SELECTION-SCREEN BEGIN OF BLOCK blk040 WITH FRAME TITLE text-040.
    PARAMETERS : p_ebeln1 TYPE ekko-ebeln DEFAULT '4500001189' MODIF ID 040.
    SELECTION-SCREEN COMMENT /1(75) text-t99 MODIF ID 040.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 040.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 040.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 040.
    SELECTION-SCREEN COMMENT /1(75) text-v12 MODIF ID 040.
    SELECTION-SCREEN COMMENT /1(75) text-v14 MODIF ID 040.
  SELECTION-SCREEN END   OF BLOCK blk040.

  SELECTION-SCREEN BEGIN OF BLOCK blk050 WITH FRAME TITLE text-050.
    PARAMETERS : p_ebeln2 TYPE ekko-ebeln DEFAULT '4500001189' MODIF ID 050.
    SELECTION-SCREEN COMMENT /1(75) text-t99 MODIF ID 050.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 050.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 050.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 050.
    SELECTION-SCREEN COMMENT /1(75) text-v12 MODIF ID 050.
    SELECTION-SCREEN COMMENT /1(75) text-v15 MODIF ID 050.
    SELECTION-SCREEN COMMENT /1(75) text-v14 MODIF ID 050.
  SELECTION-SCREEN END   OF BLOCK blk050.

  SELECTION-SCREEN BEGIN OF BLOCK blk060 WITH FRAME TITLE text-060.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 060.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 060.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 060.
    SELECTION-SCREEN COMMENT /1(75) text-v16 MODIF ID 060.
    SELECTION-SCREEN COMMENT /1(75) text-v17 MODIF ID 060.
    SELECTION-SCREEN COMMENT /1(75) text-v14 MODIF ID 060.
  SELECTION-SCREEN END   OF BLOCK blk060.

  SELECTION-SCREEN BEGIN OF BLOCK blk065 WITH FRAME TITLE text-065.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 065.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 065.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 065.
    SELECTION-SCREEN COMMENT /1(75) text-v18 MODIF ID 065.
    SELECTION-SCREEN COMMENT /1(75) text-v19 MODIF ID 065.
    SELECTION-SCREEN COMMENT /1(75) text-v20 MODIF ID 065.
    SELECTION-SCREEN COMMENT /1(75) text-v21 MODIF ID 065.
    SELECTION-SCREEN COMMENT /1(75) text-v22 MODIF ID 065.
    SELECTION-SCREEN COMMENT /1(75) text-v23 MODIF ID 065.
  SELECTION-SCREEN END   OF BLOCK blk065.

  SELECTION-SCREEN BEGIN OF BLOCK blk070 WITH FRAME TITLE text-070.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 070.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 070.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 070.
    SELECTION-SCREEN COMMENT /1(75) text-v24 MODIF ID 070.
    SELECTION-SCREEN COMMENT /1(75) text-v25 MODIF ID 070.
    SELECTION-SCREEN COMMENT /1(75) text-v26 MODIF ID 070.
    SELECTION-SCREEN COMMENT /1(75) text-v27 MODIF ID 070.
  SELECTION-SCREEN END   OF BLOCK blk070.

  SELECTION-SCREEN BEGIN OF BLOCK blk080 WITH FRAME TITLE text-080.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v28 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v29 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v30 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v31 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v32 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v33 MODIF ID 080.
    SELECTION-SCREEN COMMENT /1(75) text-v34 MODIF ID 080.
  SELECTION-SCREEN END   OF BLOCK blk080.

  SELECTION-SCREEN BEGIN OF BLOCK blk090 WITH FRAME TITLE text-090.
    SELECTION-SCREEN COMMENT /1(75) text-v05 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v06 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v07 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v35 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v36 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v37 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v38 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v39 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v40 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v41 MODIF ID 090.
    SELECTION-SCREEN COMMENT /1(75) text-v42 MODIF ID 090.
  SELECTION-SCREEN END   OF BLOCK blk090.

  SELECTION-SCREEN BEGIN OF BLOCK blk100 WITH FRAME TITLE text-100.
    SELECTION-SCREEN COMMENT /1(75) text-v43 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v44 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v45 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v46 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v47 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v48 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v49 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v50 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v51 MODIF ID 100.
    SELECTION-SCREEN COMMENT /1(75) text-v52 MODIF ID 100.
  SELECTION-SCREEN END   OF BLOCK blk100.

  SELECTION-SCREEN BEGIN OF BLOCK blk110 WITH FRAME TITLE text-110.
    SELECTION-SCREEN COMMENT /1(75) text-v43 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v44 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v45 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v46 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v53 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v54 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v55 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v56 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v57 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v58 MODIF ID 110.
    SELECTION-SCREEN COMMENT /1(75) text-v59 MODIF ID 110.
  SELECTION-SCREEN END   OF BLOCK blk110.

  SELECTION-SCREEN BEGIN OF BLOCK blk120 WITH FRAME TITLE text-120.
    SELECTION-SCREEN COMMENT /1(75) text-v60 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v44 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v45 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v46 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v47 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v62 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v63 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v64 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v65 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v66 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v67 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v71 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v72 MODIF ID 120.
    SELECTION-SCREEN COMMENT /1(75) text-v73 MODIF ID 120.

  SELECTION-SCREEN END   OF BLOCK blk120.

  SELECTION-SCREEN BEGIN OF BLOCK blk130 WITH FRAME TITLE text-130.
    SELECTION-SCREEN COMMENT /1(75) text-v43 MODIF ID 130.
    SELECTION-SCREEN COMMENT /1(75) text-v44 MODIF ID 130.
    SELECTION-SCREEN COMMENT /1(75) text-v45 MODIF ID 130.
    SELECTION-SCREEN COMMENT /1(75) text-v46 MODIF ID 130.
    SELECTION-SCREEN COMMENT /1(75) text-v69 MODIF ID 130.
    SELECTION-SCREEN COMMENT /1(75) text-v70 MODIF ID 130.
    SELECTION-SCREEN COMMENT /1(75) text-v27 MODIF ID 130.
  SELECTION-SCREEN END   OF BLOCK blk130.

  SELECTION-SCREEN BEGIN OF BLOCK blk140 WITH FRAME TITLE text-140.
    SELECTION-SCREEN COMMENT /1(75) text-v74 MODIF ID 140.
    SELECTION-SCREEN COMMENT /1(75) text-v44 MODIF ID 140.
    SELECTION-SCREEN COMMENT /1(75) text-v45 MODIF ID 140.
    SELECTION-SCREEN COMMENT /1(75) text-v46 MODIF ID 140.
    SELECTION-SCREEN COMMENT /1(75) text-v75 MODIF ID 140.
    SELECTION-SCREEN COMMENT /1(75) text-v76 MODIF ID 140.
    SELECTION-SCREEN COMMENT /1(75) text-v77 MODIF ID 140.
    SELECTION-SCREEN COMMENT /1(75) text-v78 MODIF ID 140.
    SELECTION-SCREEN COMMENT /1(75) text-v79 MODIF ID 140.
  SELECTION-SCREEN END   OF BLOCK blk140.

  SELECTION-SCREEN BEGIN OF BLOCK blk150 WITH FRAME TITLE text-150.
    SELECTION-SCREEN COMMENT /1(75) text-v80 MODIF ID 150.
    SELECTION-SCREEN COMMENT /1(75) text-v44 MODIF ID 150.
    SELECTION-SCREEN COMMENT /1(75) text-v45 MODIF ID 150.
    SELECTION-SCREEN COMMENT /1(75) text-v46 MODIF ID 150.
    SELECTION-SCREEN COMMENT /1(75) text-v81 MODIF ID 150.
    SELECTION-SCREEN COMMENT /1(75) text-v82 MODIF ID 150.
  SELECTION-SCREEN END   OF BLOCK blk150.

  SELECTION-SCREEN BEGIN OF BLOCK blk160 WITH FRAME TITLE text-160.
    SELECTION-SCREEN COMMENT /1(75) text-v80 MODIF ID 160.
    SELECTION-SCREEN COMMENT /1(75) text-v44 MODIF ID 160.
    SELECTION-SCREEN COMMENT /1(75) text-v45 MODIF ID 160.
    SELECTION-SCREEN COMMENT /1(75) text-v46 MODIF ID 160.
    SELECTION-SCREEN COMMENT /1(75) text-v83 MODIF ID 160.
    SELECTION-SCREEN COMMENT /1(75) text-v84 MODIF ID 160.
    SELECTION-SCREEN COMMENT /1(75) text-v85 MODIF ID 160.
  SELECTION-SCREEN END   OF BLOCK blk160.

SELECTION-SCREEN END   OF BLOCK blkdeta.



"&-------------------------------------------------------------------------&"
"&   Screen Request                                                        &"
"&-------------------------------------------------------------------------&"
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_alvvar.
*  PERFORM F4_LAYOUTS
*    USING cl_salv_layout=>restrict_none
* CHANGING p_alvvar.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      program_name   = syst-cprog
*      dynpro_number  = syst-dynnr
*    IMPORTING
*      file_name      = p_file
*  .



"&-------------------------------------------------------------------------&"
"&   Screen Validations                                                    &"
"&-------------------------------------------------------------------------&"
AT SELECTION-SCREEN OUTPUT.
  DATA: lv_param TYPE string.
  DATA: lv_x TYPE c.

  LOOP AT SCREEN.
    IF screen-name EQ 'P_SELDEM'.
      IF p_dem010 EQ 'X'. p_seldem = 'Demo 010'.ENDIF.
      IF p_dem020 EQ 'X'. p_seldem = 'Demo 020'.ENDIF.
      IF p_dem030 EQ 'X'. p_seldem = 'Demo 030'.ENDIF.
      IF p_dem040 EQ 'X'. p_seldem = 'Demo 040'.ENDIF.
      IF p_dem050 EQ 'X'. p_seldem = 'Demo 050'.ENDIF.
      IF p_dem060 EQ 'X'. p_seldem = 'Demo 060'.ENDIF.
      IF p_dem065 EQ 'X'. p_seldem = 'Demo 06'.ENDIF.
      IF p_dem070 EQ 'X'. p_seldem = 'Demo 070'.ENDIF.
      IF p_dem080 EQ 'X'. p_seldem = 'Demo 080'.ENDIF.
      IF p_dem090 EQ 'X'. p_seldem = 'Demo 090'.ENDIF.
      IF p_dem100 EQ 'X'. p_seldem = 'Demo 100'.ENDIF.
      IF p_dem110 EQ 'X'. p_seldem = 'Demo 110'.ENDIF.
      IF p_dem120 EQ 'X'. p_seldem = 'Demo 120'.ENDIF.
      IF p_dem130 EQ 'X'. p_seldem = 'Demo 130'.ENDIF.
      IF p_dem140 EQ 'X'. p_seldem = 'Demo 140'.ENDIF.
      IF p_dem150 EQ 'X'. p_seldem = 'Demo 150'.ENDIF.
      IF p_dem160 EQ 'X'. p_seldem = 'Demo 160'.ENDIF.

      screen-input = 0.
    ENDIF.

    IF screen-group1 EQ '010'.
      IF p_dem010 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '020'.
      IF p_dem020 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '030'.
      IF p_dem030 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '040'.
      IF p_dem040 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '050'.
      IF p_dem050 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '060'.
      IF p_dem060 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '065'.
      IF p_dem065 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '070'.
      IF p_dem070 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '080'.
      IF p_dem080 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '090'.
      IF p_dem090 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '100'.
      IF p_dem100 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '110'.
      IF p_dem110 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '120'.
      IF p_dem120 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '130'.
      IF p_dem130 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '140'.
      IF p_dem140 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '150'.
      IF p_dem150 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF screen-group1 EQ '160'.
      IF p_dem160 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.
