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
  PARAMETERS: p_dem010 RADIOBUTTON GROUP seld MODIF ID rad USER-COMMAND fm ,
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
              p_dem160 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem170 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem180 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem190 RADIOBUTTON GROUP seld MODIF ID rad                 ,
              p_dem999 RADIOBUTTON GROUP seld MODIF ID rad                 .
SELECTION-SCREEN END   OF BLOCK blkdemo.

SELECTION-SCREEN BEGIN OF BLOCK blkdeta WITH FRAME TITLE text-t02.
  PARAMETERS: p_seldem TYPE c LENGTH 7.
SELECTION-SCREEN END   OF BLOCK blkdeta.


*SELECTION-SCREEN BEGIN OF BLOCK blk001 WITH FRAME TITLE TEXT-ft1.
*  SELECT-OPTIONS s_matnr   FOR  mara-matnr                     NO INTERVALS . " Code Article
*  SELECT-OPTIONS s_vkorg   FOR  mvke-vkorg          OBLIGATORY NO INTERVALS . " Orgnisation Commerciale
*  SELECT-OPTIONS s_vtweg   FOR  mvke-vtweg          OBLIGATORY NO INTERVALS . " Canal de distribution
*  SELECT-OPTIONS s_lgort   FOR  mard-lgort                     NO INTERVALS . " Magasin
*SELECTION-SCREEN END   OF BLOCK blk001.
*
*SELECTION-SCREEN BEGIN OF BLOCK blk002 WITH FRAME TITLE TEXT-ft2.
*  PARAMETERS     p_lfile   LIKE filename-fileintern OBLIGATORY DEFAULT 'Z_WEAVY_MATERIAL' . " Emplacement Logique du fichier
*  PARAMETERS     p_prefix  TYPE c LENGTH 100 DEFAULT 'WEAVY_ARTICLE'             . " Préfix du nom de fichier extrait
*  PARAMETERS     p_matid   TYPE c LENGTH 100 DEFAULT 'ARTICLES'                  . " Identifiant CSV Article
*  PARAMETERS     p_bomid   TYPE c LENGTH 100 DEFAULT 'BOM'                       . " identifiant CSV BOM
*SELECTION-SCREEN END   OF BLOCK blk002.
*
*SELECTION-SCREEN BEGIN OF BLOCK blk003 WITH FRAME TITLE TEXT-ft3.
*  PARAMETERS     p_alv     AS CHECKBOX                                      . " Afficher le résultat dans un rapport ALV
*  PARAMETERS     p_dismat  RADIOBUTTON GROUP disp                           . " Afficher le rapport ALV de la selection des articles
*  PARAMETERS     p_disbom  RADIOBUTTON GROUP disp                           . " Afficher le rapport ALV de la selection des BOM
*SELECTION-SCREEN END   OF BLOCK blk003.



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
*AT SELECTION-SCREEN.
*  " If Checkbox to extract result to CSV
*  " Field p_lpath & p_filen must be filled
*  IF p_tocsv EQ 'X'.
*    " Please specify a target file on computer
*    IF p_file IS INITIAL.
*      MESSAGE text-e01 TYPE 'E'.
*    ENDIF.
*  ENDIF.
