CLASS zcl_Log_Util_Tc DEFINITION DEFERRED.
CLASS zcl_Log_Util    DEFINITION LOCAL FRIENDS zcl_Log_Util_Tc.

CLASS zcl_Log_Util_Tc DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>zcl_Log_Util_Tc
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>ZCL_LOG_UTIL
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_Cut TYPE REF TO zcl_Log_Util.  "class under test

    CLASS-METHODS: class_Setup.
    CLASS-METHODS: class_Teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: a FOR TESTING.
    METHODS: batch FOR TESTING.
    METHODS: define FOR TESTING.
    METHODS: display FOR TESTING.
    METHODS: e FOR TESTING.
    METHODS: factory FOR TESTING.
    METHODS: get_Absolute_Name FOR TESTING.
    METHODS: get_Relative_Name FOR TESTING.
    METHODS: i FOR TESTING.
    METHODS: log FOR TESTING.
    METHODS: merging FOR TESTING.
    METHODS: overload FOR TESTING.
    METHODS: s FOR TESTING.
    METHODS: set_Log_Table FOR TESTING.
    METHODS: slg FOR TESTING.
    METHODS: split_Text_To_Msgvx FOR TESTING.
    METHODS: spot FOR TESTING.
    METHODS: w FOR TESTING.
    METHODS: _convert_Table FOR TESTING.
    METHODS: _count_Table_Lines FOR TESTING.
    METHODS: _get_Checked_Messages FOR TESTING.
    METHODS: _update_Field_Of_Structure FOR TESTING.
ENDCLASS.       "zcl_Log_Util_Tc


CLASS zcl_Log_Util_Tc IMPLEMENTATION.

  METHOD class_Setup.



  ENDMETHOD.


  METHOD class_Teardown.



  ENDMETHOD.


  METHOD setup.


    CREATE OBJECT f_Cut.
  ENDMETHOD.


  METHOD teardown.



  ENDMETHOD.


  METHOD a.

