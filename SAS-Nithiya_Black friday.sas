/*SAS PROJECT */






/*CREATING WORKING LIBRARY*/
*=============================;

LIBNAME Nithiya "C:\Desktop\SAS Final";

ODS PDF FILE = "C:\Desktop\SAS Final\DATA_PROFILING.PDF";
TITLE "DATA PROFILING : BLACK FRIDAY SALES ANALYSIS";
TITLE2 "CREATED BY NITHIYALUXMY KUMARASAMY";
TITLE3 "REPORT DATE :&SYSDATE.";



/*READING DATA FILE*/
*===================;



/*READING TRAIN DATASET*/
PROC IMPORT FILE="C:\Desktop\SAS Final\SasProject\train.csv"
    OUT=Nithiya.train
    DBMS=csv;
RUN;

/*READING TEST DATASET*/
PROC IMPORT FILE="C:\Desktop\SAS Final\SasProject\test.csv"
    OUT=Nithiya.test
    DBMS=csv;
RUN;

/*READING TEST DATASET*/
PROC IMPORT FILE="C:\Desktop\SAS Final\SasProject\sample_submission_LMg97w5.csv"
    OUT=Nithiya.Sample
    DBMS=csv;
RUN;






/*HEAD OF THE DATASET*/



/*FIRST SIX ROWS OF THE TEST AND TRAIN*/
*========================================;

TITLE "TOP TWENTY ROWS OF TRAIN";
PROC PRINT DATA=Nithiya.train (OBS=20) NOOBS;
RUN;

TITLE "TOP TWENTY ROWS OF TEST";
PROC PRINT DATA=Nithiya.test (OBS=20) NOOBS;
RUN;


/*DATASET EXPLORIZATION (EDA) */

	
/*SUMMARY OF TRAIN AND TEST*/
*==============================;

TITLE "SUMMARY OF TRAIN";
PROC CONTENTS DATA=Nithiya.train; 
RUN;
TITLE "SUMMARY OF TEST";
PROC CONTENTS DATA=Nithiya.test;
RUN;



														/* MERGING TEST AND TRAIN DATASET*/


*/SORT DATESET TRAIN*/;													
PROC SORT DATA=Nithiya.Train;
BY User_ID;
RUN;

*/SORT DATESET TEST*/;
PROC SORT DATA=Nithiya.Test;
BY User_ID;
RUN;

DATA Nithiya.Black;
   MERGE Nithiya.test Nithiya.train;
   BY User_ID;

TITLE "TOP TWENTY ROWS OF BLACK(TRAIN + TEST)";
PROC PRINT DATA=Nithiya.Black (OBS=20) NOOBS; 
RUN;


/*SUMMARY OF Black DATA SET*/
TITLE "SUMMARY OF BLACK(TRAIN + TEST)";
PROC CONTENTS DATA=Nithiya.Black;
RUN;





/*DESCRIPTIVE ANALYSIS OF VARIABLES*/
*===================================;

/*VARIABLES NAMES*/
TITLE "VARIABLES NAMES";
PROC CONTENTS DATA = Nithiya.Black VARNUM SHORT;
RUN;

* 	Char:
			Product_ID 
			Gender 
			Age 
			Stay_In_Current_City_Years
			City_Category 

	Num: 
			User_ID
			Marital_Status
			Occupation  
			Product_Category_1 
			Product_Category_2 
			Product_Category_3 
			Purchase (TARGET)*/;





/*UNIVARIATE / BIVARIATE ANALYSIS OF CATEGORICAL VARIABLES*/
*===========================================================;														



/*CHECKING DUPLICATE VALUE IN VARIABLE User_ID*/; 
TITLE 'UNIVARIEATE ANAYSIS OF CATEGORICAL VARIABLES';
ODS SELECT NLEVELS;
PROC FREQ data=Nithiya.Black NLEVELS;
TABLES Product_ID;
TITLE2 'Number of distinct values in Product_ID '; 
RUN; 


