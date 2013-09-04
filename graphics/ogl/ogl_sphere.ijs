
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
gl3lab_g_paint''
)

NB. y is wh - cmds required for new render context
g_draw_init=: 3 : 0
glViewport 0 0,y
glMatrixMode GL_PROJECTION
glLoadIdentity''
gluPerspective 30, (%/y),1 10
)

g_draw=: 3 : 0
glClearColor 0 0 0 0
glClear GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT
glEnable GL_DEPTH_TEST
glMatrixMode GL_MODELVIEW
glLoadIdentity''
glTranslated 0 0 _8
light''
sphere''
)

sphere=: verb define
obj=.>{.gluNewQuadric''
gluQuadricNormals obj,GLU_SMOOTH
gluQuadricDrawStyle obj,GLU_FILL
gluSphere obj,1.5 32 32
gluDeleteQuadric obj
)

light=: verb define
glaLight GL_LIGHT0, GL_AMBIENT, 0.1 0.1 0.1 1
glaLight GL_LIGHT0, GL_DIFFUSE, 0.7 0.7 0.7 1
glaLight GL_LIGHT0,GL_SPECULAR, 0.0 0.0 0.0 1
glEnable GL_LIGHTING
glEnable GL_LIGHT0
glaMaterial GL_FRONT,GL_AMBIENT_AND_DIFFUSE, 1 0 0 1
)
