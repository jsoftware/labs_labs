NB. NB. make lab system
NB.
NB.
NB. obsolete...
NB.
NB. f=. (jpath '~Source\main\labs\') & , @ (, & '.ijs')
NB.
NB. LABFNS=: f each <;._2 (0 : 0)
NB. labutil
NB. labfiles
NB. labini
NB. labjmp
NB. labopt
NB. labsel
NB. labwin
NB. labreset
NB. )
NB.
NB. LATFNS=: f each <;._2 (0 : 0)
NB. labini
NB. labutil
NB. latinit
NB. latfns
NB. latcfg
NB. latchap
NB. latsel
NB. latfont
NB. latorder
NB. latrecnt
NB. latwin
NB. latprop
NB. labreset
NB. )
NB.
NB. (jpath '~addons/labs/labs/labdir.ijs') copynew_jproject_ jpath '~Source\main\labs\labdir.ijs'
NB.
NB. t1=.jpath '~temp\t42.ijs'
NB. t2=.jpath '~temp\t43.ijs'
NB. ferase t1
NB. ferase t2
NB.
NB. t1 scriptmake LABFNS
NB. dat=. freads t1
NB. dat=. 'require ''dir files kfiles regex text''',LF,dat
NB. dat=. 'coclass ''jlab''',LF,dat
NB. dat fwrites t1
NB.
NB. t2 scriptmake LATFNS
NB. dat=. freads t2
NB. dat=. 'require ''print''',LF,dat
NB. dat=. 'coclass ''jlabauthor''',LF,dat
NB. dat fwrites t2
NB.
NB. tlab=. jpath '~addons/labs/labs/lab.ijs'
NB. taut=. jpath '~addons/labs/labs/lauthor.ijs'
NB.
NB. tlab copynew_jproject_ t1
NB. taut copynew_jproject_ t2
NB.