/*CHECKING DUPLICATE VALUE IN User_ID*/; 
TITLE 'UNIVARIEATE ANAYSIS OF NUMERICAL VARIABLES';
ODS SELECT NLEVELS;
PROC FREQ data=Nithiya.Black NLEVELS;
TABLES User_ID;
TITLE2 'Number of distinct values in User_ID'; 
RUN; 



*SELECTING STUDY/WORKING VARIABLES;
PROC SQL;
  CREATE TABLE Nithiya.B1 AS 
  SELECT Purchase,
		Gender, 
		Age, 
		Stay_In_Current_City_Years,
		City_Category,
		Marital_Status,
		Occupation,  
		Product_Category_1, 
		Product_Category_2, 
		Product_Category_3
  FROM Nithiya.Black
  WHERE Purchase NE "NA" *NE = NOT EQUAL TO ;
  ;
 QUIT;

*Created New table(data set) call B1 with following variables and excluded User_ID and Product_ID;

 
/*VARIABLES NAMES IN NEW TABLE CALL B1*/
TITLE "VARIABLES NAMES";
PROC CONTENTS DATA = Nithiya.B1 VARNUM SHORT;
RUN;






/*EXPLORING CATEGORICAL VARIABLES*/


*UNIVAREATE ANALYSIS;
TITLE 'UNIVARIEATE ANAYSIS OF CATEGORICAL VARIABLES';
TITLE2 "CATEGORICAL VARIABLES FREQUENCY AND PERCENTAGE";
PROC FREQ data=Nithiya.B1;
TABLES 
		Gender 
		Age 
		Stay_In_Current_City_Years
		City_Category;
RUN;

TITLE "PIE CHART FOR CATEGORICAL VARIABLE DISTRIBUTION";
PROC GCHART DATA = Nithiya.B1;
 PIE 	Gender Age 	City_Category Stay_In_Current_City_Years;

RUN;
QUIT;


*------------------------------------------------------------------;

*Q.GENDER ANALYSIS;
*Q. WHICH GENDER PURCHASE MORE?
*Q WHICH GENDER CATEGORY DID MORE PURCHASE BY CITY?;



TITLE "TOTALL GENDER GROUP PARTICIPATED IN THIS PURCHASE";
PROC FREQ DATA = Nithiya.B1;
TABLES Gender;
RUN;

TITLE " TOTAL GENDER GROUP PARTICIPATED IN PURCHASE";
PROC SGPLOT DATA = Nithiya.B1;
 VBAR Gender;
RUN;
QUIT;

*==> OBSERVATION: Male are more likely to purchase more.;


TITLE 'GENDER PARTICIPATED ACROSS THE CITY';
PROC FREQ DATA=Nithiya.B1;
TABLE City_Category*Gender;
WHERE Purchase ne .;
FORMAT Gender City_Category;
RUN;

PROC SGPLOT DATA = Nithiya.B1;
TITLE "Customers by Gender";
VBAR CITY_CATEGORY / GROUP = GENDER GROUPDISPLAY=CLUSTER ;
RUN;

*==> OBSERVATION: Male are more likely to purchase more from City B and more purchesing transection happening in city B .;


*------------------------------------------------------------------;


*/AGE GROUP ANALYSIS*/;

*/Q. TOTALL NUMBER OF AGE PARTICIPATED IN THISPURCHASE?;
*/Q. AWHICH CITY BELONG TO WICH AGE GROUP;
*/Q. WHICH AGE GROUP PURCHASE MORE?;
*/Q. WHICH AGE GROUP ACCORDING TO CITYPURCHASE MORE?;


TITLE "totall age group particiapted in this Purchase";
PROC FREQ DATA = Nithiya.B1;
TABLES Age;
RUN;

TITLE " TOTAL AGE GROUP PARTICIPATED IN PURCHASE";
PROC SGPLOT DATA = Nithiya.B1;
 VBAR Age;
RUN;
QUIT;

