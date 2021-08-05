/* --------------------- Creating a permanant library---------------------*/

LIBNAME Telecom "C:\Desktop\Data Science\Advance SAS\ASAS Project";


/*---------------------Reading dataset using formated inputs--------------------- */

data Telecom.Wireless;
INFILE "C:\Desktop\Data Science\Advance SAS\ASAS Project\New_Wireless_Fixed.txt";
LABEL Acctno ="Account number" Actdt ="Activation date" Deactdt ="Deactivation date" DeactReason ="Reason for deactivation" GoodCredit ="Credit is good or not" RetePlan ="Rate Plan" DealerType ="Dealer Type";
INPUT  @1 Acctno 13.
       @15 Actdt mmddyy10.
	   @26 Deactdt mmddyy10.
	   @41 DeactReason $4. 
	   @53 GoodCredit 1.
	   @62 RatePlan 1.
	   @65 DealerType $2.
	   @74 Age 2.
	   @80 Province $2.
	   @84 Sales dollar8.2 
       ;
FORMAT Acctno 13. Actdt mmddyy10. Deactdt mmddyy10. Sales dollar8.2;
RUN;

/* This is our Data*/

PROC PRINT data=Telecom.Wireless; RUN;



*/Q1.1	Explore and describe the dataset briefly. For example, is the acctno unique? What
is the number of accounts activated and deactivated? When is the earliest and
latest activation/deactivation dates available? And so on・;


/*---------------------EXPLORING DATA---------------------*/


/* FIRST 5 ROWS OF THE DATA */

PROC PRINT DATA=Telecom.Wireless (OBS=5); RUN;


/*CONTANT OF THE DATA OR SUMMARIZING DATA*/

PROC CONTENTS DATA=Telecom.Wireless; 
RUN;


/*EXPLORE CATEGORICAL VARIABLE AND MISSING VALUE FREQUENCY*/

 
PROC FREQ DATA = Telecom.Wireless;
TABLES DealerType;
RUN;

PROC FREQ DATA = Telecom.Wireless;
TABLES province;
RUN;



/*NUMERICAL VARIABLE EXPLORATION*/

PROC MEANS data=Telecom.Wireless;
VAR Acctno Actdt Age Deactdt GoodCredit RatePlan Sales;
RUN;


*/ CHECKING MISSING VALUE FOR BOTH CATEGORICAL AND NUMERICAL VARIABLES */;
 

PROC FORMAT;
VALUE $missingfmt ' '='Missing' other='Okay';
VALUE  missingfmt  . ='Missing' other='Okay';
RUN;
PROC FREQ data=Telecom.Wireless; 
FORMAT _CHAR_ $missingfmt.; 
FORMAT _NUMERIC_ missingfmt.;
TABLES _CHAR_ / missing missprint nocum;
TABLES _NUMERIC_ / missing missprint nocum;
RUN;

*/ FINDING MISSING VALUES FOR NUMERICAL VALUES */;

TITLE 'MISSING VALUES';
PROC MEANS DATA=Telecom.Wireless N NMISS;
VAR Acctno Actdt Age Deactdt GoodCredit RatePlan Sales;
RUN;



/*CHECKING DUPLICATE VALUE IN Acctno*/; 

ODS SELECT NLEVELS;
PROC FREQ data=Telecom.Wireless NLEVELS;
TABLES Acctno;
TITLE 'Number of distinct values in Acctno'; 
RUN; 



/*DEACTIVATED ACCOUNT INFORMATION */

PROC UNIVARIATE data=Telecom.Wireless NOPRINT;
VAR Deactdt;
OUTPUT out=Deact_account n=n MIN=min MAX=max;
RUN; 
PROC PRINT data=Deact_account NOOBS LABEL;
TITLE "Information of deactivated accounts";
FORMAT min mmddyy10. max mmddyy10.;
LABEL n="Number of deactivated accounts" min="Earlist deactivation" max="Latest deactivation";
RUN; 

/* ACTIVATION ACCOUNT INFORMATION*/

PROC SUMMARY data=Telecom.Wireless;
VAR Actdt Deactdt;
OUTPUT out=Telecom.summary_data;
RUN;

PROC UNIVARIATE data=Telecom.Wireless NOPRINT;
VAR Actdt;
OUTPUT out=Act_account n=n MIN=min MAX=max;
RUN; 
PROC PRINT data=Act_account NOOBS LABEL;
TITLE "Information of Activated accounts";
FORMAT min mmddyy10. max mmddyy10.;
LABEL n="Number of Activated accounts" min="Earlist Activation" max="Latest Activation";
RUN; 



*/Q1.2 What is the age and province distributions of active and deactivated customers? */;


TITLE 'Province by age distribution for Activated accounts';
PROC FREQ data=telecom.wireless;
TABLE Province*Age;
WHERE Actdt ne .;
FORMAT Age Province;
RUN;

PROC SGPLOT DATA=telecom.wireless;
histogram Age;
density province;
run;

PROC sgpanel DATA=telecom.wireless;
panelby province;
SCATTER X=Actdt Y=Age;
RUN; 


TITLE 'Province by age distribution for deactivated accounts';
PROC FREQ data=telecom.wireless;
TABLE Province*Age;
WHERE Deactdt ne .;
FORMAT Age agegrp. Province $Province.;
RUN;

