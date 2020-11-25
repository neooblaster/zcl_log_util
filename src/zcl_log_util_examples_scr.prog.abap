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
  PARAMETERS: p_dem01 RADIOBUTTON GROUP seld MODIF ID d01 USER-COMMAND fm ,
              p_dem02 RADIOBUTTON GROUP seld MODIF ID d02                 .
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
