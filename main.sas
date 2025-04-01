FILENAME REFFILE '../cirrhosisNoDRUG.csv';
PROC IMPORT DATAFILE=reffile
DBMS=csv REPLACE
OUT=WORK.df;
GETNAMES=YES;
RUN;

%include "../GrabVariables.sas";

%let ExclusionList = 'VAR1' 'ID' 'Age' 'N_Days' 'Status';

%GrabVariables(data="df", exclude= &ExclusionList);

%put &VariableNames;
%put &ClassVariables;

ods trace on;
ods output ModelBuildingSummary = mssngSummary;

proc phreg data=df;
class &ClassVariables.;
model N_Days*Status(0) = &VariableNames. /
			selection=stepwise 
			slentry=0.20
                        slstay=0.20 
                        details;
run;

ods trace off;