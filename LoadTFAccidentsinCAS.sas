
options cashost='server' casport=5570;
cas mysession sessopts=(caslib='casuser' timeout=1800 metrics=TRUE);
caslib _ALL_ assign sessref=mysession;
options casncharmultiplier=2 casdatalimit=ALL;
/*****************************************************************************/
/*  Load file from a client location ("pathToClientFile") into the specified */
/*  caslib ("myCaslib") and save it as "tableNameForLoadedFile".             */
/*****************************************************************************/

proc casutil;
    droptable casdata="TF_Accidents_2019" incaslib="casuser";
	load file="D:\Workshop\Advanced\TF_ACCIDENTS_2019.xlsx" 
	outcaslib="casuser" casout="TF_Accidents_2019" promote 
  (importoptions=(varcharconversion=2));
run;

/*Import of XLSX in EG, then upload to CASLib Public"
*/
proc casutil; 
droptable casdata="TF_Accidents_2019" incaslib="public";
load data=work.tf_accidents_2019 casdata='TF_ACcidents_2019' outcaslib="public" promote; 
quit; 
/*****************************************************************************/
/*  Create a CAS library (myCaslib) for the specified path ("/filePath/")    */ 
/*  and session (mySession).  If "sessref=" is omitted, the caslib is        */ 
/*  created and activated for the current session.  Setting subdirs extends  */
/*  the scope of myCaslib to subdirectories of "/filePath".                  */
/*****************************************************************************/

caslib mapscstm datasource=(srctype="path") path="/workshop/mapsviya" sessref=mySession subdirs;
libname mapscstm cas;

proc casutil; 
list files incaslib="mapscstm";
run; 


/*****************************************************************************/
/*  Load a table ("sourceTableName") from the specified caslib               */
/*  ("sourceCaslib") to the target Caslib ("targetCaslib") and save it as    */
/*  "targetTableName".                                                       */
/*****************************************************************************/

proc casutil;
droptable casdata="municipality2019" incaslib='public'; 
	load casdata="municipality2019.sashdat" incaslib="mapscstm" 
	outcaslib="public" casout="municipality2019" promote;
run;

