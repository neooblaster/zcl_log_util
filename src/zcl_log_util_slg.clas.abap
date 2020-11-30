class ZCL_LOG_UTIL_SLG definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods SET_OBJECT
    importing
      !I_SLG_OBJECT type BALOBJ_D
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SLG .
  methods SET_SUB_OBJECT
    importing
      !I_SLG_SUB_OBJECT type BALSUBOBJ
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SLG .
  methods SET_EXTERNAL_NUMBER
    importing
      !I_SLG_EXT_NUMBER type BALNREXT
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SLG .
  methods SET_RETENTION
    importing
      !I_SLG_RETENTION_DAYS type I
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SLG .
  methods LOG
    importing
      !I_MSGID type SY-MSGID optional
      !I_MSGNO type SY-MSGNO optional
      !I_MSGTY type SY-MSGTY optional
      !I_MSGV1 type SY-MSGV1 optional
      !I_MSGV2 type SY-MSGV2 optional
      !I_MSGV3 type SY-MSGV3 optional
      !I_MSGV4 type SY-MSGV4 optional
      !I_MSGXX_FLG type ABAP_BOOL optional
      !I_MSGTX type STRING optional
      !I_MSGTX_FLG type ABAP_BOOL optional
    preferred parameter I_MSGTX .
  methods ENABLE .
  methods DISABLE .
  methods IS_ENABLED
    returning
      value(R_ENABLED) type ABAP_BOOL .
  methods DISPLAY .
  methods _CREATE .
  methods _SAVE .
  methods _DESTRUCTOR .
  methods GET_OBJECT
    returning
      value(R_SLG_OBJECT) type BALOBJ_D .
  methods GET_SUB_OBJECT
    returning
      value(R_SLG_SUB_OBJECT) type BALSUBOBJ .
  methods GET_EXTERNAL_NUMBER
    returning
      value(R_SLG_EXT_NUMBER) type BALNREXT .
  methods GET_RETENTION
    returning
      value(R_SLG_RETENTION) type I .
