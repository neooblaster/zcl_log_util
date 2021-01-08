# ABAP Logging Class ZCL_LOG_UTIL

> An another ABAP logging class allowing programs to focus on their functionality
> rather than being buried under lines of logging code.

**Link to download latest versions** :

* Latest : [v0.1.0 (Latest)](https://github.com/neooblaster/zcl_log_util/releases/tag/latest)
* Latest ABAP 7.30 : [v0.1.0 for ABAP 7.30 (Latest)](https://github.com/neooblaster/zcl_log_util/releases/tag/latest-7.30)


## Summary

[](MakeSummary)



## Feature Overview

* Logging messages in own internal table type :
    * Next to statement ``MESSAGES``.
    * System message stored in global structure ``SY``.
    * Standard **BAPI** return structure or table (eg `BAPIRET2`).
    * Custom return structure or table.
    * A free message texte.
    * A message using a message class.
* Logging messages in **Application Log** (TCODE : `SLG1`) .
* Displaying logs in the report :
    * In an ALV grid from your own log table.
        * The method can be used to display any kind of internal table.
    * In the same presentation of ``SLG1`` from **Application Log**.
* Managing logs between **foreground** and **background** execution (**batch**) :
    * For **batch** mode, you can easily set which message type must be displayed 
    in the **spool** and in the **protocol** in an independent way.
* The best for the end, overloading logs messages using provided settings table
or your own one :
    * Update messages components on the fly according to the rules in settings table.
    * Skip messages.
    * Appending an extra message.
    * Messages can be uniquely identified by using a Spot ID in your program. 



## Introduction : Genesis of this class

As part of the development of ABAP interfaces program executed by batch, 
we have been confronted several times with subjects around error logs.
First, we had problems with their display between the area of ​​the job 
execution protocol and those to display in the spool to send an email. 
Later we had a request to handle standard BAPI error messages being significant 
as false positive. 
Finally for an advanced follow-up for possible anomaly analysis in production, 
the use of the application can be a precious help.

All of its subjects are at the very close ABAP level (message management) 
but the implementation varies greatly depending on the nature of the subject. 
The reuse of codes is very complex because of its processive implementation.

The need to develop a class designed to cover all needs, 
without modifying the way of logging into the program and leaving the core of 
the program readable has become evident. 
It is for this reason that I decided to develop the ZCL_LOG_UTIL class. 
It is intended to be easy to use (minimum configuration) 
while offering a range of functions (requires more configuration, 
but always wants to be as simple as possible). 
Due to this complexity,
please find detailed documentation of the class and its use.


## Installation

1. Install this project via [ABAPGit](http://abapgit.org/).
2. Create **Application Log object** in transaction code ``SLG0`` :
    * Object : ``ZLOGUTIL`` (`Main default object for entries registred with ZCL_LOG_UTIL`).
3. Run the report : ``N/A``.

Now you're ready to get started.


## Getting Start

The ``ZCL_LOG_UTIL`` project comes with an example program that contains and 
uses all of the functionality offered by the class. 
Its goal is to allow all users to have an example of a precise use, 
method call or implementation of a feature for their projects. 
There is nothing worse than having the method without understanding how to use 
it.

First follow the guide to understand its use in its simplest form before using 
the ``ZCL_LOG_UTIL_EXAMPLES`` (``SE38`` / ``SE80``) example program.


### Initialization

For the simplest possible use,
I advise you to use the type of log table provided with the class.
Instantiation works in the same way as that of an ALV grid of class 
``CL_SALV_TABLE`` :

````abap
" Data declaration :
DATA: lt_log_table TYPE TABLE OF zcl_log_util=>ty_log_table ,
      lr_log_util  TYPE REF TO   zcl_log_util               .

" Instanciation
zcl_log_util=>factory(
    IMPORTING
        e_log_util  = lr_log_util
    CHANGING
        c_log_table = lt_log_table
).
````



### Logging & Display

To log messages, there are a number of different ways to proceed.
I advise you to do it in the following way.
This method offers the advantage of being able to do the where-used on the
message class and on the message number, 
a powerful feature of SAP.

````abap
" Creating a variable to catch generated message
DATA: lv_dummy TYPE string .

" Raising message :
"   - 1.) Message texte is available in lv_dummy.
"   - 2.) Log raised message
MESSAGE e504(vl) INTO lv_dummy.
lr_log_util->log( ).

" Display you log table
lr_log_util->display( ).
````

**Hints** : When you use statement ``MESSAGE``, SAP automatically feed
structure ``SY``. Using `lr_log_util->log( )` will log message using the message 
components available in structure ``SY``.
When a standard **Function Module** or **BAPI** implicitely
stored errors in ``SY`` you can log system message using `log( )` method
without writing statement ``MESSAGE``.






## Detailed documentation


### Instanciation methods

There are two ways to instantiate the ``ZCL_LOG_UTIL`` class.
The first method will be the most frequent method.
The second method makes it possible to defer the association of the internal 
table to a later moment in the processing of the program.
It also offers a way to change log tables at any time which allows you to use 
a single instance to manage different internal tables.

* First method : classic way, same as chapter ``Getting Start``

````abap
" Data declaration :
DATA: lt_log_table TYPE TABLE OF zcl_log_util=>ty_log_table ,
      lr_log_util  TYPE REF TO   zcl_log_util               .

" Instanciation
zcl_log_util=>factory(
    IMPORTING
        e_log_util  = lr_log_util
    CHANGING
        c_log_table = lt_log_table
).
````

* Second method : differed way, for multiple log table in on report.

````abap
# -----[ Instanciation ]---------------------------------------
" Data declaration :
DATA: lr_log_util  TYPE REF TO   zcl_log_util .

" Instanciation
zcl_log_util=>factory(
    IMPORTING
        e_log_util  = lr_log_util
).
````

````abap
# -----[ Linking log table ]-----------------------------------
" Data declaration :
DATA: lt_log_table TYPE TABLE OF zcl_log_util=>ty_log_table .

" Linking log table :
lr_log_util->set_log_table(
    CHANGING
        t_log_table = lt_log_table
).
````


### Logging methods

The main objective of this class is to provide the maximum possibility of
logging different message sources with different format types using only one method.
Here are the ways to log messages:


#### Logging system message



#### Logging next to statement ``MESSAGE``



#### Logging a structure



#### Logging a table



#### Logging using message class



#### Logging a free message texte



#### Logging from custom structure (or table)





### Logging in the Application Log (`SLG1`)


#### Configuration



#### Enabling / Disabling



#### Display Application Log






### Overloading Log Messages


#### Configuration



#### Enabling / Disabling



#### Usin Spot ID



#### Using Extra parameters



#### Using your own custom setting table






### Managing batch mode outputs


#### Managing output for the spool



#### Managing output for the protocol






### Set your own definitions


#### Set a custom log table type or unregistred SAP standard type


#### Set a custom setting table that storing overloading rules