PROC sgpanel DATA=telecom.wireless;
panelby province;
SCATTER X=Deactdt Y=Age;
RUN; 

/*Q1.3 Segment the customers based on age, province and sales 	amount: 
		  Sales segment: < $100, $100---500, $500-$800, $800 and above.
		  Age segments: < 20, 21-40, 41-60, 60 and above. Create analysis 			 
report*/;

PROC FORMAT; 
VALUE salesfmt	low-100='Under $100'
				100-500= 'Between $100 to $500'
				500-800= 'Between $500 to $800'
				800-high= '$800 and over';

VALUE agegrp	low-20 = 'Under 20'
				21-40 = '21 to 40 YRS'
				41-60 = '41 to 60 YRS'
				60-high='60 YRS and over';
RUN;

PROC PRINT DATA=TELECOM.WIRELESS(OBS=20);
VAR Province Age Sales;
FORMAT Age agegrp. Sales salesfmt.;
RUN;

PROC SORT DATA=TELECOM.WIRELESS OUT=TELECOM.SORTDATA;
BY Age Province;
run;




*/Q1 1.4.Statistical Analysis:

1) Calculate the tenure in days for each account and give its simple statistics.;


PROC SORT data=telecom.wireless OUT = Telecom.sorted;
BY DESCENDING actdt;
RUN;

DATA Telecom.tenure_data;
SET Telecom.wireless;
IF deactdt = . THEN tenure = deactdt-actdt;
ELSE tenure = deactdt-actdt;
RUN;

PROC MEANS data = telecom.tenure_data;
VAR tenure;
TITLE 'Statistic for tenure';
RUN;

*/---OR----;

PROC SQL;
CREATE TABLE WORK.Status AS 
SELECT t1.Province, 
(FREQ(t1.Age)) AS FREQ_of_Age, 
(FREQ(t1.Actdt)) AS FREQ_of_Actdt, 
(FREQ(t1.Deactdt)) AS FREQ_of_Deactdt
FROM TELECOM.WIRELESS t1
GROUP BY t1.Province;
QUIT;



*/Q1.4> 2) Calculate the number of accounts activated for each month*/;
PROC FORMAT;
VALUE monthfmt 	1= 'January'
				2='February'
				3='March'
				4='April'
				5='May'
				6='June'
				7='July'
				8='August'
				9='September'
				10='October'
				11='November'
				12='December';
RUN;

DATA telecom.monthlystatus;
SET telecom.tenure_data;
IF deactdt ne .;
year=year(actdt);
month=month(actdt);
RUN;


PROC FREQ data=telecom.monthlystatus;
TABLE year * month;
FORMAT month monthfmt.;
TITLE 'Statistic of accounts deactivated by month';
RUN;

PROC CORR DATA=telecom.monthlystatus PLOTS=SCATTER(NVAR=all);
   VAR month Deactdt;
RUN;


*/Q1.4> 3) Segment the account, first by account status Active・and deactivated・ then by Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment.*/;

PROC FORMAT;
VALUE Tenurefmt low-30 = 'Less than 30 days'
				31-60 = '31 to 60 day'
				61-365 = '61 to one year'
				366-high = 'Over one year';
RUN;

DATA Telecom.Segmentation;
SET Telecom.Tenure_data;
IF Deactdt ne . THEN Acctstatus = 'Deactivated';
ELSE Acctstatus = 'Avtive';
RUN;

PROC FREQ data = telecom.Segmentation;
TABLE Acctstatus * Tenure;
FORMAT Tenure Tenurefmt.;
RUN;
 


*/Q1.4> 4) Test the general association between the tenure segments and Good Credit・
RatePlan ・and 泥ealerType.・/;

PROC TABULATE data=Telecom.tenure_data;
TITLE "Association between the tenure segment and 'Good Credit''RatePlan ' and 'DealerType.'";
CLASS tenure goodcredit rateplan dealertype;
TABLE goodcredit='Credit status (1 Good 0 Bad)=', rateplan='Rate Plan'*dealertype all, tenure=' '* all;
FORMAT Tenure Tenurefmt.;
RUN; 

*/q1.4 5) Is there any association between the account status and the tenure segments?
Could you find out a better tenure segmentation strategy that is more associated
with the account status?*/;

PROC FREQ data= Telecome.segmentation;
TITLE 'Association between account and tenure';
TABLE Acctstatus*tenure;
FORMAT tenure tenurefmt.;
RUN;

PROC FORMAT;
VALUE TenurefmtA low-30 = 'Less than 30 days'
				31-90 = '2 month and up'
				91-180 = '3 months and up'
				181-270 = '6 months and up'
				271-365 = '9 month and up'
				366-high = 'one year and up';
RUN;

PROC FREQ data=Telecom.segmentation;
TITLE 'Association between account and tenure';
TABLE Acctstatus*tenure;
FORMAT tenure tenurefmtA.;
RUN;


*/Q 1.4 6) Does Sales amount differ among different account status, GoodCredit, and customer age segments?*/;

PROC TABULATE data=Telecom.segmentation;
TITLE 'Sales amount segment by Account status, Credit status and Age';
CLASS acctype Goodcredit age sale;

TABLE Goodcredit='credit Status',acctype='Account Status=',age,sales;
FORMAT age agegrp.;
RUN; 