protected section.
private section.

  data _SLG_ENABLED type C .
  data _SLG_HANDLER type BALLOGHNDL .
  data _SLG_OBJECT type BALOBJ_D value 'ZLOGUTIL' ##NO_TEXT.
  data _SLG_SUB_OBJECT type BALSUBOBJ .
  data _SLG_EXT_NUMBER type BALNREXT .
  data _SLG_PROBCLASS type BALPROBCL value '4' ##NO_TEXT.
  data _SLG_RETENTION type I value 30 ##NO_TEXT.
  class-data _PROBCLASS_VERY_HIGH type BALPROBCL value '1' ##NO_TEXT.
  class-data _PROBCLASS_HIGH type BALPROBCL value '2' ##NO_TEXT.
  class-data _PROBCLASS_MEDIUM type BALPROBCL value '3' ##NO_TEXT.
  class-data _PROBCLASS_LOW type BALPROBCL value '4' ##NO_TEXT.
  class-data _PROBCLASS_NONE type BALPROBCL value ' ' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_LOG_UTIL_SLG IMPLEMENTATION.


  method CONSTRUCTOR.

  endmethod.


  method DISABLE.

    me->_slg_enabled = ''.

  endmethod.


  method DISPLAY.

    DATA:
        ls_log_filter TYPE bal_s_lfil ,
        lt_log_header TYPE balhdr_t   ,
        lt_log_handle TYPE bal_t_logh ,
        lt_log_loaded TYPE bal_t_logh .

    FIELD-SYMBOLS:
                 <fs_log_header_s> TYPE balhdr.


    " Check if SLG is enabled
    CHECK me->is_enabled( ) EQ 'X'.


    CALL FUNCTION 'BAL_FILTER_CREATE'
      EXPORTING
        i_object       = me->_slg_object       " Default "ZLOGUTIL"
        i_subobject    = me->_slg_sub_object   "
        i_extnumber    = me->_slg_ext_number   "
        i_aldate_from  = sy-datum              " 20200430
        i_aldate_to    = sy-datum              " 20200430
        i_altime_from  = '000000'              " 000000
        i_altime_to    = '235959'              " 235959
        i_probclass_to = me->_slg_probclass    "
        i_alprog       = '*'                   "
        i_altcode      = '*'                   "
        i_aluser       = '*'                   "
        i_almode       = '*'                   "
      IMPORTING
        e_s_log_filter = ls_log_filter
      EXCEPTIONS
        OTHERS         = 1.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAL_DB_SEARCH'
        EXPORTING
          i_s_log_filter = ls_log_filter
        IMPORTING
          e_t_log_header = lt_log_header
        EXCEPTIONS
          OTHERS         = 1.

      IF sy-subrc EQ 0.

        LOOP AT lt_log_header ASSIGNING <fs_log_header_s>.
          CALL FUNCTION 'BAL_LOG_EXIST'
            EXPORTING
              i_log_handle  = <fs_log_header_s>-log_handle
            EXCEPTIONS
              log_not_found = 1.
          IF sy-subrc = 0.
            INSERT <fs_log_header_s>-log_handle INTO TABLE lt_log_handle.
            DELETE lt_log_header.
          ENDIF.
        ENDLOOP.

        CALL FUNCTION 'BAL_DB_LOAD'
          EXPORTING
            i_t_log_header         = lt_log_header
            i_do_not_load_messages = ' '
          IMPORTING
            e_t_log_handle         = lt_log_loaded
          EXCEPTIONS
            OTHERS                 = 0.

        IF sy-subrc NE 0.
          " @TODO : implement error message
        ENDIF.

        INSERT LINES OF lt_log_loaded INTO TABLE lt_log_handle.

        CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
          EXPORTING
            i_t_log_handle = lt_log_handle
            "i_s_display_profile = ls_display_profile
            "i_srt_by_timstmp    = lv_sort_by_ts " True Or False
          EXCEPTIONS
            no_authority   = 1
            OTHERS         = 2.

        IF NOT lt_log_loaded[] IS INITIAL.
          CALL FUNCTION 'BAL_GLB_MEMORY_REFRESH'
            EXPORTING
              i_refresh_all            = ' ' " True or false
              i_t_logs_to_be_refreshed = lt_log_loaded
            EXCEPTIONS
              OTHERS                   = 0.
        ENDIF.
      ELSE.
        " @TODO : implement error message

      ENDIF.

    ELSE.
      " @TODO : implement error message

    ENDIF.

  endmethod.


  method ENABLE.

    me->_slg_enabled = 'X'.

  endmethod.


  method GET_EXTERNAL_NUMBER.

    r_slg_ext_number = me->_slg_ext_number.

  endmethod.


  method GET_OBJECT.

    r_slg_object = me->_slg_object.

  endmethod.


  method GET_RETENTION.

    r_slg_retention = me->_slg_retention.

  endmethod.


  method GET_SUB_OBJECT.

    r_slg_sub_object = me->_slg_sub_object.

  endmethod.


  method IS_ENABLED.

    r_enabled = me->_slg_enabled.

  endmethod.


  method LOG.

    DATA:
        ls_s_msg      TYPE bal_s_msg           ,
        "lv_probclass TYPE bal_s_msg-probclass ,
        lv_free_text  TYPE c LENGTH 1024       ,
        lv_msgtx_flag TYPE c LENGTH 1          .


    " If Application Log is not handled, create BAL
    IF me->_SLG_HANDLER IS INITIAL.
      me->_create( ).
    ENDIF.

    " Let considering if ONLY i_msgtx (PREFERED) is supplied
    " So, flag indicator is not enabled => set value to X
    IF    i_msgid     IS NOT SUPPLIED
      AND i_msgno     IS NOT SUPPLIED
      AND i_msgty     IS NOT SUPPLIED
      AND i_msgv1     IS NOT SUPPLIED
      AND i_msgv2     IS NOT SUPPLIED
      AND i_msgv3     IS NOT SUPPLIED
      AND i_msgv4     IS NOT SUPPLIED
      AND i_msgxx_flg IS NOT SUPPLIED
      AND i_msgtx     IS     SUPPLIED AND i_msgtx IS NOT INITIAL
      AND i_msgtx_flg IS NOT SUPPLIED.
      lv_msgtx_flag = 'X'.
    ENDIF.
    " Managing Standard Message (sy-msgxx)
    IF i_msgxx_flg IS SUPPLIED AND i_msgxx_flg EQ 'X'.
      ls_s_msg-msgid = i_msgid .
      ls_s_msg-msgno = i_msgno .
      ls_s_msg-msgty = i_msgty .
      ls_s_msg-msgv1 = i_msgv1 .
      ls_s_msg-msgv2 = i_msgv2 .
      ls_s_msg-msgv3 = i_msgv3 .
      ls_s_msg-msgv4 = i_msgv4 .

      ls_s_msg-probclass = me->_slg_probclass.

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_s_msg       = ls_s_msg
          i_log_handle  = me->_slg_handler
        EXCEPTIONS
          log_not_found = 1
          OTHERS        = 2.

      IF sy-subrc NE 0.
        " TODO : implement error message
      ENDIF.
    ENDIF.

    " Managing Free Message Text
    IF   ( i_msgtx_flg   IS SUPPLIED AND i_msgtx_flg EQ 'X' )
      OR ( lv_msgtx_flag EQ 'X' ).

      lv_free_text = i_msgtx.
      CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
        EXPORTING
          i_log_handle              = me->_slg_handler
          i_msgty                   = i_msgty
          i_probclass               = me->_slg_probclass
          i_text                    = lv_free_text
