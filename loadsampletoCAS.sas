
/*LoadToCAS*/
options mprint symbolgen ; 
%macro loadsampletoCAS(sample=hmeq,caslib=casuser);
%let homedir=%sysget(HOME); 
%let sample=hmeq; %let caslib=casuser; 
%let path=&homedir;
options dlcreatedir; 
libname data "&path"; 

filename out "&path/&sample..csv";
proc http
 url="https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/&sample..csv"
 method="get" out=out ;
 *debug level=3;
run;

proc import datafile="&path/&sample..csv" 
out=work.&sample 
dbms=CSV replace; 
run; 

/*****************************************************************************/
/*  Start a session named mySession using the existing CAS server connection */
/*  while allowing override of caslib, timeout (in seconds), and locale     */
/*  defaults.                                                                */
/*****************************************************************************/

cas mySession sessopts=(caslib=casuser timeout=1800 locale="en_US");

/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/
caslib _all_ assign;

/*****************************************************************************/
/*  Load SAS data set from a Base engine library (library.tableName) into    */
/*  the specified caslib ("myCaslib") and save as "targetTableName".         */
/*****************************************************************************/

proc casutil;
    droptable casdata="&sample" incaslib="&caslib" quiet; 
	load data=work.&sample outcaslib="&caslib"
	casout="&sample" promote;
    save casdata="&sample" incaslib="&caslib" outcaslib="&caslib" replace; 
run;
%mend ; 

%loadsampletoCAS(sample=hmeq,caslib=casuser);

