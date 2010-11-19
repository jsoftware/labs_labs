NB. labdir.ijs
NB.
NB. defines noun LABDIR as a table of shortname + full pathname
NB. for lab directories.
NB.
NB. If you want to modify this, first make a copy in your
NB. configuration directory (specified by CONFIG_j_ in
NB. profile.ijs), then modify the copy. This will be read
NB. instead of the original script.
NB.
NB. Use an underscore for a blank in the shortname.

j=. <;._2 (0 : 0)
Language           ~system\extras\labs\language
Graphics           ~system\extras\labs\graphics
System             ~system\extras\labs\system
Concrete_Math      ~system\extras\labs\cmc
General_Interest   ~system\extras\labs\general
Math               ~system\extras\labs\math
Live_Texts         ~system\extras\labs\livetexts
Personal           ~system\extras\labs\personal
User               ~user\labs
Addons             ~addons
)

ndx=. j i.&> ' '
nms=. ndx {.each j
dir=. ndx }.each j
ndx=. (=&' ' i. 0:) &> dir
dir=. ndx }.each dir
LABDIR=: nms ,. jpath each dir