*==>OBSERVATION: Age group bet ween 26 to 35 more participated in purchasing.;

TITLE 'City_Category by age distribution of Purchase';
PROC FREQ DATA=Nithiya.B1;
TABLE City_Category*Age;
WHERE Purchase ne .;
FORMAT Age City_Category;
RUN;




TITLE " TOTAL AGE GROUP PART IN PURCHASE BY VARIOUS CITIES";
PROC SGPLOT DATA = Nithiya.B1;
 VBAR CITY_CATEGORY/ GROUP=AGE GROUPDISPLAY=CLUSTER ;
RUN;
QUIT;

*==> OBSERVATION: Age group between 26 to 35 purchesing more from city and Most purchasing transection happening on City B.;


/*OVERALL DISTRIBUTION OF CUSTOMERS AND THEIR DEMOGRAPHICAL ANALYSIS */;

PROC TABULATE DATA=Nithiya.B1;
TITLE 'Customers Distribution Across Age, City Category, Gender and  Stay_In_Current_City_Years';
CLASS AGE CITY_CATEGORY GENDER Stay_In_Current_City_Years;
TABLE CITY_CATEGORY*(GENDER ALL), AGE='AGE GROUPS'*(PCTN='% ') ALL*(N PCTN) Stay_In_Current_City_Years;
RUN;


*==> OBSERVATION : 	The majority of the transactions are coming from B-category cities and Males are buying more than females 
					26–35 age group is the dominant purchasing group.;




*LET'S CHECK RELATIONSHIP AMOUNG THE CATEGORICAL VARIABLES;
*=========================================================;


* Y (Gender) = x1-AGE+ x2-City_Category-CHISQUARE TEST;;
TITLE'REALATION BETWEEN AGE VS GENDER';
PROC FREQ DATA = Nithiya.B1;
TABLE Age*Gender  /CHISQ ;
RUN;
* Y (Gender) = x2-City_Category : CHISQUARE TEST;
TITLE'REALATION BETWEEN CITY VS GENDER';
PROC FREQ DATA = Nithiya.B1;
TABLE City_Category*Gender  /CHISQ ;
RUN;

* Y (City_Category) = x3-Stay_In_Current_City_Years*City_Category;
TITLE'REALATION BETWEEN NUMBER OF YEARS STAYING IN CURRENT CITY VS CITY';
PROC FREQ DATA = Nithiya.B1;
TABLE Stay_In_Current_City_Years*City_Category  /CHISQ ;
RUN;



*lET'S CHECK RELATIONSHIP OF CATEGORICAL VARIABLE VS TARGET VARIABLE(PURCHASE- CONTINUOUS VARIABLE), 


*X-GENDER (CATEGORICAL) ~ Y-PURCHASE (CONTINOUS);

*ANOVA : ANALYSIS OF VARIANCE;
TITLE'REALATION BETWEEN GENDER VS PURCHASE';
PROC ANOVA DATA = Nithiya.B1;
 CLASS Gender;
 MODEL Gender = Purchase;
 MEANS Purchase/SCHEFFE;
RUN;


TITLE " TOTAL AGE GROUP PART IN PURCHASE BY VARIOUS CITIES";
PROC SGPLOT DATA = Nithiya.B1;
 VBAR Gender/ GROUP=Purchase GROUPDISPLAY=CLUSTER ;
RUN;
QUIT;


TITLE'REALATION BETWEEN AGE VS PURCHASE';
PROC ANOVA DATA = Nithiya.B1;
 CLASS Age;
 MODEL Purchase = Age;
 MEANS Age/SCHEFFE;
RUN;
TITLE'REALATION BETWEEN City_Category VS PURCHASE';
PROC ANOVA DATA = Nithiya.B1;
 CLASS City_Category;
 MODEL Purchase = City_Category;
 MEANS City_Category/SCHEFFE;
RUN;





/*EXPLORING CATEGORICAL VARIABLES*/



