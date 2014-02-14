NB. Hide all windows in the J session.  A "J" icon in the
NB. taskbar is created.  Clicking on it restores the windows.

require '~system\classes\winapi\notify.ijs'

cocurrent 'jijs'   NB. add to jijs locale


smhidesession=: verb define
sessionnotify=: ((jpath '~bin/j.exe');0;'J Session';999) conew 'jnotify'
('psel '"_ wd@, ] , ';pshow sw_hide'"_)@> 1{"1 wdforms ''
empty ''
)


smshowsession=: verb define
('psel '"_ wd@, ] , ';pshow sw_show'"_)@> 1{"1 wdforms ''
destroy__l '' [ l=. sessionnotify_jijs_
erase <'sessionnotify_jijs_'
empty ''
)



notify_handler=: verb define
'wm wparam lparam'=. y
if. lparam=WM_LBUTTONDOWN_jnotify_ do. smshowsession_jijs_ '' end.
empty ''
)

