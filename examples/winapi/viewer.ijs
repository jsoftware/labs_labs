NB. J viewer - sample app using notify icon.
NB. See the "Taskbar Notification Area" lab for more info.

NB. This application puts an icon in the Windows task
NB. notification area and does some simple processing
NB. when selected with the mouse.


require 'format files jview plot'
require '~system\extras\util\browser.ijs'
require '~system\classes\winapi\notify.ijs'


mainline=: verb define
i=. (jpath '~addons/labs/labs/examples/winapi/viewer.ico');0;'J Viewer'
NOTIFY=: i conew 'jnotify'
IJX=: 1=#ARGV_j_  NB. flag whether .ijx window is showing
wd 'pc keepalive'
)


NB. Gets called for mouse events over the notification icon.
notify_handler=: verb define
'msg wparam lparam'=. y
select. lparam
  case. WM_LBUTTONDOWN_jnotify_ do. NB. Left button
	try. clip=. wd 'clippaste 1' NB. try to get text
	catch. try. clip=. wd 'clippaste 2' NB. else get file names
		catch. clip=. '' NB. nothing we can use in clipboard.
		end.
	end.
    t=. ,:'Hex dump (file name)'; 0; 'dohex_base_';    clip
    t=. t,'Plot (numbers)';       0; 'doplot_base_';   clip
	t=. t,'Browse (html)';        0; 'dobrowse_base_'; clip
	popup__NOTIFY t

  case. WM_RBUTTONDOWN_jnotify_ do. NB. Right button
	t=. ,:'Close';    0; 'doclose_base_'; ''
	t=. t,'';         0; '';        ''
	t=. t,(>IJX{'Show';'Hide');0;'doijx_base_';''
	t=. t,'About...'; 0; 'doabout_base_'; ''
	popup__NOTIFY t
end.
empty ''
)




NB. Actions.  The right argument for all the verbs below is
NB. the contents of the clipboard.


NB. dohex - show hex dump for file(s) named in clipboard
dohex=: verb define
for_f. <;._2 y,LF#~LF~:{:y do.
	d=. fdir >f
	if. (1~:#d)+.'d' e. >(<0;4) >@{ :: 0: d do.
		wd 'mb "J Viewer" *Not a file: ',>f
	else.
		wdview ('Hex dump of ',(>f),':'),'',hexdump fread >f
	end.
end.
)


NB. doplot - plot numbers in clipboard
doplot=: verb define
d=. 0&".;._2 y,LF#~LF~:{:y
('surface'#~1~:#d) plot d
)


NB. dobrowse - browse HTML in clipboard
dobrowse=: verb define
y fwrite f=. jpath '~temp\htmldisp.htm'
launch_jbrowser_ f
) 


NB. doclose - close app
doclose=: verb define
destroy__NOTIFY ''
if. 1<#ARGV_j_ do. 2!:55]0 end.
)


NB. doijx - hide/show .ijx window
doijx=: verb define
f=. ,(#~ 'jijx'&-:@>@:(3&{"1)) wdforms '' NB. ijx row (if any)
if. IJX do.   NB. ijx currently showing
	wd 'psel ',(>1{f),';pshow sw_hide'
else.  NB. not showing
	if. *#f do.  NB. ijx has been created
		wd 'psel ',(>1{f),';pshow sw_show'
	else.  NB. not created yet
		newijx_jijs_ ''
	end.
end.
IJX=: -.IJX
)


NB. doabout - show "about" box
doabout=: wd bind ('mb "J Viewer" *J Viewer App',LF,LF,'Sample application demonstrating use of notification area.')



NB. start the verb automatically if started from
NB. command line
verb define ''
if. 1<#ARGV_j_ do. mainline '' end.
)