TITLE "DISCRIPTIVE STATISTIC OF NUMERICAL VARIABLES";
PROC MEANS DATA=Nithiya.B1;
VAR 	Marital_Status
		Occupation  
		Product_Category_1 
		Product_Category_2 
		Product_Category_3 
		Purchase;
RUN;

TITLE "UNIVARIATE ANALYSIS OF NUMERICAL VARIABLES";
PROC UNIVARIATE DATA = Nithiya.B1;
 VAR 	Marital_Status
		Occupation  
		Product_Category_1 
		Product_Category_2 
		Product_Category_3 
		Purchase; 
RUN;


/*CHECKING MISSING VALUE FOR BOTH CATEGORICAL AND NUMERICAL VARIABLES*/

TITLE "MISSING VALUES IN DATASET";
/*CREATE A FORMAT TO GROUP MISSING AND NONMISSING */
PROC FORMAT;
VALUE $missingfmt ' '='Missing' other='Okay';
VALUE  missingfmt  . ='Missing' other='Okay';
RUN;
PROC FREQ DATA=Nithiya.B1; 
FORMAT _CHAR_ $missingfmt.; 
FORMAT _NUMERIC_ missingfmt.;
TABLES _CHAR_ / missing missprint nocum;
TABLES _NUMERIC_ / missing missprint nocum;
RUN;

*-----------------------------------------------------------------------------------
NOTE: Product_Category_2 , Product_Category_3 has missing Values, Need to handle
	We know both are Numerical Variables
*-----------------------------------------------------------------------------------;



* MISSING VALUES DETECTIONA  AND ITS TREATMENT;

PROC MEANS DATA = Nithiya.B1 MAXDEC = 2 N NMISS MIN MEAN MEDIAN MAX ;
  VAR Product_Category_2 Product_Category_3;
RUN;


PROC STDIZE DATA = Nithiya.B1 OUT= Nithiya.B1 METHOD = MEDIAN REPONLY;
 VAR Product_Category_2 Product_Category_3;
RUN;


*CHECK IF THERE ARE STILL MISSING VALUES;
PROC MEANS DATA = Nithiya.B1 MAXDEC = 2 N NMISS MIN MEAN MEDIAN MAX ;
  VAR Product_Category_2 Product_Category_3;
RUN;











*HISTOGRAM  AND DENISTY CRUVE;
TITLE"HISTOGRAM OF MARITAL STATUS";
PROC SGPLOT DATA =  Nithiya.B1 noautolegend;
 HISTOGRAM Marital_Status;
 DENSITY Marital_Status;
RUN;
QUIT;



TITLE"HISTOGRAM OF OCCUPATION";
PROC SGPLOT DATA =  Nithiya.B1 noautolegend;
 HISTOGRAM Occupation;
 DENSITY Occupation;
RUN;
QUIT;



* BOXPLOT;
TITLE"Product_Category_1";
PROC SGPLOT DATA = Nithiya.B1;
 VBOX Product_Category_1 ;
RUN;
QUIT;
* BOXPLOT;
TITLE"Product_Category_2";
PROC SGPLOT DATA = Nithiya.B1;
 VBOX Product_Category_2 ;
RUN;
QUIT;
TITLE"Product_Category_3";
PROC SGPLOT DATA = Nithiya.B1;
 VBOX Product_Category_3 ;
RUN;
QUIT;
TITLE"Purchase";
PROC SGPLOT DATA = Nithiya.B1;
 VBOX Purchase ;
RUN;
QUIT;


*========================================================================;
*NOTE: variable Product_Category_1 and Purchase having potential outliers;
*========================================================================;


*/Handling Outliers in Product_Category_1 variable*/;

PROC UNIVARIATE DATA= Nithiya.B1;
VAR Product_Category_1;
OUTPUT OUT=boxStats MEDIAN=median QRANGE=iqr;
RUN; 

DATA null;
	SET boxStats;
	CALL symput ('median',median);
	CALL symput ('iqr', iqr);
