NB. autolab
NB.
NB. form: autolabs 1/0 (on/off)

cocurrent 'jlab'
require '~addons/labs/labs/lab.ijs'

AUTOLAB=: 0
AUTONDX=: 0
AUTOTIMER=: 7  NB. set to 0 to stop running autolab
AUTOPATH=: jpath '~addons/labs/labs/'

NB. =========================================================

AUTOLABS=: cutopen 0 : 0
core/intro.ijt
core/j.ijt
core/jtaste1.ijt
core/jtaste2.ijt
core/locales.ijt
core/monad.ijt
core/sparse.ijt
livetexts/arithmetic.ijt
livetexts/candg.ijt
livetexts/grade8-7.ijt
livetexts/linearalgebra.ijt
general/fuzzy.ijt
graphics/fractals.ijt
graphics/graphut.ijt
graphics/plot.ijt
math/area.ijt
math/bestfit.ijt
math/bincoefs.ijt
math/catalan.ijt
math/families.ijt
math/fntab.ijt
math/frame.ijt
math/iter.ijt
math/mathroot.ijt
math/pythag3.ijt
math/rot.ijt
math/shapley.ijt
math/spiral.ijt
math/teachersaide.ijt
math/volume.ijt
system/files.ijt
system/mapfile.ijt
system/odbcblob.ijt
system/odbcint.ijt
system/odbcinv.ijt
system/pm.ijt
system/regbuild.ijt
system/regex.ijt
)

NB. =========================================================
settimer=: 3 : 0
wd 'timer ',":1000 * y
if. y do.
  sys_timer_z_=: autotimer_jlab_
else.
  sys_timer_z_=: ]
end.
i.0 0
)

NB. =========================================================
autotimer=: 3 : 0
if. ENDOFLAB do.
  settimer 0
autoclear''
  AUTONDX=: (#AUTOLABS) | AUTONDX + 1
  autolab''
else.
  wd 'reset'
  lab 0
  settimer AUTOTIMER
end.
)

NB. ==
autoclear=: 3 : 0
fselect_z_=: ]
clear_base_ ''
)

NB. =========================================================
autolab=: 3 : 0
lab AUTOPATH, AUTONDX pick AUTOLABS
settimer AUTOTIMER
)

NB. =========================================================
autolabs=: 3 : 0
AUTOLAB=: y
if. y do.
  if. (#LABFILE) *. 0 = ENDOFLAB do.
    lab 0
    settimer AUTOTIMER
 else.
    autolab''
  end.
else.
  settimer 0
end.
)
