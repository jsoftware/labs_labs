NB. labutil
NB.
NB.   assert       assert
NB.   cat          cat
NB.   deb
NB.   dtb
NB.   info         information msg box
NB.   quote
NB.   pathname
NB.   pdef
NB.   plurals      make word plural
NB.   round        round
NB.   start        start at section in current file
NB.   termLF
NB.   termdelLF
NB.   tolist       convert boxes to character list
NB.   LINE         line character
NB.
NB.   regex fns

PATHSEP_j_=: '/'

coclass 'jlab'


cat=: ,&,.&.|:
deb=: #~ (+. 1: |. (> </\))@(' '&~:)
dtb=: #~ [: +./\. ' '&~:
info=: wdinfo @ ('Labs'&;)
getfontsize=: 13 : '{.1{._1 -.~ _1 ". y'
pathname=: 3 : '(b#y);(-.b=.+./\.y=PATHSEP_j_)#y'
a=. ''''
quote=: (a&,@(,&a))@ (#~ >:@(=&a))
plurals=: ] , (1: ~: [) # 's'"_
round=: [ * [: <. 0.5"_ + %~
setlocale=: 18!:4 @ <
termLF=: , (0: < #) # LF"_ -. _1&{.    NB. ensure LF terminated
termdelLF=: }.~ [: - 0: i.~ LF&= @ |.  NB. ensure not LF terminated
tolist=: }. @ ; @: (LF&, each)
wdifopen=: boxopen e. <;._2 @ (wd bind 'qp')

NB. =========================================================
NB. assert
assert=: 3 : 0
'' assert y
:
if. -. 0 e. y do. return. end.
msg=. x
if. 0=#msg do.
  j=. 'There is a problem with the lab.',LF,LF
  msg=. j,'Try re-loading J and starting it again.'
end.
info msg
laberror=. 13!:8@1:
laberror''
)

NB. =========================================================
pdef=: 3 : 0
if. 0 e. $y do. empty'' return. end.
names=. {."1 y
if. #names do. (names)=: {:"1 y end.
names
:
names=. {."1 y
nl=. ;: ::] x
pdef (names e. nl)#y
)

NB. =========================================================
NB. setfontsize
NB. size setfontsize fontdescription
setfontsize=: 4 : 0
b=. ~: /\ y='"'
nam=. b#y
txt=. ;:(-.b)#y
ndx=. 1 i.~ ([: *./ e.&'0123456789.') &> txt
nam, ; ,&' ' &.> (<":x) ndx } txt
)

NB. =========================================================
doquiet=: 3 : 0
setlocale 'base'
0!:100 y [ 4!:55<'y'
)

NB. =========================================================
tdo=: 3 : 0
setlocale 'base'
0!:101 y [ 4!:55<'y'
)

NB. =========================================================
tdo1=: 3 : 0
setlocale 'base'
0!:111 y [ 4!:55<'y'
)

runquiet=: doquiet f.
run=: tdo f.
run1=: tdo1 f.

NB. =========================================================
NB. wdmove
wdmove=: 4 : 0
'px py'=. y
'sx sy'=. 2 {. 0 ". wd 'qm'
'x y w h'=. 0 ". wd 'psel ',x,';qformx'
if. px < 0 do. px=. sx - w + 1 + px end.
if. py < 0 do. py=. sy - h + 1 + py end.
wd 'pmovex ',": px,py,w,h
)

NB. =========================================================
NB. wraptext
NB. wrap text in jx window
wraptext=: 3 : 0
if. LABWIDTH > #y do. y return. end.
if. LABWRAP do.
  (LABWIDTH foldtext _2}. y) , _2{.y
else.
  y
end.
)

NB. =========================================================
NB. function keys for common applications:
f=. 3 : 'labnext_jlab_ :: ] '''''
plot_jctrl_fkey_jwplot_=: f f.
jvm_jctrl_fkey_jviewmat_=: f f.
graph_jctrl_fkey_jzgraph_=: f f.
