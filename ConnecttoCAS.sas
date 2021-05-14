/*****************************************************************************/
/*  Set the options necessary for creating a connection to a CAS server.     */
/*  Once the options are set, the cas command connects the default session   */ 
/*  to the specified CAS server and CAS port, for example the default value  */
/*  is 5570.                                                                 */
/*****************************************************************************/

options cashost="server" casport=5570;

/*****************************************************************************/
/*  Start a session named mySession using the existing CAS server connection */
/*  while allowing override of caslib, timeout (in seconds), and locale     */
/*  defaults.                                                                */
/*****************************************************************************/

cas mySession sessopts=(caslib=casuser timeout=1800 locale="en_US" metrics=true);

/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/


caslib _all_ assign;


/*casncharmultiplier=2 prevent truncation of special characters when uploading from latin1 encoding to utf8*/
/*casdatalimit prevents upload of files bigger than 100M*/

options casncharmultiplier=2 casdatalimit=all; 