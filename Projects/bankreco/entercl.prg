para xy
*	wait wind 'working..'
if last()=13
	if cl_date>=date 
	  	=messagebox("Cleared-on Date cannot be Less than the DATE", 64, "Visual Udyog")
	endif
	if empty(cl_date) and !empty(clause)
	  	=messagebox("Cleared-on Date cannot be Less than the DATE", 64, "Visual Udyog")
	endif
endif
