PARAMETERS apath
IF TYPE("apath")="L"
	apath=SYS(5)+CURDIR()
ENDIF
objWMIService        = GetObject("winmgmts:")
_servicerunning   = .F.
_servicename      = addbs(apath)+'Udyog.Application.License.Service.exe'
m_runingprocess  = objwmiservice.execquery("Select * from Win32_Service")

FOR EACH objprocess IN m_runingprocess
	IF UPPER(objprocess.NAME) = 'UDYOG APPLICATION LICENSE MANAGER'
		_servicerunning = .T.
	ENDIF
NEXT

IF _servicerunning = .T.
	SET DEVICE TO screen
	! &_servicename /uninstall
ENDIF