*         I_S_CONTEXT               =
*         I_S_PARAMS                =
*         I_DETLEVEL                = '1'
*       IMPORTING
*         E_S_MSG_HANDLE            =
*         E_MSG_WAS_LOGGED          =
*         E_MSG_WAS_DISPLAYED       =
       EXCEPTIONS
          log_not_found             = 1
          msg_inconsistent          = 2
          log_is_full               = 3
          OTHERS                    = 4.

      IF sy-subrc <> 0.
        " TODO : implement error message
      ENDIF.

    ENDIF.

    " Save entry
    me->_save( ).

  endmethod.


  method SET_EXTERNAL_NUMBER.

    me->_slg_ext_number = i_slg_ext_number.

    self = me.

  endmethod.


  method SET_OBJECT.

    me->_slg_object = i_slg_object.

    self = me.

  endmethod.


  method SET_RETENTION.

    me->_slg_retention = i_slg_retention_days.

    self = me.

  endmethod.


  method SET_SUB_OBJECT.

    me->_slg_sub_object = i_slg_sub_object.

    self = me.

  endmethod.


  method _CREATE.

    DATA:
        ls_bal_s_log TYPE bal_s_log.


    " --------------------------------------------------------------
    " • Initialization
    " --------------------------------------------------------------
    ls_bal_s_log-object     = me->_slg_object.
    ls_bal_s_log-subobject  = me->_slg_sub_object.
    ls_bal_s_log-extnumber  = me->_slg_ext_number.
    ls_bal_s_log-aluser     = sy-uname.                     " @TODO : VOir pour customized
    ls_bal_s_log-alprog     = sy-repid.                     " @TODO : VOir pour customized
    ls_bal_s_log-aldate_del = sy-datum + me->_slg_retention.



    " --------------------------------------------------------------
    " • Starting Application Log handler
    " --------------------------------------------------------------
    IF me->_slg_handler IS INITIAL.
      CALL FUNCTION 'BAL_LOG_CREATE'
        EXPORTING
          i_s_log                 = ls_bal_s_log
        IMPORTING
          e_log_handle            = me->_slg_handler
        EXCEPTIONS
          log_header_inconsistent = 1
          OTHERS                  = 2.

      IF sy-subrc NE 0.
        " 012 :: Appl. Log is enabled but something happens wrong (check SLG Object & Sub)
        MESSAGE e012.
      ENDIF.

    ENDIF.

  endmethod.


  method _DESTRUCTOR.
  endmethod.


  method _SAVE.

    DATA: lt_log_hdl TYPE bal_t_logh.

    APPEND me->_slg_handler TO lt_log_hdl.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
*        i_client          = sy-mandt
*        i_in_update_task  = ' '
*       i_save_all        = 'X'
         i_t_log_handle   = lt_log_hdl
*      IMPORTING
*        e_new_lognumbers =
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    IF sy-subrc NE 0.
      " @TODO : Implement error message
    ENDIF.

  endmethod.
ENDCLASS.
