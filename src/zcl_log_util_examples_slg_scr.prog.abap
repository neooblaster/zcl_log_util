*&-------------------------------------------------------------------------&*
*&-------------------------------------------------------------------------&*
*&                                                                         &*
*&               Include  ZCL_LOG_UTIL_EXAMPLES_SLG_SCR                    &*
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
              p_dem070 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem080 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem085 RADIOBUTTON GROUP seld MODIF ID rad                 .
*              p_dem999 RADIOBUTTON GROUP seld MODIF ID rad                 .
SELECTION-SCREEN END   OF BLOCK blkdemo.

SELECTION-SCREEN BEGIN OF BLOCK blkdeta WITH FRAME TITLE text-t02.
  PARAMETERS: p_seldem TYPE c LENGTH 8.
    SELECTION-SCREEN COMMENT /1(79) text-t99.
    SELECTION-SCREEN COMMENT /1(79) text-v01.

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

  SELECTION-SCREEN BEGIN OF BLOCK blk085 WITH FRAME TITLE text-085.
    SELECTION-SCREEN COMMENT /1(75) text-v35 MODIF ID 085.
    SELECTION-SCREEN COMMENT /1(75) text-v36 MODIF ID 085.
    SELECTION-SCREEN COMMENT /1(75) text-v37 MODIF ID 085.
    SELECTION-SCREEN COMMENT /1(75) text-v38 MODIF ID 085.
    SELECTION-SCREEN COMMENT /1(75) text-v39 MODIF ID 085.
    SELECTION-SCREEN COMMENT /1(75) text-v40 MODIF ID 085.
    SELECTION-SCREEN COMMENT /1(75) text-v41 MODIF ID 085.
  SELECTION-SCREEN END   OF BLOCK blk085.

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
      IF p_dem070 EQ 'X'. p_seldem = 'Demo 070'.ENDIF.
      IF p_dem080 EQ 'X'. p_seldem = 'Demo 080'.ENDIF.
      IF p_dem085 EQ 'X'. p_seldem = 'Demo 085'.ENDIF.

      screen-input = 0.
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

    IF screen-group1 EQ '085'.
      IF p_dem085 EQ 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.
