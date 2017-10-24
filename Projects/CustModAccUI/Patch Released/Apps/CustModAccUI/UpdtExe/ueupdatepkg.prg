ON ERROR 
WAIT WINDOW 'Getting Details..........' NOWAIT

LOCAL _mdebug 
_mdebug = .t.
	
nretval=0
nhandle=0
sqlconobj=NEWOBJECT('sqlconnudobj',"sqlconnection",xapps)

WAIT WINDOW 'Updating Details..........' NOWAIT

IF _mdebug = .t.
	IF TYPE('ueReadRegMe.r_comp') != 'C'
		=STRTOFILE('Unregistered','ServerInfo.Txt')
	ELSE
		=STRTOFILE(ueReadRegMe.r_comp,'ServerInfo.Txt')
		=STRTOFILE(ueReadRegMe.r_MACId,'ServerInfo.Txt',1)		
		=STRTOFILE(company.co_name,'ServerInfo.Txt',1)			
	Endif	
Endif

IF USED('CustFeature')
	USE IN CustFeature
Endif	
SELECT 0 
USE CustFeature again SHARED 

SELECT CustFeature
SCAN
	IF ALLTRIM(UPPER(CustFeature.ccomp)) == ALLTRIM(UPPER(company.co_name))
		IF TYPE('ueReadRegMe.r_comp') = 'C'
			_rmacid = CustFeature.rmacid
			_rmacid = RevStr(_rmacid)
			IF ALLTRIM(UPPER(CustFeature.rcomp)) == ALLTRIM(UPPER(ueReadRegMe.r_comp)) AND ALLTRIM(UPPER(_rmacid)) == ALLTRIM(UPPER(ueReadRegMe.r_MACId))
				DO Case
				CASE CustFeature.OptionType = 'MENU'
					_newoption = NewEncry('CUST:MENU',ALLTRIM(_rmacid))
					_newoption = CAST(_newoption as varbinary(250))
					msqlstr = "update com_menu set newrange = ?_newoption where LTRIM(RTRIM(padname))+LTRIM(RTRIM(barname)) = ?CustFeature.OptionDesc"
					nretval=sqlconobj.dataconn('EXE',company.dbname,msqlstr,"","nHandle")
				CASE CustFeature.OptionType = 'REPORT'
					_newoption = NewEncry('CUST:REPORT',ALLTRIM(_rmacid))
					_newoption = CAST(_newoption as varbinary(250))
					msqlstr = "update r_status set newgroup = ?_newoption where LTRIM(RTRIM([group]))+LTRIM(RTRIM([desc]))+LTRIM(RTRIM([rep_nm])) = ?CustFeature.OptionDesc"
					nretval=sqlconobj.dataconn('EXE',company.dbname,msqlstr,"","nHandle")
				CASE CustFeature.OptionType = 'TRAN'
					_newoption = NewEncry('CUST:TRAN',ALLTRIM(_rmacid))
					_newoption = CAST(_newoption as varbinary(250))
					msqlstr = "update lcode set cd = ?_newoption where LTRIM(RTRIM(entry_ty)) = ?CustFeature.OptionDesc"
					nretval=sqlconobj.dataconn('EXE',company.dbname,msqlstr,"","nHandle")
				Endcase	
			Endif	
		Endif		
	Endif
	SELECT CustFeature
Endscan			
		
IF USED('CustFeature')
	USE IN CustFeature
Endif	


nretval=sqlconobj.sqlconnclose("nHandle") && Connection Close
CLOSE all
WAIT CLEAR
=MESSAGEBOX('Updation Done Successfully',64,vumess)
exitclick = .T.


PROCEDURE RevStr
LPARAMETERS _actval
_revval = ''
FOR i = 1 TO LEN(_actval)
	_revval = SUBSTR(_actval,i,1)+_revval
Endfor
RETURN _revval
