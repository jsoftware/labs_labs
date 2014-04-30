
require'gl3 graphics/gl1ut'
coinsert'jgl1ut'

GL3LAB=: 0 : 0
pc gl3lab closeok;
minwh 200 200;cc g opengl compatibility flush;
pas 0 0;
rem form end;
)

gl3lab_run=: 3 : 0
wd GL3LAB
wd'pshow;'
)

gl3lab_close=: 3 : 0
wd'pclose'
)

gl3lab_g_paint=: 3 : 0
smoutput 'paint'
g_draw_init gl_qwh''
g_draw''
)

gl3lab_g_char =: 3 : 0
dorot 360 | R + 2 * 'xyz' = {.sysdata
)

R=: 0 0 0

dorot=: 3 : 0
wd'psel gl3lab'
R=: y
gl_paintx''
)

NB. y is wh - cmds required for new render context
g_draw_init=: 3 : 0
glViewport 0 0,y
glMatrixMode GL_PROJECTION
glLoadIdentity''
gluPerspective 60, (%/y),1 10
)

g_draw=: 3 : 0
draw''
)

R1 =: R2 =: 20 30 0
S =: 1
NB. glSelectBuffer 100

gl3lab_g_char =: verb define
k=.0{sysdata
if. S=1 do.
 R1 =: 360 | R1 + 2 * 'xyz'=k end.
if. S=2 do.
 R2 =: 360 | R2 + 2 * 'xyz'=k end.
gl_paintx''
)

gl3lab_g_mbldown =: verb define
wh=. gl_qwh''
'xx yy' =. 2{.".sysdata
'w h'=. wh

select=. mema 16            NB. allocate select buffer
(4$2-2)memw select,0,4,JINT NB. clear buffer to 0
glaSelectBuffer 4,select
glRenderMode GL_SELECT
glInitNames''
glPushName _1
glMatrixMode GL_PROJECTION

glPushMatrix''
 glLoadIdentity''
 gluaPickMatrix xx , yy , 20 20, 0 0 , w , h
 gluPerspective 60, (w%h),1 10
 draw''
glPopMatrix''
glFlush''
glRenderMode GL_RENDER
S=: 3{memr select,0,4,JINT
smoutput S
memf select                 NB. free select buffer
)

BLUE=:  0 0 1
GREEN=: 0 1 0
RED=:   1 0 0

drawbox=:verb define
p=. _1 ^ #: i.8
BLUE         polygon 0 1 3 2{p
GREEN        polygon 0 1 5 4{p
RED          polygon 0 2 6 4{p
(RED+BLUE)   polygon 4 5 7 6{p
(RED+GREEN)  polygon 1 3 7 5{p
(BLUE+GREEN) polygon 2 3 7 6{p
)

polygon=: 4 : 0
glColor 4{.x,1
glBegin GL_POLYGON
 glVertex y
glEnd ''
)

draw=:verb define
glClearColor 1 1 1 0
glClear GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT
glEnable GL_DEPTH_TEST
glMatrixMode GL_MODELVIEW
glLoadIdentity''
glTranslate 2 0 _8
glRotate R1 ,. 3 3 $ 1 0 0 0
glLoadName 1
drawbox ''
glMatrixMode GL_MODELVIEW
glLoadIdentity''
glTranslate _2 0 _8
glRotate R2 ,. 3 3 $ 1 0 0 0
glLoadName 2
drawbox ''
)
