
GL3LAB=: 0 : 0
pc gl3lab closeok;
minwh 200 200;cc g opengl compatibility flush;
pas 0 0;
rem form end;
)

gl3lab_run=: 3 : 0
wd GL3LAB
gl3lab_g_paint''
wd'pshow;'
)

gl3lab_g_paint=: 3 : 0
glClearColor 0 0 1 0
glClear GL_COLOR_BUFFER_BIT
glOrtho _1 1 _1 1 _1 1
glColor3d 0 0 0
glBegin GL_POLYGON
 glVertex 1  ,0  ,0,1
 glVertex 0  ,1  ,0,1
 glVertex _1 ,0  ,0,1
glEnd ''
)
