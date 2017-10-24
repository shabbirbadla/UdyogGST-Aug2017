cthermometer = 'gsThermometer'
otherm = createobject(cthermometer)
otherm.titlebar = 0
otherm.controlbox = .t.

otherm.show()
*!*	READ EVENTS
*!*	otherm.timeobj.timer()
for i = 1 to 80
	otherm.progress1.value = i
	=INKEY(0.01)
endfor	
*!*	CLEAR EVENTS 

define class gsthermometer as form
	showwindow = 2
	height = 82
	width = 325
	autocenter = .t.
	backcolor = rgb(240,240,240)
*!*		titlebar = 0	
*!*		borderstyle = 0
	caption = ""
	closable = .f.
	controlbox = .f.
	maxbutton = .f.
	minbutton = .f.
	movable = .f.
	alwaysontop = .f.
	name = "gsThermometer"

*!*		ADD OBJECT timeobj as timer with;
*!*			interval = 100

	add object shapeouter as shape with ;
		top = 2, ;
		left = 2, ;
		height = 78, ;
		width = 323, ;
		backstyle = 0, ;
		borderwidth = 2, ;
		curvature = 5, ;
		specialeffect = 0, ;
		bordercolor = rgb(0,128,255), ;
		style = 0, ;
		name = "ShapeOuter"

	add object image1 as image with ;
		picture = [bmp\30.ico],;
		backstyle = 0, ;
		height = 64, ;
		left = 10, ;
		top = 8, ;
		width = 64, ;
		name = "Image1"

	add object progress1 as textbox with ;
		value = 1, ;
		visible = .f., ;
		name = "Progress1"


	add object lblprogress as label with ;
		fontbold = .t., ;
		backstyle = 0, ;
		caption = "Connect Database..", ;
		height = 14, ;
		left = 40, ;
		top = 18, ;
		width = 384, ;
		forecolor = rgb(255,0,0), ;
		name = "lblProgress"


	add object shapeprogress as shape with ;
		top = 42, ;
		left = 10, ; &&77
		height = 32, ;
		width = 309, ;
		backstyle = 1, ;
		specialeffect = 0, ;
		backcolor = rgb(240,240,240),; && 174,228,255..255,255,240
		name = "ShapeProgress"


	add object label1 as label with ;
		fontbold = .t., ;
		fontsize = 24, ;
		backstyle = 0, ;
		caption = (replicate("I",50)), ;
		height = 30, ;
		left = 14, ; && 81
		top = 39, ;
		width = 304, ; && 404
		forecolor = rgb(192,192,192), ;
		name = "Label1"


	add object label2 as label with ;
		fontbold = .t., ;
		fontsize = 24, ;
		backstyle = 0, ;
		caption = "Label2", ;
		height = 30, ;
		left = 12, ; && 79
		top = 39, ;
		width = 304, ;
		forecolor = rgb(0,128,255), ; && rgb(0,192,0)
		name = "Label2"

	add object label3 as label with ;
		fontbold = .t., ;
		fontsize = 24, ;
		backstyle = 0, ;
		caption = "Label3", ;
		height = 30, ;
		left = 14, ; && 81
		top = 39, ;
		width = 304, ;
		forecolor = rgb(0,128,255), ;
		name = "Label3"

*!*		add object panel as olecontrol with ;
*!*			height = 25, ;
*!*			width = 408, ;
*!*			oleclass = 'mscomctllib.sbarctrl.2', ;
*!*			name = "Panel"


	procedure destroy
	set cursor on
	endproc


	procedure init
		this.progress1.value = 0
		inkey(0.001)
		set cursor off
		this.zorder(0)
		inkey(0.001)
	endproc


	procedure progress1.programmaticchange
		this.parent.label2.caption = replicate("I",this.value/2)
		this.parent.label3.caption = replicate("I",this.value/2)
	ENDPROC
enddefine