RUN; 

%PUT &median;
%PUT &iqr;

DATA Nithiya.OUTLIER1;
SET Nithiya.B1;
    IF (Product_Category_1 le &median + 1.5 * &iqr) AND (Product_Category_1 ge &median - 1.5 * &iqr); 
RUN; 

 
 PROC SGPLOT DATA = Nithiya.OUTLIER1;
 VBOX Product_Category_1;
 RUN;
 QUIT;


*/Handling Outliers in purchase variable*/;

PROC UNIVARIATE DATA = Nithiya.B1;
VAR purchase;
OUTPUT OUT=boxStats MEDIAN=median QRANGE=iqr;
RUN; 

DATA null;
	SET boxStats;
	CALL symput ('median',median);
	CALL symput ('iqr', iqr);
RUN; 

%PUT &median;
%PUT &iqr;

DATA Nithiya.OUTLIER1;
SET Nithiya.B1;
    IF (purchase le &median + 1.5 * &iqr) AND (purchase ge &median - 1.5 * &iqr); 
RUN; 

PROC PRINT DATA= Nithiya.OUTLIER1(OBS=5);
RUN;


 PROC SGPLOT DATA = Nithiya.OUTLIER1;
 VBOX PURCHASE;
 RUN;
 QUIT;



 *RENAMING OUTLIER1 TO B2;

 DATA Nithiya.B2;
 SET Nithiya.OUTLIER1;
 RUN;



proc sgplot data=Nithiya.B2;
 heatmap x=Marital_Status y=Purchase;
run;quit;
proc sgplot data=Nithiya.B2;
 title "Marital_Status vs. Purchase";
 reg x=Marital_Status  y=Purchase;
run;
quit;


proc sgplot data=Nithiya.B2;
 heatmap x=Occupation y=Purchase;
run;
quit;
proc sgplot data=Nithiya.B2;
 title "Occupation vs. Purchase";
 reg x=Occupation  y=Purchase;
run;
quit;

proc sgplot data=Nithiya.B2;
 heatmap x=Product_Category_1 y=Purchase;
run;
quit;
proc sgplot data=Nithiya.B2;
 title "Product_Category_1 vs. Purchase";
 reg x=Product_Category_1  y=Purchase;
run;
quit;


proc sgplot data=Nithiya.B2;
 heatmap x=Product_Category_2 y=Purchase;
run;
quit;
proc sgplot data=Nithiya.B2;
 title "Product_Category_2 vs. Purchase";
 reg x=Product_Category_2  y=Purchase;
run;
quit;
proc sgplot data=Nithiya.B2;
 heatmap x=Product_Category_3 y=Purchase;
run;
quit;
proc sgplot data=Nithiya.B2;
 title "Product_Category_3 vs. Purchase";
 reg x=Product_Category_3  y=Purchase;
run;
quit;





*======================================================================================================================================;



*/FEATURE ENGINEERING*/;

DATA Nithiya.B2_EN;
SET Nithiya.B2;
IF City_Category = "A" THEN
City_Category_EN =1;
IF City_Category = "b" THEN
City_Category_EN =2;
IF City_Category = "C" THEN
City_Category_EN =3;

IF Gender = "F" THEN
Gender_EN =0;
IF Gender = "M" THEN
Gender_EN =1;

IF Age = "0-17" THEN
Age_EN =1;
IF Age= "18-25" THEN
Age_EN =2;
IF Age = "26-35" THEN
Age_EN =3;
IF Age = "36-45" THEN
Age_EN =4;
IF Age = "46-50" THEN
Age_EN =5;
IF Age = "51-55" THEN
Age_EN =6;
IF Age = "55+" THEN
Age_EN =7;

IF Stay_In_Current_City_Years = "1" THEN
Stay_In_Current_City_Years_EN =1;
IF Stay_In_Current_City_Years= "2" THEN
Stay_In_Current_City_Years_EN =2;
IF Stay_In_Current_City_Years = "3" THEN
Stay_In_Current_City_Years_EN =3;
IF Stay_In_Current_City_Years = "4+" THEN
Stay_In_Current_City_Years_EN =4;

