
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

NB. y is wh - cmds required for new render context
g_draw_init=: 3 : 0
smoutput'new rc'
glViewport 0 0,y
)

g_draw=: 3 : 0
glClearColor 0 0 1 0
glClear GL_COLOR_BUFFER_BIT
glOrtho _1 1 _1 1 _1 1
glColor3d ?0 0 0
glBegin GL_POLYGON
 glVertex  1,0,0
 glVertex  0,1,0
 glVertex _1,0,0
glEnd ''
)

NB. press Ctrl+f to report frames/second
gl3lab_fctrl_fkey=: 3 : 0
start=. 6!:1''
for. i.100 do.
 gl_paint''
end.
time=. (6!:1'')-start
smoutput 'w h: ',(":gl_qwh''),' frames/sec: ',":100%time
)

NB. y is wh
NB. get pixels from pixel buffer render context
get_pixels=: 3 : 0
NB. ogl=. ''conew'jzopengl'
NB. alloc__ogl y   NB. new context for pixel buffer
NB. g_draw_init gl_qwh''
NB. g_draw''
NB. r=. pixels__ogl''
NB. r
0
)
