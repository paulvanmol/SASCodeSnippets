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
proc casutil ; 
droptable casdata='dates' incaslib="casuser" quiet; 
droptable casdata='employeebymonth' incaslib="casuser" quiet; 

run; 

data casuser.dates (promote=yes) ; 
do period='1JAN1977'd to today(); 
date_month=period; 
if day (period)=1 then output; 
end; 
format date_month monyy7.;
run; 



proc fedsql sessref=mysession; 
create table casuser.employeebymonth as 
select d.date_month, count(1) as active_employees
from casuser.dates as d 
inner join public.employees_clean as e 
on (d.date_month between e.employee_hire_date and e.employee_term_date or 
   d.date_month >e.employee_hire_date and e.employee_term_date=.)
group by d.date_month; 
quit; 

proc casutil ; 
promote incaslib="casuser" casdata="employeebymonth" ; 
quit; 
