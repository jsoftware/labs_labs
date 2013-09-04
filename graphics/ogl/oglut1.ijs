
cocurrent 'plab'
require 'gl3 graphics/gl1ut'
coinsert 'jgl1ut'

OPENGLUT=: 0 : 0
pc openglut closeok;
minwh 400 300;cc g opengl compatibility flush;
pas 0 0;
rem form end;
)

openglut_run=: 3 : 0
if. wdisparent 'openglut'do.
  wd'psel openglut;pactive'
  wd 'set g invalid'
else.
  wd OPENGLUT
  NB. wdmove _1 0
  wd 'set g invalid'
  wd'pshow;'
end.
)

openglut_close=: 3 : 0
wd 'pclose'
)

openglut_cancel=: openglut_close

NB. =========================================================
paint=: 3 : 0
gsinit ''
gsdrawdodecahedron''
gsfini ''
)

openglut_g_paint=: paint
openglut_g_char=: gschar
openglut_default=: gsdefault

NB. =========================================================
openglut_run''
