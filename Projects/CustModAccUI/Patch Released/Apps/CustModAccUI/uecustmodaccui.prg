Lparameters lBugid &&,lVumess
Store '' To currPath , exename

currDir = Curdir()

currPath = Substr(currDir,1,At("\",currDir,2)) + 'CustModAccUI\UpdtExe'
*!*	Messagebox(currPath)
Try
	If Empty(lBugid)
		exename = '\vu10Updt_'
	Else
		exename = '\vu10Updt_'+Alltrim(lBugid)
	Endif
*!*	nExecute = "'"+'Build Exe "'+currPath+'\vu10Updt_'+Alltrim(lBugid)+'"'+' From "'+currPath+'\vu10Updt.PJX"'+"'"
	nExecute = "'"+'Build Exe "'+currPath+exename+'"'+' From "'+currPath+'\vu10Updt.PJX"'+"'"
	Wait Window "Please Wait, Generating EXE Process is going on...." Nowait
	Execscript(&nExecute)
	Wait Window "Processing done...." Nowait
	Messagebox("EXE has been generated successfully." + Chr(13) + "Please find the EXE in the below location path : " + Chr(13) + currPath + exename + ".exe","") &&,lVumess)

Catch To ex
	Wait Clear
	Messagebox(ex.Message,0+16,"")
Finally
	Wait Clear
	Quit
Endtry