*    data i_Log_Content type any.
*    data i_Log_Msgid type syst_Msgid.
*    data i_Log_Msgno type syst_Msgno.
*    data i_Log_Msgv1 type syst_Msgv.
*    data i_Log_Msgv2 type syst_Msgv.
*    data i_Log_Msgv3 type syst_Msgv.
*    data i_Log_Msgv4 type syst_Msgv.
*    data self type ref to zcl_Log_Util.
*
*    self = f_Cut->a(
**       I_LOG_CONTENT = i_Log_Content
**       I_LOG_MSGID = i_Log_Msgid
**       I_LOG_MSGNO = i_Log_Msgno
**       I_LOG_MSGV1 = i_Log_Msgv1
**       I_LOG_MSGV2 = i_Log_Msgv2
**       I_LOG_MSGV3 = i_Log_Msgv3
**       I_LOG_MSGV4 = i_Log_Msgv4
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD batch.

*    data r_Batch type ref to zcl_Log_Util_Batch.
*
*    r_Batch = f_Cut->batch(  ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = r_Batch
*      exp   = r_Batch          "<--- please adapt expected value
*    " msg   = 'Testing value r_Batch'
**     level =
*    ).
  ENDMETHOD.


  METHOD define.

*    data i_Structure type any.
*    data self type ref to zcl_Log_Util_Define.
*
*    self = f_Cut->define( i_Structure ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD display.

*    data c_Log_Table type .
*
*    f_Cut->display(
**     CHANGING
**       C_LOG_TABLE = c_Log_Table
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = c_Log_Table
*      exp   = c_Log_Table          "<--- please adapt expected value
*    " msg   = 'Testing value c_Log_Table'
**     level =
*    ).
  ENDMETHOD.


  METHOD e.

*    data i_Log_Content type any.
*    data i_Log_Msgid type syst_Msgid.
*    data i_Log_Msgno type syst_Msgno.
*    data i_Log_Msgv1 type syst_Msgv.
*    data i_Log_Msgv2 type syst_Msgv.
*    data i_Log_Msgv3 type syst_Msgv.
*    data i_Log_Msgv4 type syst_Msgv.
*    data self type ref to zcl_Log_Util.
*
*    self = f_Cut->e(
**       I_LOG_CONTENT = i_Log_Content
**       I_LOG_MSGID = i_Log_Msgid
**       I_LOG_MSGNO = i_Log_Msgno
**       I_LOG_MSGV1 = i_Log_Msgv1
**       I_LOG_MSGV2 = i_Log_Msgv2
**       I_LOG_MSGV3 = i_Log_Msgv3
**       I_LOG_MSGV4 = i_Log_Msgv4
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD factory.

    DATA e_Log_Util TYPE REF TO zcl_Log_Util.
    DATA c_Log_Table TYPE TABLE OF bapiret2.

    zcl_Log_Util=>factory(
     IMPORTING
       e_log_util = e_Log_Util
     CHANGING
       c_log_table = c_Log_Table
    ).

    cl_Abap_Unit_Assert=>assert_Equals(
      act   = e_Log_Util
      exp   = e_Log_Util          "<--- please adapt expected value
    " msg   = 'Testing value e_Log_Util'
*     level =
    ).
    cl_Abap_Unit_Assert=>assert_Equals(
      act   = c_Log_Table
      exp   = c_Log_Table          "<--- please adapt expected value
    " msg   = 'Testing value c_Log_Table'
*     level =
    ).
  ENDMETHOD.


  METHOD get_Absolute_Name.

*    data i_Element type any.
*    data r_Abs_Name type string.
*
*    r_Abs_Name = zcl_Log_Util=>get_Absolute_Name( i_Element ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = r_Abs_Name
*      exp   = r_Abs_Name          "<--- please adapt expected value
*    " msg   = 'Testing value r_Abs_Name'
**     level =
*    ).
  ENDMETHOD.


  METHOD get_Relative_Name.

*    data i_Element type any.
*    data r_Rel_Name type string.
*
*    r_Rel_Name = zcl_Log_Util=>get_Relative_Name( i_Element ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = r_Rel_Name
*      exp   = r_Rel_Name          "<--- please adapt expected value
*    " msg   = 'Testing value r_Rel_Name'
**     level =
*    ).
  ENDMETHOD.


  METHOD i.

*    data i_Log_Content type any.
*    data i_Log_Msgid type syst_Msgid.
*    data i_Log_Msgno type syst_Msgno.
*    data i_Log_Msgv1 type syst_Msgv.
*    data i_Log_Msgv2 type syst_Msgv.
*    data i_Log_Msgv3 type syst_Msgv.
*    data i_Log_Msgv4 type syst_Msgv.
*    data self type ref to zcl_Log_Util.
*
*    self = f_Cut->i(
**       I_LOG_CONTENT = i_Log_Content
**       I_LOG_MSGID = i_Log_Msgid
**       I_LOG_MSGNO = i_Log_Msgno
**       I_LOG_MSGV1 = i_Log_Msgv1
**       I_LOG_MSGV2 = i_Log_Msgv2
**       I_LOG_MSGV3 = i_Log_Msgv3
**       I_LOG_MSGV4 = i_Log_Msgv4
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD log.

*    data i_Log_Content type any.
*    data i_Log_Msgid type syst_Msgid.
*    data i_Log_Msgno type syst_Msgno.
*    data i_Log_Msgty type syst_Msgty.
*    data i_Log_Msgv1 type syst_Msgv.
*    data i_Log_Msgv2 type syst_Msgv.
*    data i_Log_Msgv3 type syst_Msgv.
*    data i_Log_Msgv4 type syst_Msgv.
*    data self type ref to zcl_Log_Util.
*
*    self = f_Cut->log(
**       I_LOG_CONTENT = i_Log_Content
**       I_LOG_MSGID = i_Log_Msgid
**       I_LOG_MSGNO = i_Log_Msgno
**       I_LOG_MSGTY = i_Log_Msgty
**       I_LOG_MSGV1 = i_Log_Msgv1
**       I_LOG_MSGV2 = i_Log_Msgv2
**       I_LOG_MSGV3 = i_Log_Msgv3
**       I_LOG_MSGV4 = i_Log_Msgv4
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD merging.

*    data i_Structure type any.
*    data self type ref to zcl_Log_Util.
*
*    self = f_Cut->merging( i_Structure ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD overload.

*    data c_Log_Table type .
*    data self type ref to zcl_Log_Util_Overload.
*
*    self = f_Cut->overload(
**     CHANGING
**       C_LOG_TABLE = c_Log_Table
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = c_Log_Table
*      exp   = c_Log_Table          "<--- please adapt expected value
*    " msg   = 'Testing value c_Log_Table'
**     level =
*    ).
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD s.

*    data i_Log_Content type any.
*    data i_Log_Msgid type syst_Msgid.
*    data i_Log_Msgno type syst_Msgno.
*    data i_Log_Msgv1 type syst_Msgv.
*    data i_Log_Msgv2 type syst_Msgv.
*    data i_Log_Msgv3 type syst_Msgv.
*    data i_Log_Msgv4 type syst_Msgv.
*    data self type ref to zcl_Log_Util.
*
*    self = f_Cut->s(
**       I_LOG_CONTENT = i_Log_Content
**       I_LOG_MSGID = i_Log_Msgid
**       I_LOG_MSGNO = i_Log_Msgno
**       I_LOG_MSGV1 = i_Log_Msgv1
**       I_LOG_MSGV2 = i_Log_Msgv2
**       I_LOG_MSGV3 = i_Log_Msgv3
**       I_LOG_MSGV4 = i_Log_Msgv4
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD set_Log_Table.

*    data t_Log_Table type .
*
*    f_Cut->set_Log_Table(
*      CHANGING
*        T_LOG_TABLE = t_Log_Table ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = t_Log_Table
*      exp   = t_Log_Table          "<--- please adapt expected value
*    " msg   = 'Testing value t_Log_Table'
**     level =
*    ).
  ENDMETHOD.


  METHOD slg.

*    data self type ref to zcl_Log_Util_Slg.
*
*    self = f_Cut->slg(  ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD split_Text_To_Msgvx.

*    data i_Text_Message type string.
*    data e_Msgv1 type syst_Msgv.
*    data e_Msgv2 type syst_Msgv.
*    data e_Msgv3 type syst_Msgv.
*    data e_Msgv4 type syst_Msgv.
*
*    zcl_Log_Util=>split_Text_To_Msgvx(
*      EXPORTING
*        I_TEXT_MESSAGE = i_Text_Message
**     IMPORTING
**       E_MSGV1 = e_Msgv1
**       E_MSGV2 = e_Msgv2
**       E_MSGV3 = e_Msgv3
**       E_MSGV4 = e_Msgv4
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = e_Msgv1
*      exp   = e_Msgv1          "<--- please adapt expected value
*    " msg   = 'Testing value e_Msgv1'
**     level =
*    ).
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = e_Msgv2
*      exp   = e_Msgv2          "<--- please adapt expected value
*    " msg   = 'Testing value e_Msgv2'
**     level =
*    ).
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = e_Msgv3
*      exp   = e_Msgv3          "<--- please adapt expected value
*    " msg   = 'Testing value e_Msgv3'
**     level =
*    ).
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = e_Msgv4
*      exp   = e_Msgv4          "<--- please adapt expected value
*    " msg   = 'Testing value e_Msgv4'
**     level =
*    ).
  ENDMETHOD.


  METHOD spot.

*    data spot type zdt_Log_Util_Spot.
*    data self type ref to zcl_Log_Util_Spot.
*
*    self = f_Cut->spot( spot ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD w.

*    data i_Log_Content type any.
*    data i_Log_Msgid type syst_Msgid.
*    data i_Log_Msgno type syst_Msgno.
*    data i_Log_Msgv1 type syst_Msgv.
*    data i_Log_Msgv2 type syst_Msgv.
*    data i_Log_Msgv3 type syst_Msgv.
*    data i_Log_Msgv4 type syst_Msgv.
*    data self type ref to zcl_Log_Util.
*
*    self = f_Cut->w(
**       I_LOG_CONTENT = i_Log_Content
**       I_LOG_MSGID = i_Log_Msgid
**       I_LOG_MSGNO = i_Log_Msgno
**       I_LOG_MSGV1 = i_Log_Msgv1
**       I_LOG_MSGV2 = i_Log_Msgv2
**       I_LOG_MSGV3 = i_Log_Msgv3
**       I_LOG_MSGV4 = i_Log_Msgv4
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = self
*      exp   = self          "<--- please adapt expected value
*    " msg   = 'Testing value self'
**     level =
*    ).
  ENDMETHOD.


  METHOD _convert_Table.

*    data i_Table_To_Convert type .
*    data i_Table_To_Copy type .
*    data i_Structure_To_Copy type any.
*    data r_Table_Converted type ref to data.
*
*    r_Table_Converted = f_Cut->_convert_Table(
*        I_TABLE_TO_CONVERT = i_Table_To_Convert
**       I_TABLE_TO_COPY = i_Table_To_Copy
**       I_STRUCTURE_TO_COPY = i_Structure_To_Copy
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = r_Table_Converted
*      exp   = r_Table_Converted          "<--- please adapt expected value
*    " msg   = 'Testing value r_Table_Converted'
**     level =
*    ).
  ENDMETHOD.


  METHOD _count_Table_Lines.

*    data i_Table type .
*    data r_Lines type i.
*
*    r_Lines = zcl_Log_Util=>_count_Table_Lines( i_Table ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = r_Lines
*      exp   = r_Lines          "<--- please adapt expected value
*    " msg   = 'Testing value r_Lines'
**     level =
*    ).
  ENDMETHOD.


  METHOD _get_Checked_Messages.

*    data i_Src_Table type .
*    data i_Msg_Types type any.
*    data e_Out_Table type .
*
*    f_Cut->_get_Checked_Messages(
*      EXPORTING
*        I_SRC_TABLE = i_Src_Table
*        I_MSG_TYPES = i_Msg_Types
**     IMPORTING
**       E_OUT_TABLE = e_Out_Table
*    ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = e_Out_Table
*      exp   = e_Out_Table          "<--- please adapt expected value
*    " msg   = 'Testing value e_Out_Table'
**     level =
*    ).
  ENDMETHOD.


  METHOD _update_Field_Of_Structure.

*    data i_Comp_Name type name_Feld.
*    data i_Value type any.
*    data c_Structure type any.
*
*    zcl_Log_Util=>_update_Field_Of_Structure(
*      EXPORTING
*        I_COMP_NAME = i_Comp_Name
*        I_VALUE = i_Value
*      CHANGING
*        C_STRUCTURE = c_Structure ).
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = c_Structure
*      exp   = c_Structure          "<--- please adapt expected value
*    " msg   = 'Testing value c_Structure'
**     level =
*    ).
  ENDMETHOD.




ENDCLASS.
