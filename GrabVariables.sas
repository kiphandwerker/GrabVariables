%macro GrabVariables(lib = "WORK", data=df, exclude = exclude);
	proc sql noprint;
	    select name into: VariableNames separated by ' '
	        from dictionary.columns
	        where libname = &lib
	        and memname = &data
	        and name not in (&exclude);
	quit;
/*  	%put &=VariableNames.;  */
%mend GrabVariables;