*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZLOG_UTIL_OVERLO
*   generation date: 20.11.2020 at 10:35:24
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZLOG_UTIL_OVERLO   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
