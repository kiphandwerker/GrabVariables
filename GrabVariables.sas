%macro GrabVariables(lib = "WORK", data=df, exclude = exclude);
	%let vl = %sysfunc(dosubl(%nrstr(
	proc sql noprint;
	    select name into: VariableNames separated by ' '
	        from dictionary.columns
	        where libname = %upcase(&lib)
	        and memname = %upcase(&data)
	        and name not in (&exclude);
	quit;
	)));
%mend;