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


### Initialization & Configuration

````abap

````



### Logging & Display



### Default Values & Behavior






## Detailed guide & Features


### Handle custom (or unknown standard) log table


### Application Log (SLG)


### Message Overloading







