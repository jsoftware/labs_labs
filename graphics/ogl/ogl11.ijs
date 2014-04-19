
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

gl3lab_g_char =: 3 : 0
dorot 360 | R + 2 * 'xyz' = {.sysdata
)

R=: 0 0 0

dorot=: 3 : 0
wd'psel gl3lab'
R=: y
gl3lab_g_paint''
glpaint''
)

BLUE=:  0 0 1
GREEN=: 0 1 0
RED=:   1 0 0

drawbox=:3 : 0
BOX=:1
p=. _1 ^ #: i.8
glNewList BOX , GL_COMPILE
 BLUE         polygon 0 1 3 2{p
 GREEN        polygon 0 1 5 4{p
 RED          polygon 0 2 6 4{p
 (RED+BLUE)   polygon 4 5 7 6{p
 (RED+GREEN)  polygon 1 3 7 5{p
 (BLUE+GREEN) polygon 2 3 7 6{p
glEndList ''
)

polygon=: 4 : 0
glColor4d 4{.x,1
glBegin GL_POLYGON
 glVertex y
glEnd ''
)

gl3lab_g_paint =: verb define
drawbox ''          NB. create list that draws a box

glViewport 0 0,wh
glMatrixMode GL_PROJECTION
glLoadIdentity''
gluPerspective 30, (%/wh),1 10

glClearColor 1 1 1 0
glClear GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT
glEnable GL_DEPTH_TEST
glMatrixMode GL_MODELVIEW
glLoadIdentity''
glTranslated 2 0 _8
glRotated R ,. 3 3 $ 1 0 0 0
glCallList BOX
glMatrixMode GL_MODELVIEW
glLoadIdentity''
glTranslated _2 0 _8
glRotated R ,. 3 3 $ 1 0 0 0
glCallList BOX
)