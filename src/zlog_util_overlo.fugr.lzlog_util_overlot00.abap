*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLOG_UTIL_OVERLO................................*
DATA:  BEGIN OF STATUS_ZLOG_UTIL_OVERLO              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLOG_UTIL_OVERLO              .
CONTROLS: TCTRL_ZLOG_UTIL_OVERLO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLOG_UTIL_OVERLO              .
TABLES: ZLOG_UTIL_OVERLO               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
