
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
metrics=: ('arial';30) glaUseFontOutlines 32 95 32 0 0.3,WGL_FONT_POLYGONS
)

g_draw=: 3 : 0
glMatrixMode GL_PROJECTION
glLoadIdentity ''
glOrtho 0 2 0 2 0 2
glClearColor 0 0 1 0
glClear GL_COLOR_BUFFER_BIT

glMatrixMode GL_MODELVIEW
glLoadIdentity ''

glRotated 20 0 1 0

glEnable GL_LIGHTING
glEnable GL_LIGHT0

lighttext''
glColor 1 1 1 0
glRasterPos 0 1 0
glaCallLists 'iiiiwwww'
)

lighttext=: 3 : 0
glaLight GL_LIGHT0, GL_AMBIENT, 0.6 0.6 0.6 1
glaLight GL_LIGHT0, GL_DIFFUSE, 0.9 0.9 1 1
glaLight GL_LIGHT0, GL_SPECULAR, 1 1 1 1
glaLight GL_LIGHT0, GL_POSITION, 1 1 1.1 1
glaMaterial GL_FRONT_AND_BACK,GL_SPECULAR, 1 1 1 1
glaMaterial GL_FRONT_AND_BACK,GL_SHININESS, 128 0 0 1
)