DROP City_Category Gender Age Stay_In_Current_City_Years;
RENAME 	City_Category_EN = City_Category 
		Gender_EN = Gender 
		Age_EN = Age 
		Stay_In_Current_City_Years_EN = Stay_In_Current_City_Years;

RUN;


PROC PRINT DATA=Nithiya.B2_EN(OBS=20);
RUN;



*======================================================================================================================================;

*/CHECKING CORRELATION*/;




*NVAR =ALL TO INCLUDE ALL VARIABLES IN PANEL, ODS GRAPHIC LIMITS PLOTS A MX OF FIVE VARAIBLES;
ODS GRAPHICS ON;
TITLE "Computing Pearson Correlation Coefficients";
PROC CORR DATA = Nithiya.B2_EN NOSIMPLE RANK PLOTS= MATRIX(NVAR=ALL);
 VAR  			Marital_Status
				Occupation 
				Product_Category_1 
				Product_Category_2 
				Product_Category_3;
 WITH Purchase;
RUN;

TITLE "PRODUCING A CORRELATION MATRIX";
PROC CORR DATA = Nithiya.B2_EN NOSIMPLE PLOTS = MATRIX(HISTOGRAM);
  VAR 			Marital_Status
				Occupation 
				Product_Category_1 
				Product_Category_2 
				Product_Category_3 
				Purchase;
RUN;
ODS GRAPHICS OFF;



ODS GRAPHICS ON;
ODS LISTING ON;
TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = Nithiya.B2_EN PLOTS(MAXPOINTS=NONE);
 MODEL Purchase = 
				Occupation 
				Product_Category_1 
				Product_Category_2 
				Product_Category_3;
RUN;
ODS GRAPHICS OFF;
ODS LISTING OFF;

ODS GRAPHICS ON;
ODS LISTING ON;
TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = Nithiya.B2_EN PLOTS(MAXPOINTS=NONE);
 MODEL Purchase = 
				Gender 
				Age 
				City_Category 
				Stay_In_Current_City_Years;
RUN;
ODS GRAPHICS OFF;
ODS LISTING OFF;


ODS GRAPHICS ON;
ODS LISTING ON;
TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = Nithiya.B2_EN PLOTS(MAXPOINTS=NONE);
 MODEL Purchase = Occupation 
				Product_Category_1 
				Product_Category_2 
				Product_Category_3
				Gender 
				Age 
				City_Category 
				Stay_In_Current_City_Years;
RUN;
ODS GRAPHICS OFF;
ODS LISTING OFF;


*/==> OBSERVATION: R-Squared is 0.1766 in Linear regression.This statistic indicates 
the percentage of the variance in the dependent variable that the independent variables explain collectively.*/;


*running a simple linear regression model;





*WHAT ARE THE TOP MOST ATTRIBUTE MORE IMPACT ON PURCHASING DECISION ;
 *WHAT ARE THE FACTORS IMPACT ON A PERTICULER GENDER (FEMALE) TO BUY?
*WHICH CITY MORE LIKELY TO SPEND MORE?



* Y = B0+B1*X1+...;
* PUSHUPS = B0+B1*REST_PULSE;
* SLOPE(COEFFICIENT/PARAMTER) H0 : B1 =0;
* ALPHA = 0.05;

*INTERPRETATIONS;
*1. NUMBERS OF OBS READ AND USED =9;
*2. STANDARD ANALYSIS OF VARIANCE- ONLY ONE PREDICTOR VARIABLES- THE MODEL IS SIGNIFICANT (SMALL P VALUE)
	YOU REJECT THE NULL HYPOTHESIS THAT THE SLOPE IS ZERO;
