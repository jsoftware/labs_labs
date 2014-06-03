
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

gl3lab_g_char =: 3 : 0
dorot 360 | R + 2 * 'xyz' = {.sysdata
)

R=: 0 0 0

dorot=: 3 : 0
wd'psel gl3lab'
R=: y
gl_paint''
)

gl3lab_g_paint =: verb define
glClearColor 0 0 1 0
glClear GL_COLOR_BUFFER_BIT
glOrtho 0 2 0 2 0 2   NB. view is a box, xyz coords of 0 to 2
glMatrixMode GL_MODELVIEW
drawtriangle ''
)

drawtriangle =: verb define
glTranslated 1 1 _1
glRotated R ,. 3 3 $ 1 0 0 0
glColor4d 1 0 0 0
glBegin GL_POLYGON
 glVertex 0.5 0.5 0.5                NB. add vertex
 glVertex  1 0 0 , 0 1 0 ,: _1 0 0   NB. triangle
glEnd ''
)
