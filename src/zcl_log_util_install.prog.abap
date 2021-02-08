*&---------------------------------------------------------------------*
*& Report ZCL_LOG_UTIL_INSTALL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcl_log_util_install.

DATA: ls_log_util_overlo TYPE zlog_util_overlo.

" Maintenance of table ZLOG_UTIL_OVERLO
SELECT SINGLE * FROM zlog_util_overlo INTO ls_log_util_overlo WHERE code = 'LOGINSTALL'.

IF sy-subrc NE 0.

  " Inserting line indicating table has been filled with this program
  "
  "             |       |           |  ZLOG_UTIL  |  000  |  E  |  APPEND     |     |             |       |     |  Message appended             |                |         |      |  A
  "             |       |           |  ZLOG_UTIL  |  000  |  E  |  IGNORE     |     |             |       |     |  Message to ignore            |                |         |      |  I
  "             |       |           |  ZLOG_UTIL  |  100  |  E  |             |     |  ZLOG_UTIL  |  000  |  W  |  AL                           |  PHA           |  BE     |  TA  |
  "             |       |           |  ZLOG_UTIL  |  100  |  E  |  MYSPOT     |     |  ZLOG_UTIL  |  000  |     |  Message overload using spot  |  "MYSPOT"      |         |      |
  "             |       |           |  ZLOG_UTIL  |  100  |  E  |  NEXTSPOT   |     |  ZLOG_UTIL  |  000  |     |  Message overload using spot  |  "NEXTSPOT"    |         |      |
  "             |       |           |  ZLOG_UTIL  |  104  |  E  |             |     |             |       |  S  |  NOT                          |  AN            |  ERROR  |      |
  " ZCLLOGUTIL  |  BC  |  OVER_LOG  |  VL         |  504  |  E  |             |     |  VL         |  504  |  W  |                               |                |         |      |
  " ZCLLOGUTIL  |  BC  |  OVER_LOG  |  ZLOG_UTIL  |  000  |  E  |             |     |             |  107  |     |                               |                |         |      |
  " ZCLLOGUTIL  |  BC  |  OVER_LOG  |  ZLOG_UTIL  |  105  |  I  |  MYNEWSPOT  |     |             |  113  |  E  |  MYNEWSPOT                    |                |         |      |
  " ZCLLOGUTIL  |  BC  |  OVER_LOG  |  ZLOG_UTIL  |  105  |  I  |  MYSPOT     |     |             |  113  |     |  MYSPOT                       |                |         |      |
  " ZCLLOGUTIL  |  BC  |  OVER_LOG  |  ZLOG_UTIL  |  105  |  I  |  MYSPOT     |  E  |             |  113  |     |  MYSPOT English version       |                |         |      |
  " ZCLLOGUTIL  |  BC  |  OVER_LOG  |  ZLOG_UTIL  |  105  |  I  |  MYSPOT     |  F  |             |  113  |     |  MYSPOT French version        |                |         |      |
  " ZCLLOGUTIL  |  BC  |  OVER_LOG  |  ZLOG_UTIL  |  105  |  I  |  MYSPOT     |  X  |             |  113  |     |  MYSPOT French version        |                |         |      |  X
  "
  ls_log_util_overlo-code = 'LOGINSTALL'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '000'.
  ls_log_util_overlo-input3  = 'E'.
  ls_log_util_overlo-input4  = 'APPEND'.
  ls_log_util_overlo-output4 = 'Message appended'.
  ls_log_util_overlo-output8 = 'A'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '000'.
  ls_log_util_overlo-input3  = 'E'.
  ls_log_util_overlo-input4  = 'IGNORE'.
  ls_log_util_overlo-output4 = 'Message to ignore'.
  ls_log_util_overlo-output8 = 'I'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '100'.
  ls_log_util_overlo-input3  = 'E'.
  ls_log_util_overlo-output1 = 'ZLOG_UTIL'.
  ls_log_util_overlo-output2 = '000'.
  ls_log_util_overlo-output3 = 'W'.
  ls_log_util_overlo-output4 = 'AL'.
  ls_log_util_overlo-output5 = 'PHA'.
  ls_log_util_overlo-output6 = 'BE'.
  ls_log_util_overlo-output7 = 'TA'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '100'.
  ls_log_util_overlo-input3  = 'E'.
  ls_log_util_overlo-input4  = 'MYSPOT'.
  ls_log_util_overlo-output1 = 'ZLOG_UTIL'.
  ls_log_util_overlo-output2 = '000'.
  ls_log_util_overlo-output4 = 'Message overload using spot'.
  ls_log_util_overlo-output5 = '"MYSPOT"'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '100'.
  ls_log_util_overlo-input3  = 'E'.
  ls_log_util_overlo-input4  = 'NEXTSPOT '.
  ls_log_util_overlo-output1 = 'ZLOG_UTIL'.
  ls_log_util_overlo-output2 = '000'.
  ls_log_util_overlo-output4 = 'Message overload using spot'.
  ls_log_util_overlo-output5 = '"NEXTSPOT"'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '104'.
  ls_log_util_overlo-input3  = 'E'.
  ls_log_util_overlo-output3 = 'S'.
  ls_log_util_overlo-output4 = 'NOT'.
  ls_log_util_overlo-output5 = 'AN'.
  ls_log_util_overlo-output6 = 'ERROR'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-code    = 'ZCLLOGUTIL'.
  ls_log_util_overlo-domaine = 'BC'.
  ls_log_util_overlo-data    = 'OVER_LOG'.
  ls_log_util_overlo-input1  = 'VL'.
  ls_log_util_overlo-input2  = '504'.
  ls_log_util_overlo-input3  = 'E'.
  ls_log_util_overlo-output1 = 'VL'.
  ls_log_util_overlo-output2 = '504'.
  ls_log_util_overlo-output3 = 'W'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-code    = 'ZCLLOGUTIL'.
  ls_log_util_overlo-domaine = 'BC'.
  ls_log_util_overlo-data    = 'OVER_LOG'.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '000'.
  ls_log_util_overlo-input3  = 'E'.
  ls_log_util_overlo-output2 = '107'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-code    = 'ZCLLOGUTIL'.
  ls_log_util_overlo-domaine = 'BC'.
  ls_log_util_overlo-data    = 'OVER_LOG'.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '105'.
  ls_log_util_overlo-input3  = 'I'.
  ls_log_util_overlo-input4  = 'MYNEWSPOT'.
  ls_log_util_overlo-output2 = '113'.
  ls_log_util_overlo-output3 = 'E'.
  ls_log_util_overlo-output4 = 'MYNEWSPOT'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-code    = 'ZCLLOGUTIL'.
  ls_log_util_overlo-domaine = 'BC'.
  ls_log_util_overlo-data    = 'OVER_LOG'.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '105'.
  ls_log_util_overlo-input3  = 'I'.
  ls_log_util_overlo-input4  = 'MYSPOT'.
  ls_log_util_overlo-output2 = '113'.
  ls_log_util_overlo-output4 = 'MYSPOT'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-code    = 'ZCLLOGUTIL'.
  ls_log_util_overlo-domaine = 'BC'.
  ls_log_util_overlo-data    = 'OVER_LOG'.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '105'.
  ls_log_util_overlo-input3  = 'I'.
  ls_log_util_overlo-input4  = 'MYSPOT'.
  ls_log_util_overlo-input5  = 'E'.
  ls_log_util_overlo-output2 = '113'.
  ls_log_util_overlo-output4 = 'MYSPOT English version'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-code    = 'ZCLLOGUTIL'.
  ls_log_util_overlo-domaine = 'BC'.
  ls_log_util_overlo-data    = 'OVER_LOG'.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '105'.
  ls_log_util_overlo-input3  = 'I'.
  ls_log_util_overlo-input4  = 'MYSPOT'.
  ls_log_util_overlo-input5  = 'F'.
  ls_log_util_overlo-output2 = '113'.
  ls_log_util_overlo-output4 = 'MYSPOT French version'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

  CLEAR ls_log_util_overlo.
  ls_log_util_overlo-code    = 'ZCLLOGUTIL'.
  ls_log_util_overlo-domaine = 'BC'.
  ls_log_util_overlo-data    = 'OVER_LOG'.
  ls_log_util_overlo-input1  = 'ZLOG_UTIL'.
  ls_log_util_overlo-input2  = '105'.
  ls_log_util_overlo-input3  = 'I'.
  ls_log_util_overlo-input4  = 'MYSPOT'.
  ls_log_util_overlo-input5  = 'X'.
  ls_log_util_overlo-output2 = '113'.
  ls_log_util_overlo-output4 = 'MYSPOT French version'.
  ls_log_util_overlo-output8 = 'X'.
  INSERT zlog_util_overlo FROM ls_log_util_overlo.

ENDIF.