*3. ROOT MSE : THE SQUARE ROOF OF THE MEAN SQUARED ERROR- VARIATION IN THE SYSTEM DUE TO ERROR IN STD UNITS;
	*R-SQUARED : ALSO CALLED COEFFICIENT OF DETERMINATION- PROPORTION OF VARIABILITY IN THE DEPENDENT VARABILE
 				 THAT CAN BE EXPLAINED BY THE REGRESSION MODEL;
	*ADJUSTED R-SQUARED : ADJUST FOR THE NUMBER OF PREDICTOR VARAIBLES;
	*CV : THE STADARD DEVIATION OF THE ERROR(ROOT MSE) EXPRESSED AS A PERCENTAGE OF THE MEAN;
		* IS A UNITLESS MEASURE- TO COMPARE THE ERROR BETWEEN MODELS IN WHICH THE UNITS OF THE Y ARE DIFFERENT;
*4. PARAMETER ESTIMATES WITH STANDARD ERROR, T AND P VALUES;
	*INTERCEPT : H0 ;
	* Bs;
	*PUSH_UP = 69.48749 - 0.65077*REST_PULSE;





















TITLE "DEMONSTRATING THE RSQUARE SELECTION METHOD";
PROC REG DATA = Nithiya.B2_EN;
 MODEL Purchase = 
				Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3/SELECTION = RSQUARE CP ADJRSQ ;
RUN;
QUIT;




TITLE "GENERATING PLOTS OF R-SQUARE,ADJUSTED R-SQUARE AND Cp";
PROC REG DATA = Nithiya.B2_EN PLOTS(ONLY) =(RSQUARE ADJRSQ CP);
 MODEL Purchase = 
				Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3/SELECTION = RSQUARE CP ADJRSQ ;
RUN;
QUIT;



TITLE "GENERATING PLOTS OF R-SQUARE,ADJUSTED R-SQUARE AND Cp";
PROC REG DATA = Nithiya.B2_EN PLOTS(ONLY) = (RSQUARE ADJRSQ CP);
 MODEL Purchase = 
				Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3/SELECTION = RSQUARE CP ADJRSQ BEST=3;
RUN;
QUIT;






TITLE "FORWARD,BACKWARD, AND STEPWISE SELECTION METHODS";
PROC REG DATA = Nithiya.B2_EN ;
 MODEL Purchase = 
				Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3/SELECTION = FORWARD;
 MODEL Purchase = 
				Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
			
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3/SELECTION = BACKWARD;
 MODEL Purchase = 
				Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3/SELECTION = STEPWISE;
RUN;
QUIT;

TITLE "FORWARD,BACKWARD, AND STEPWISE SELECTION METHODS";
TITLE "SLENTRY AT 0.15";
PROC REG DATA = Nithiya.B2_EN ;
 MODEL Purchase = 
				Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3/SELECTION = FORWARD SLENTRY=0.15;
RUN;
QUIT;

TITLE "FORCING SELECTED VARAIBLES INTO A MODEL";
PROC REG DATA = Nithiya.B2_EN ;
 MODEL Purchase = 
				Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3/SELECTION = STEPWISE INLCLUDE=1;
RUN;
QUIT;







PROC GLMSELECT data=Nithiya.B2_EN;
class 			Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Marital_Status
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3;
model  PUrchase = Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Marital_Status
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3
/ selection=stepwise select=SL showpvalues stats=all STB;
run;



PROC GLMSELECT data=Nithiya.B2_EN;
class 			Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Marital_Status
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3;
model  PUrchase = Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Marital_Status
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3
/ selection=backward select=SL showpvalues stats=all STB;
run;



PROC GLMSELECT data=Nithiya.B2_EN;
class 			Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Marital_Status
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3;
model  PUrchase = Gender 
				Age 
				Stay_In_Current_City_Years 
				City_Category
				Marital_Status
				Occupation  
				Product_Category_1 
				Product_Category_2 
				Product_Category_3
/ selection=forward select=SL showpvalues stats=all STB;
run;



ODS PDF CLOSE;





















