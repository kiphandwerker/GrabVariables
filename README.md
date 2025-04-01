# Variable Grab

# Overview
This is a simple Macro to grab variables of interest for things like variable selection for model building. Sometimes datasets can be very large and having to type out a bunch of variables is very cumbersome. This tool makes it a bit easier to get started.

# Set-up
<ol>
<li> Clone the Github repository.</li>

```
    git clone https://github.com/kiphandwerker/GrabVariables.git
```

<li>Upload the files to SAS OnDemand or SAS program of choice.
<li>Change the main.sas file to point to the appropriate location.
</ol>

# Usage
The main.sas file contains all of the code necessary to run the macro, however we will walk through it step by step:

<ol>
<li> Import your dataset of choice.

```sas
FILENAME REFFILE '../cirrhosis.csv';
PROC IMPORT DATAFILE=reffile
DBMS=csv REPLACE
OUT=WORK.df;
GETNAMES=YES; RUN;
```
Note: Be sure to change your path to the appropriate location.

<li> Source the function

```sas
%include "../GrabVariables.sas";
``` 

Note: Be sure to change your path to the appropriate location.

<li>Provide the appropriate inputs for the function and run it.

The GrabVariables() macro takes in 3 arguments:

<ul>
    <li><strong>lib:</strong> Provide the location of the library. Defaults to 'WORK'.
    <li><strong>data:</strong> The dataset you want the variables for.
    <li><strong>exclude:</strong> A list of variables you want to exclude from the variable selection.
</ul>

```sas
%let ExclusionList = 'VAR1' 'ID' 'Age' 'N_Days' 'Status';

%GrabVariables(data="df", exclude= &ExclusionList);
```


<li>The variables of interest are read into VariableNames and ClassVariables within the macro. To view them, simply call them to the console.

```sas
%put &VariableNames;
%put &ClassVariables;
```
    %put &VariableNames;
    Drug Sex Ascites Hepatomegaly Spiders Edema Bilirubin Cholesterol Albumin Copper Alk_Phos SGOT Tryglicerides Platelets Prothrombin 
    Stage AgeYrs

    %put &ClassVariables;
    Drug Sex Ascites Hepatomegaly Spiders Edema Stage
<li> Now we can build a model selection proc a bit easier.

```sas
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
```

Instead of having to create a long list of variables for both the class and independent variables, we can just use the macro outputs.
</ol>
