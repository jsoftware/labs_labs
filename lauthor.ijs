coclass 'jlabauthor'

PATHSEP=: '/'

3 : 0''
if. 0~: 4!:0 <'PROFONT_z_' do. PROFONT=: (('Linux';'Darwin';'Android';'Win') i. <UNAME){:: 'Sans 10' ; '"Lucida Grande" 10' ; (IFQT{::'Sans 10';'"Droid Sans" 10') ; 'Tahoma 10' else. PROFONT=: PROFONT_z_ end.
if. 0~: 4!:0 <'FIXFONT_z_' do. FIXFONT=: (('Linux';'Darwin';'Android';'Win') i. <UNAME){:: 'mono 10' ; 'Monaco 10' ; (IFQT{::'monospace 10';'"Droid Sans Mono" 10') ; '"Lucida Console" 10' else. FIXFONT=: FIXFONT_z_ end.
EMPTY
)
ADVANCE=: 0 : 0
To advance the lab, select menu Studio|Advance or the
corresponding shortcut.
)

ALL=: '(All)'
LABDIRECTORY=: jpath '~addons/labs/labs/'
ADDONSDIRECTORY=: }: jpath '~addons/a'
CMARKER=: 'Lab Chapter'
RXCMARKER=: '\\par [\\[:alnum:]* ]*',CMARKER
SMARKER=: 'Lab Section'
RXSMARKER=: '\\par [\\[:alnum:]* ]*',SMARKER
RXPAREN=: '\\par [\\[:alnum:]* ]*)'

IFCOMMENTS=: 1
IFSENTENCES=: 1
LABFOCUS=: _1
IFWINDOWS=: 1

LABS=: ''
LABCAT=: ''
LABCATS=: ''
LABCATSEL=: 0
LABCTD=: ' (ctd)'
FONTSCALE=: 1

AUTOLAB=: 0
labreset=: 3 : 0
LABAUTHOR=: ''
LABCOMMENTS=: ''
LABERRORS=: 0
LABTITLE=: ''
LABWINPOS=: _1
LABOUTPUT=: 1
LABWIDTH=: 61
LABFILE=: ''
LABPATH=: jpath '~addons/labs/labs/'

LINE=: 1{,":<' '

CHAPTERDATA=: ,a:
CHAPTERNDX=: 0
CHAPTERS=: ,a:

CODE=: ''
CODENDX=: 0
SECTIONDATA=: ,a:
NDX=: 0
SECTIONINDEX=: 0
SECTIONS=: ,a:

IFCHAPTERS=: 0
IFNEWSECTION=: 0
IFSOUND=: 0
LABFOCUS=: _1
LABWRAP=: 1
ENDOFLAB=: 0

empty''
WINFONT=: FIXFONT
WINFONTSIZE=: getfontsize WINFONT
WINFONTSIZENOW=: WINFONTSIZE
)
output=: [: empty 1!:2 & 2
outputwin=: labwin_output
start=: 3 : 0
if. #LABS do. y labinit 1 pick LABNDX{LABS end.
empty''
)
lab=: 3 : 0
if. 1=L.y do.
  'file ndx'=. y
  ndx labinit file
elseif. 0 e. $y do.
  labselect''
elseif. 0 = {.y do.
  labrun }.y
elseif. y-:1 do.
  labjump''
elseif. y-:2 do.
  0!:0 <jpath '~addons/labs/labs/lauthor.ijs'
  author_jlabauthor_ ''
elseif. y-:3 do.
  labopt_run''
elseif. 2=3!:0 y do.
  d=. 1 dir y
  if. 0 e. $y do.
    info 'not found: ',y
  elseif. d -: ,<y do.
    labinit y
  elseif. 1 do.
    labselect y
  end.
end.
empty''
)
labnext=: 3 : 0
if. #LABFILE do.
  lab 0
end.
)
labchapterline=: 3 : 0
if. IFCHAPTERS do.
  j=. ' Chapter ',(":1+CHAPTERNDX),' ',(CHAPTERNDX pick CHAPTERS),' '
  output LF,(2$LINE),j,(0>.LABWIDTH-2+#j)$LINE
end.
)
labchaptername=: 3 : 0
if. 1 < #CHAPTERS do.
  (":CHAPTERNDX+1),' ',(CHAPTERNDX pick CHAPTERS),' '
else. '' end.
)
labinit=: 3 : 0
0 labinit y
:
if. 0=labopen y do. return. end.
if. x=0 do.
  dat=. 'Lab: ',LABTITLE,LF
  dat=. dat, (*#LABAUTHOR) # 'Author: ',LABAUTHOR,LF
  dat=. (LABWIDTH#LINE),LF,dat,ADVANCE
  output dat
  labchapterline''
  labrun x
end.
)
labjump=: 3 : 0
if. 0=#LABFILE do. info 'no lab selected' return. end.

if. NDX=0 do.
  if. 0=#LABFILE do.
    info 'no lab selected' return.
  end.
  0 labinit LABPATH,LABFILE
end.
labjump_run''
)
labline=: 3 : 0
j=. ' ',labsectionname''
(2$LINE),j,' ',(0>.LABWIDTH-3+#j)$LINE
)
labopen=: 3 : 0
labreset''
try. dat=. 1!:1 boxopen y
catch.
  info 'not found: ',":>y
  0 return.
end.
LABFOCUS=: 0 >. LABFOCUS

'LABPATH LABFILE'=: pathname >y

IFCHAPTERS=: 1 e. CMARKER E. dat
dat=. toJ dat
dat=. dat,LF -. {:dat
dat=. <;.2 dat
dat=. ;dat #~ -. 'NB. =='&-: @ (6&{.) &> dat

if. IFCHAPTERS do.
  cut=. }:(LF,CMARKER) E. LF,dat
  0!:100 (cut i. 1){.dat
  dat=. cut <;.1 dat
  ind=. dat i.&> LF
  CHAPTERS=: (>:#CMARKER) }.each ind {.each dat
  CHAPTERDATA=: ind }. each dat
else.
  cut=. }:(LF,SMARKER) E. LF,dat
  0!:100 (cut i. 1){.dat
  CHAPTERS=: ,a:
  CHAPTERDATA=: <(cut i. 1)}.dat
end.

if. LABOUTPUT *. IFCOMMENTS do.
  output=: [: empty 1!:2 & 2
else.
  output=: ]
end.

labopenchapter 0
)
labopenchapter=: 3 : 0
CHAPTERNDX=: y
if. IFCHAPTERS do.
  WINTITLE=: LABTITLE,' - ',y pick CHAPTERS
else.
  WINTITLE=: LABTITLE
end.
dat=. y pick CHAPTERDATA
if. #dat do.
  cut=. }:(LF,SMARKER) E. LF,dat
  dat=. cut <;.1 dat
  ind=. dat i.&> LF
  top=. (>:#SMARKER) }.each ind {.each dat
  NDX=: 0
  SECTIONDATA=: ind }. each dat
  SECTIONINDEX=: I. 0< # &> top
  SECTIONS=: SECTIONINDEX { top
else.
  SECTIONDATA=: ,a:
  SECTIONINDEX=: 0
  SECTIONS=: ,a:
end.
NDX=: 0
CODENDX=: 0
CODE=: ''
1
)
labposition=: 3 : 0
j=. (":NDX+1),' of ',":#SECTIONDATA
if. IFCHAPTERS do.
  '(',(":CHAPTERNDX+1),') ',j
end.
)
labrun=: 3 : 0
if. 0=#LABFILE do. info 'no lab selected' return. end.

if. #y do.
  if. y e. i.#SECTIONDATA do.
    NDX=: {. y
    CODENDX=: 0
    CODE=: ''
  else.
    info 'Invalid jump section'
    return.
  end.
end.

if. NDX >: #SECTIONDATA do.
  if. CHAPTERNDX >: <: #CHAPTERS do.
    ENDOFLAB=: 1
    (LF,'End of lab') 1!:2 [ 2 return.
  else.
    labopenchapter CHAPTERNDX+1
    labchapterline''
  end.
end.

if. CODENDX < #CODE do. labruncode'' return. end.
dat=. NDX pick SECTIONDATA
labrun0 dat
)
labrun0=: 3 : 0
'txt dat'=. labsplit y

section=. labline''
txt=. LF, (0<#txt) # wraptext txt
output LF,section,txt

cmd=. (+./\.dat ~: LF)#dat

while. 1 do.
  if. 'PREPARE' -: 7{.cmd do.
    cmd=. }. <;.2 cmd,LF
    ndx=. 1 i.~ 'PREPARE'&-: @ (7&{.) &> cmd
    prep=. ;ndx{.cmd
    cmd=. ;(ndx+1)}.cmd
    runquiet prep
    continue.
  elseif. 'SCRIPT' -: 6{.cmd do.
    cmd=. }. <;.2 cmd,LF
    ndx=. 1 i.~ 'SCRIPT'&-: @ (6&{.) &> cmd
    SCRIPT=: ;ndx{.cmd
    cmd=. ;(ndx+1)}.cmd
    continue.
  end.
  break.
end.

CODE=: labsplitcode cmd
CODENDX=: 0

labruncode''
)
labruncode=: 3 : 0

if. 0=#CODE do.
  labadvance''
  labsetfocus''
  return.
end.
if. IFSENTENCES=0 do.
  labadvance''
  labsetfocus''
  return.
end.

'cmd snd'=. CODENDX pick CODE
CODENDX=: >:CODENDX
if. CODENDX < #CODE do.
  outtxt=. LF,(3#LINE),' more ',(7#LINE),LF
else.
  outtxt=. i.0 0
  labadvance''
end.

if. (1 e. cmd ~: LF) *. 2 = 3!:0 cmd do.
  if. LABERRORS do.
    run1 cmd
  else.
    run cmd
  end.
end.

output outtxt
labsetfocus''
)
labsetfocus=: 3 : 0
if. LABFOCUS do.
smact''
end.
)
labadvance=: 3 : 0
NDX=: >:NDX
CODE=: ''
CODENDX=: 0
)
labsectionname=: 3 : 0
j=. '(',(labposition''),') ',;labsection''
)
labselect=: 3 : 0
labaddons''
labgetfiles y
j=. sort ~. {."1 LABS
if. 1=#j do.
  LABCATS=: LABCAT=: j
else.
  LABCATS=: ALL;j
  if. (0=#LABCAT) +. -. LABCAT e. LABCATS do.
    LABCAT=: <ALL
  end.
end.
labsel_run''
)
labwelcome=: 3 : 0
r=. LF,'Welcome to lab: ',LABTITLE
if. 0<#LABAUTHOR do.
  r=. r,LF,LF,'Author: ',LABAUTHOR
end.
r=. r,LF,LF,ADVANCE
)
labsection=: 3 : 0
r=. ({.SECTIONS),a:
if. 0 < NDX do.
  j=. (<:+/NDX >: SECTIONINDEX) pick SECTIONS
  k=. (-.NDX e. SECTIONINDEX)#LABCTD
  if. #j do. r=. j;k end.
end.
r
)
labsplit=: 3 : 0
ind=. 2+((LF,')') E. y) i. 1
}. each ind ({.;}.) y
)
labsplitcode=: 3 : 0
f=. 'SOUND'&-: @ (5&{.) &>
if. IFSOUND do.
  dat=. <;.2 (termLF y) , 'SOUND',LF
  b=. f dat
  dat=. (5*b) }.each dat
  dat=. b <@ (;@}: ; (}: each) @{:) ;.2 dat
  dat=. dat -. <2$a:
else.
  dat=. <;.2 termLF y
  dat=. ;dat #~ -. f dat
  ,<dat;''
end.
)
cat=: ,&,.&.|:
deb=: #~ (+. 1: |. (> </\))@(' '&~:)
dtb=: #~ [: +./\. ' '&~:
info=: wdinfo @ ('Labs'&;)
getfontsize=: 13 : '{.1{._1 -.~ _1 ". y'
pathname=: 3 : '(b#y);(-.b=.+./\.y=PATHSEP)#y'
a=. ''''
quote=: (a&,@(,&a))@ (#~ >:@(=&a))
plurals=: ] , (1: ~: [) # 's'"_
round=: [ * [: <. 0.5"_ + %~
setlocale=: 18!:4 @ <
termLF=: , (0: < #) # LF"_ -. _1&{.
termdelLF=: }.~ [: - 0: i.~ LF&= @ |.
tolist=: ; @: (DEL&, each) @: (,&DEL each)
wdifopen=: boxopen e. ({."1 @: wdforms)
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
setfontsize=: 4 : 0
b=. ~: /\ y='"'
nam=. b#y
txt=. ;:(-.b)#y
ndx=. 1 i.~ ([: *./ e.&'0123456789.') &> txt
nam, ; ,&' ' &.> (<":x) ndx } txt
)
doquiet=: 3 : 0
setlocale 'base'
0!:100 y [ 4!:55<'y'
)
tdo=: 3 : 0
setlocale 'base'
0!:101 y [ 4!:55<'y'
)
tdo1=: 3 : 0
setlocale 'base'
0!:111 y [ 4!:55<'y'
)

runquiet=: doquiet f.
run=: tdo f.
run1=: tdo1 f.
wdmove=: 4 : 0
'px py'=. y
'sx sy'=. 2 {. 0 ". wd 'qm'
'x y w h'=. 0 ". wd 'psel ',x,';qform'
if. px < 0 do. px=. sx - w + 1 + px end.
if. py < 0 do. py=. sy - h + 1 + py end.
wd 'pmove ',": px,py,w,h
)
wraptext=: 3 : 0
if. LABWIDTH > #y do. y return. end.
if. LABWRAP do.
  (LABWIDTH foldtext _2}. y) , _2{.y
else.
  y
end.
)
f=. 3 : 'labnext_jlab_ :: ] '''''
plot_jctrl_fkey_jwplot_=: f f.
jvm_jctrl_fkey_jviewmat_=: f f.
graph_jctrl_fkey_jzgraph_=: f f.
LABFONT=: FIXFONT
LATPATH=: jpath '~addons/labs/labs/'
LATNAME=: 'Lab Author'
LATCFG=: jpath '~config/laconfig.ijs'
MAXRECENT=: 10
XLATRECENT=: LATRECENT=: ''

SOUNDBITES=: ''
UNWRAPIT=: 0
UNWRAP=: ''
IFNEWSECTION=: 0
tinfo=: wdinfo @ (LATNAME&;)
tquery=: [ wdquery (LATNAME&;@])
tclean=: #~ [: -. [: *./\. e.&(' ',LF)
tpartition=: 1: , 2: ~:/\ ]
flread=: (1!:1 :: _1:) @ boxopen
flwrite=: (1!:2 :: _1:) boxopen
flreads=: 3 : 0
dat=. (1!:1) :: _1: boxopen y
if. (dat -: _1) +. 0=#dat do. return. end.
dat,LF -. {:dat=. toJ dat
)
flwrites=: 4 : 0
dat=. x
if. -. 0 e. $dat do.
  if. 1>:#$dat do.
    dat=. toCRLF dat
    dat=. dat,(LF ~: {:dat)#CRLF
  else. dat=. dat,"1 CRLF
  end.
end.
dat flwritenew y
)
flwritenew=: 4 : 0
dat=. ,x
if. -. dat -: flread y do. dat flwrite y end.
)
pack=: [: /:~ [: (, ,&< ".)&> ;: ::]
rplc=: 4 : 0
'o n'=. ,&.>y
l=. #o
c=. o E. x=. ,x
if. (0<l) *: 1 e. c do. x return. end.

c=. I. c
while. 0 e. d=. 1,<:/\(#o)<:(}.-}:)c
do. c=. d#c end.
p=. (i.#x) e. 0,c
x=. p <;.1 x
b=. o&-:@(l&$) &> x
f=. n&,@(l&}.) &.>
;(f b#x) (I. b) }x
)
tbuild=: 3 : 0
COMMENTLINE=: 'NB. ',((LABWIDTH-4)#'='),LF
tbuildchapter''

hdr=. 'LABTITLE=: ',(quote LABTITLE),LF
if. #LABAUTHOR do. hdr=. hdr,'LABAUTHOR=: ',tfmttext LABAUTHOR end.
if. #LABCOMMENTS do. hdr=. hdr,'LABCOMMENTS=: ',tfmttext LABCOMMENTS end.
if. LABERRORS=1 do. hdr=. hdr,'LABERRORS=: 1',LF end.
if. LABOUTPUT=0 do. hdr=. hdr,'LABOUTPUT=: 0',LF end.
if. LABWIDTH~:61 do. hdr=. hdr,'LABWIDTH=: ',(":LABWIDTH),LF end.
if. LABWRAP=0 do. hdr=. hdr,'LABWRAP=: 0',LF end.

hdr=. hdr,'LABFOCUS=: ',(":LABFOCUS),LF

if. (1=#CHAPTERS) *. 0=#0 pick CHAPTERS do.
  dat=. }. ; CHAPTERDATA
else.
  chap=. ((COMMENTLINE,CMARKER,' ')&,) each CHAPTERS
  dat=. ; chap ,each CHAPTERDATA
end.

dat=. hdr,LF,dat
dat=. dat rplc (LF,SMARKER);LF,COMMENTLINE,SMARKER
)
tbuildchapter=: 3 : 0
if. 0=tread'' do. return. end.
f=. [: # -. & (' )',LF)
nil=. I. 0 = f&> SECTIONDATA
for_t. |.nil do. tdelsection t end.
j=. (SMARKER,' ')&, each SECTIONS
hdr=. j SECTIONINDEX} (#SECTIONDATA) # <SMARKER
dat=. LF, ;hdr ,each SECTIONDATA
CHAPTERDATA=: (<dat) CHAPTERNDX} CHAPTERDATA
)
tcanclosefile=: 3 : 0
if. 0=#LABTITLE do. 1 return. end.
tclosefile''
)
tcleanup=: 3 : 0
labreset''
18!:55 <'jlabauthor'
)
tclosefile=: 3 : 0
if. 0=#LABFILE do.
  if. 0 = #;SECTIONS do. 1 return. end.
  j=. 'Save lab?'
  if. 0 ~: 2 tquery j do. 1 return. end.
  tsave''
else.
  if. 0=tread'' do. 0 return. end.
  datold=. termdelLF freads LABPATH,LABFILE
  datnew=. termdelLF tbuild''
  if. datold -: datnew do. 1 return. end.
  j=. 'File has changed',LF,LF
  j=. j,'Save changes?'
  if. 0 ~: 2 tquery j do. 1 return. end.
  tsavedat datnew
end.
1
)
tcopylab=: 3 : 0
j=. 'LABAUTHOR LABERRORS LABTITLE LABWIDTH'
j=. j,' LABWRAP NDX SECTIONDATA'
pdef_jlab_ pack j
)
tdeletefile=: 3 : 0
t=. 'mb open "Select File" "',LABPATH,'" '
t=. t,'"Lab (*.ijt)|*.ijt"'
fl=. wd t
if. 0=#fl do. 0 return. end.
j=. 'OK to delete ',fl,'?'
if. 0=2 tquery j do.
  1!:55 <fl
end.
)
tdelchapter=: 3 : 0
if. (CHAPTERNDX=0) *. 1=#CHAPTERDATA do. return. end.
msk=. CHAPTERNDX ~: i.#CHAPTERDATA
CHAPTERDATA=: msk # CHAPTERDATA
CHAPTERS=: msk # CHAPTERS
labopenchapter CHAPTERNDX <. <:#CHAPTERDATA
)
tdelsection=: 3 : 0
if. (NDX=0) *. 1=#SECTIONDATA do. return. end.
SECTIONDATA=: (y{.SECTIONDATA), (>:y)}.SECTIONDATA

if. (NDX e. SECTIONINDEX) *. (NDX+1) e. SECTIONINDEX do.
  msk=. SECTIONINDEX ~: NDX
  SECTIONS=: msk # SECTIONS
  SECTIONINDEX=: msk # SECTIONINDEX
end.

SECTIONINDEX=: SECTIONINDEX - SECTIONINDEX > NDX
NDX=: NDX <. <:#SECTIONDATA

msk=. SECTIONINDEX < #SECTIONDATA
SECTIONINDEX=: msk # SECTIONINDEX
SECTIONS=: msk # SECTIONS

)
terrormsg=: 3 : 0
a=. }: <@}.;._2 ] 13!:12''
tinfo y,LF,LF,'Run error:',LF,LF, ; ,&LF each a
)
runquiet=: doquiet :: terrormsg
run=: tdo :: terrormsg
run1=: tdo1 :: terrormsg
tfmttext=: 3 : 0
if. LF e. y do.
  '0 : 0',LF,(termLF y),')',LF
else.
  (quote y),LF
end.
)
tjoin=: 4 : 0
text=. LF,(termLF ,x),')'
code=. LF,(termLF ,y),LF
text,code
)
tnew=: 3 : 0
labreset_jlab_''
tshow 0
)
topenfile=: 3 : 0
fl=. y
if. 0=#fl do.
  t=. 'mb open "Select File" "',LABPATH,'" '
  t=. t,'"Labs|*.ijt|All Files|*";'
  fl=. wd t
  if. 0=#fl do. return. end.
end.
if. 0=labopen fl do. return. end.
wd 'pn *Lab Author',(0<#LABTITLE)#' - ',LABTITLE
author_setchapters 1
taddrecent''
tshow 0
)
tread=: 3 : 0

wd 'psel author'
text=. tclean toJ text
code=. tclean toJ code

exit=. {.1{.y

if. 0=#LABTITLE do.
  tinfo 'Enter the Lab Header information'
  latprop_run''
  0 return.
end.

if. (0=#deb chapter) *. IFCHAPTERS do.
  tinfo 'Enter the Chapter name'
  wd 'setfocus chapter'
  0 return.
end.

if. (0=#deb section) *. NDX=0 do.
  tinfo 'Enter the Section name'
  wd 'setfocus section'
  0 return.
end.

CHAPTERS=: (<chapter) CHAPTERNDX} CHAPTERS

j=. <text tjoin code
if. NDX=#SECTIONDATA do.
  SECTIONDATA=: SECTIONDATA,j
else.
  SECTIONDATA=: j NDX} SECTIONDATA
end.

curtop=. 0 pick labsection''

if. -. section -: curtop do.
  SECTIONINDEX=: NDX,SECTIONINDEX
  SECTIONS=: (<section),SECTIONS
end.
msk=. ~: SECTIONINDEX
SECTIONS=: msk # SECTIONS
SECTIONINDEX=: msk # SECTIONINDEX

msk=. 1, }. (~: _1&|.) SECTIONS
SECTIONS=: msk # SECTIONS
SECTIONINDEX=: msk # SECTIONINDEX

ind=. /: SECTIONINDEX
SECTIONS=: ind { SECTIONS
SECTIONINDEX=: ind { SECTIONINDEX
SECTIONINDEX=: (#SECTIONINDEX) $ 0, }.SECTIONINDEX

1
)
truler=: 3 : 0
j=. (1,(LABWIDTH-2),1) # '|-|'
k=. ' width ',(":LABWIDTH),' chars '
k (4+i.#k)} j
)
tsave=: 3 : 0
if. 0=tread'' do. return. end.
if. 0=#LABFILE do.
  tsaveas''
else.
  tsavedat tbuild''
end.
taddrecent''
)
tsavedat=: 3 : 0
dat=. toCRLF y
s=. dat fwrite fl=. LABPATH,LABFILE
tinfo 'Saved: ',fl
)
tsaveas=: 3 : 0
t=. 'mb save "Save File" "',LABPATH,LABFILE,'" '
t=. t,'"Lab (*.ijt)|*.ijt"'
fl=. wd t
if. 0=#fl do. 0 return. end.
if. '.' e. fl do.
  if. -. '.ijt' -: _4 {. fl do.
    tinfo 'Filename must have *.ijt extension' return.
  else.
    fl=. _4 }. fl
  end.
end.
if. fexist fl,'.ijt' do.
  j=. 'File ',fl,'.ijt exists.',LF,LF
  j=. j,'OK to replace it?'
  if. 1=2 tquery j do. return. end.
end.
'LABPATH LABFILE'=: pathname fl
LABFILE=: LABFILE,(-. '.'e.LABFILE)#'.ijt'
tsave''
)
tshow=: 3 : 0
'type focus'=. 2{.y
if. 0=type do. ORGSECTIONDATA=: NDX{SECTIONDATA end.
'txt cod'=. labsplit NDX pick SECTIONDATA
'top ctd'=. labsection''
wd 'psel author'
wd 'set chapter text *',CHAPTERNDX pick CHAPTERS
wd 'set section text *',top
wd 'set tctd text *',ctd
wd 'set tposition text *',labposition''
wd 'set text text *',}:txt
wd 'set code text *',cod
wd 'setenable back ',":0<NDX
wd 'setenable unwrap ',":UNWRAPIT
if. focus do. wd 'setfocus text' end.
UNWRAP=: UNWRAPIT#UNWRAP
UNWRAPIT=: 0
)
CFGHDR=: ; < @ ('NB. '&,) ;.2 (0 : 0)
Lab Author configuration

defines:
LATRECENT      recent lab author loads

)

extijt=: , ((0: < #) *. [: -. '.'"_ e. ]) # '.ijt'"_
extnone=: {.~ (i.&'.')

fexist=: 1:@(1!:4)@boxopen :: 0:
fexists=: #~ fexist&>

drophead=: ] }.~ #@[ * [ -: #@[ {. ]
jdirname=: (jpath '~install/') & drophead
partname=: jdirname @ extnone

labfull=: fullname_j_ @ extijt

labpart=: 3 : 0
y=. LATPATH drophead extnone y
x=. y {.~ y i. PATHSEP_j_
if. -. y -: x,PATHSEP_j_,x do. y end.
)
a=. ''''
quote=: (a&,@(,&a))@ (#~ >:@(=&a))
nounrep=: 3 : 0
dat=. ". y
if. (0=#dat) +. 2=3!:0 dat do.
  if. LF e. dat do.
    dat=. dat, LF -. {:dat
    y,'=: 0 : 0', LF, ; <;.2 dat,')',LF
  else.
    y,'=: ',(quote dat),LF
  end.
else.
  y,'=: ',(":dat),LF
end.
)
tcfgread=: 3 : 0
XLATRECENT=: LATRECENT=: ''
try. 0!:0 <LATCFG catch. end.
XLATRECENT=: fexists labfull each LF cutopen LATRECENT
)
tcfgsave=: 3 : 0
LATRECENT=: tolist partname each XLATRECENT
dat=. CFGHDR
dat=. dat,LF,nounrep 'LATRECENT'
dat flwrites LATCFG
)
taddrecent=: 3 : 0
f=. <LABPATH,LABFILE
if. -. f -: {.1{.XLATRECENT do.
  XLATRECENT=: ({.~ MAXRECENT"_ <. #) ~. f,XLATRECENT
  tcfgsave''
end.
)
LATCHAP=: 0 : 0
pc latchap closeok;pn "Select Chapter";
bin v;
groupbox;
cc s0 static;cn "Lab:";
cc labid static;
cc labinfo static;
cc l2 static;cn "Name:";
wh 426 150;cc listbox listbox;
groupboxend;
bin zv;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
bin sz;
pas 4 2;pcenter;
rem form end;
)

labfmt=: 4 : 0
DEL,'(',(":x),') ',y,DEL
)

latchap_run=: 3 : 0
tbuildchapter''
NDXOLD=: CHAPTERNDX
wd LATCHAP
s=. #CHAPTERDATA
wd 'set labid text *',LABTITLE
wd 'set labinfo text *Select a chapter.'
d=. ;(1+i.#CHAPTERS) labfmt each CHAPTERS
wd 'set listbox items ',;d
wd 'setselect listbox ',":CHAPTERNDX
wd 'setfocus listbox'
wd 'pshow;'
)

latchap_doit=: 3 : 0
try. wd 'pclose' catch. end.
wd 'psel author'
if. CHAPTERNDX ~: NDXOLD do.
  labopenchapter CHAPTERNDX
  tshow 0
end.
)

latchap_listbox_button=: 3 : 0
CHAPTERNDX=: ".listbox_select
latchap_doit''
)

latchap_ok_button=: latchap_listbox_button
latchap_enter=: latchap_listbox_button
latchap_cancel_button=: wd bind 'pclose'
JLATSEL=: 0 : 0
pc latsel closeok;pn "Select Section";
cc s0 static;cn "Lab:";
cc labid static;cn "labid";
cc s1 static;cn "Chapter:";
cc chapterid static;cn "chapterid";
cc label static;cn "Number:";
cc secnum edit;
cc sections static;cn "of 34";
cc l2 static;cn "Name:";
wh 328 150;cc listbox;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
cc labinfo static;cn "labinfo";
pas 4 2;pcenter;
rem form end;
)

labfmt=: 4 : 0
DEL,'(',(":x),') ',y,DEL
)

latsel_run=: 3 : 0
NDXOLD=: NDX
wd JLATSEL
s=. #SECTIONDATA
wd 'set labid text *',LABTITLE
wd 'set chapterid text *',CHAPTERNDX pick CHAPTERS
wd 'set labinfo text *Select section by number or name.'
wd 'set sections text *of ',":s
d=. ;(SECTIONINDEX+1) labfmt each SECTIONS
wd 'set listbox items ',;d
wd 'set secnum text ',":NDX+1
wd 'setselect secnum 0 ',":#":NDX
n=. (<:#SECTIONINDEX) <. +/NDX>SECTIONINDEX
wd 'setselect listbox ',":n
wd 'setfocus secnum'
wd 'pshow;'
)

latsel_doit=: 3 : 0
try. wd 'pclose' catch. end.
wd 'psel author'
if. NDX ~: NDXOLD do. tshow 0 end.
)

latsel_listbox_button=: 3 : 0
NDX=: (".listbox_select){SECTIONINDEX
latsel_doit''
)

latsel_listbox_select=: 3 : 0
wd 'set secnum text ',":>:(".listbox_select){SECTIONINDEX
)

latsel_ok_button=: 3 : 0
if. #secnum do.
  num=. <: {. 1{. _1 ". secnum
  if. -. num e. i.#SECTIONDATA do.
    tinfo 'Invalid section number: ',secnum
    return.
  else.
    NDX=: num
  end.
else.
  NDX=: (".listbox_select){SECTIONINDEX
end.
latsel_doit''
)

latsel_secnum_button=: latsel_enter=: latsel_ok_button
latsel_cancel_button=: wd bind 'pclose'
boxfont=: 3 : 0
font=. ' ',y
b=. (font=' ') > ~:/\font='"'
a: -.~ b <;._1 font
)
mbfont=: 3 : 0
if. #y do.
  y=. boxfont y
  y=. ({.y), tolower each }.y
  y=. y -. 'ansi';'oem';'default'
  y=. }: ; ,&' ' &.> y
end.
r=. wd 'mb font ',y
r=. r, (0=#r)#LABFONT
)
TFONT=: 0 : 0
pc tfont closeok dialog owner;pn "Configure View";
cc edfont edit;
cc browse button;cn "&Browse";
cc ok button;cn "OK";
cc s0 static;cn "Select Font:";
pas 6 6;pcenter;
rem form end;
)
tfont_run=: 3 : 0
wd TFONT
wd 'set edfont text *',LABFONT
wd 'pshow;'
)
tfont_browse_button=: 3 : 0
edfont=: mbfont edfont
wd 'set edfont text *',edfont
)
tfont_ok_button=: 3 : 0
LABFONT=: edfont
try. wd 'psel tfont;pclose' catch. end.
wd 'psel author'
author_setfont''
tshow 1
)
tfont_close=: tfont_ok_button
ORDERTYPE=: 0

TORDER=: 0 : 0
pc torder;
cc type static;
wh 270 208;cc list listbox multiplesel;
cc up button;cn "Move &Up";
cc down button;cn "Move Do&wn";
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
cc clear button;cn "&Clear Selections";
cc restore button;cn "&Restore Original";
pas 4 2;pcenter;
rem form end;
)
tordnum=: 3 : 0
if. y=1 do. <'' else.
  tordnum1=: ' ('&, @ (,&(' of ',(":y),')')) @ ":
  tordnum1 each >: i.y
end.
)
torder_run=: 3 : 0
if. 0=tread'' do. return. end.
ORDERTYPE=: y

if. ORDERTYPE=0 do.
  name=. 'Sections'
  len=. 2 -~/\ SECTIONINDEX,#SECTIONDATA
  TLIST=: len#SECTIONS
  TLISTLEN=: # &> TLIST
  TLIST=: TLIST ,each ; tordnum each len
else.
  name=. 'Chapters'
  TLIST=: CHAPTERS
end.

if. (1 >: #TLIST) +. 0=#;TLIST do.
  tinfo 'There is only one ',ORDERTYPE pick 'section.';'chapter.'
  return.
end.

TLISTNDX=: i.#TLIST
TORGLIST=: TLIST
TSELECT=: _1

wd TORDER
wd 'pn *Rearrange ',name
wd 'set text type ',name,':'
torder_show''
wd 'setfocus ok'
wd 'pshow;'
)
torder_cancel_button=: wd bind 'pclose'
torder_show=: 3 : 0
wd 'set list items *',; ,&LF each TLIST
wd ;';setselect list '&, @ ": each _1,TSELECT
)
torder_clear_button=: 3 : 0
TSELECT=: -1
torder_show''
)
torder_restore_button=: 3 : 0
TLIST=: TORGLIST
TSELECT=: _1
torder_show''
)
torder_ok_button=: 3 : 0
if. TLIST -: TORGLIST do. return. end.

if. ORDERTYPE=0 do.
  t=. (TLISTNDX { TLISTLEN) {. each TLIST
  SECTIONINDEX=: I. tpartition t
  SECTIONS=: SECTIONINDEX { t
  SECTIONDATA=: TLISTNDX { SECTIONDATA
  NDX=: TLISTNDX i. NDX
else.
  CHAPTERDATA=: TLISTNDX{CHAPTERDATA
  CHAPTERS=: TLIST
  CHAPTERNDX=: TLISTNDX i. CHAPTERNDX
end.

wd :: ] 'pclose'
wd 'psel author'
tshow''
)
torder_up_button=: torderit bind 0
torder_down_button=: torderit bind 1
torderit=: 3 : 0
listndx=. ,". list_select
if. 0=#listndx do. return. end.
if. -. listndx -: ({.listndx) + i.#listndx do.
  tinfo 'Selections must be contiguous'
  return.
end.
if. y do.
  ndx=. listndx tmovedown #TLIST
else.
  ndx=. listndx tmoveup #TLIST
end.
TLIST=: ndx{TLIST
TLISTNDX=: ndx{TLISTNDX
TSELECT=: ndx i. listndx
torder_show''
)
tmoveup=: 4 : 0

list=. i.y
move=. x #~ x ~: i.#x

while. #move do.
  ndx=. _1 0 + {.move
  move=. }.move
  list=. (|. ndx{list) ndx} list
end.

list
)
tmovedown=: 4 : 0

list=. i.y
move=. x #~ x ~: y - >:i.-#x
while. #move do.
  ndx=. 0 1 + {:move
  move=. }:move
  list=. (|. ndx{list) ndx} list
end.

list
)
RECENT=: 0 : 0
pc lrecent nomin owner;pn "Recent Labs";
cc s0 static;cn "Labs:";
wh 300 1988;cc l0 listbox;
cc cancel button;cn "Cancel";
cc ok button;cn "OK";
pas 2 1;pcenter;
rem form end;
)
lrecent_run=: 3 : 0
if. 0 e. #XLATRECENT do.
  info 'No recent labs.' return.
end.

rp=. labpart each XLATRECENT

pos=. wd 'qform'
wd RECENT
wdcenter pos

wd 'set l0 text *', tolist rp
wd 'setselect l0 0'
wd 'setfocus l0;pas 0 0;'
wd 'pshow'
)
lrecent_close=: 3 : 0
wd 'pclose'
wd 'psel author;pactive'
)
lrecent_doit=: 3 : 0
wd 'pclose'
if. #l0 do.
  wd 'psel author'
  topenfile (".l0_select) pick XLATRECENT
end.
wd 'psel author;pactive'
)
lrecent_enter=: lrecent_ok_button=: lrecent_l0_button=: lrecent_doit
lrecent_cancel=: lrecent_cancel_button=: lrecent_close
llast_run=: 3 : 0
j=. XLATRECENT -. < LABPATH,LABFILE
if. 0 e. #j do.
  info 'No last lab.' return.
end.
topenfile >{.j
)
LATPROP=: 0 : 0
pc latprop;pn "Lab Header";
bin v;
cc s0 static;cn "Title (required):";
cc title edit;
bin h;
bin v;
cc s1 static;cn "Author (optional):";
wh 256 86;cc author editm;
bin z;
groupbox "Options";
cc ifwrap checkbox;cn "&Allow Text Wrap:";
cc chapters checkbox;cn "Use &Chapters:";
cc errors checkbox;cn "Continue After &Errors:";
cc nooutput checkbox;cn "&No Session Output";
cc sessionfocus checkbox;cn "&Focus to Session";
bin h;
cc s3 static;cn "&Text Width:";
cc width edit;
bin z;
groupboxend;
bin z;
cc s2 static;cn "Comments (optional):";
wh 462 100;cc comments editm;
bin hs;
cc help button;cn "Help";
cc cancel button;cn "Cancel";
cc ok button;cn "OK";
bin z;
pas 4 2;pcenter;
rem form end;
)
latprop_run=: 3 : 0

if. wdifopen 'latprop' do. wd 'psel latprop;pactive' return. end.

wd LATPROP

wd 'set title text *',LABTITLE
wd 'set author text *',LABAUTHOR
wd 'set comments text *',LABCOMMENTS
wd 'set chapters value ',":IFCHAPTERS
wd 'set errors value ',":LABERRORS
wd 'set ifwrap value ',":LABWRAP
wd 'set nooutput value ',":0=LABOUTPUT
wd 'set sessionfocus value ',":2 | LABFOCUS
wd 'set width text ',":LABWIDTH

wd 'setfocus title'
wd 'pshow;'
)
latprop_cancel_button=: 3 : 0
wd 'pclose;psel author'
)

latprop_help_button=: 3 : 0
htmlhelp_j_ 'user/labs.htm'
)

latprop_ok_button=: 3 : 0
if. 0=#deb title do.
  info 'You must enter a lab title'
  return.
end.
j=. _1 ". width
if. -. (1=#j) *. (j-:<.j) *. (j>:20) *. j<:200 do.
  j=. 'Invalid width ',width,LF,LF
  j=. j,'Should be an integer between 20 and 200'
  tinfo j
  return.
end.
LABWIDTH=: j
LABTITLE=: termdelLF title
LABAUTHOR=: termdelLF author
LABCOMMENTS=: termdelLF comments
LABERRORS=: ". errors
LABOUTPUT=: 0=".nooutput
IFCHAPTERS=: ".chapters
LABFOCUS=: ".sessionfocus
LABWRAP=: ".ifwrap
wd 'pclose;psel author'
wd 'pn *Lab Author - ',LABTITLE
wd 'set ruler text *',truler''
author_setchapters 1
)
TLAB=: 0 : 0
pc author;pn "Lab Author";
menupop "&File";
menu new "&New" "" "" "";
menu open "&Open..." "" "" "";
menusep;
menu llast "&Last" "" "" "";
menu lrecent "&Recent..." "" "" "";
menusep;
menu save "&Save" "" "" "";
menu saveas "Save &As..." "" "" "";
menusep;
menu deletefile "&Delete..." "" "" "";
menusep;
menu print "&Print" "" "" "";
menusep;
menu runlab "&Run Lab" "" "" "";
menusep;
menu exit "E&xit" "" "" "";
menusep;
menu quit "&Quit" "" "" "";
menupopz;
menupop "&Edit";
menu unwrap "&UnWrap" "" "" "";
menusep;
menu header "&Lab Header..." "" "" "";
menusep;
menu font "&Font..." "" "" "";
menupopz;
menupop "Cha&pter";
menu previouschapter "&Previous" "" "" "";
menu nextchapter "&Next" "" "" "";
menu selectchapter "&Select..." "" "" "";
menusep;
menu insertchapter "&Insert Chapter" "" "" "";
menu deletechapter "&Delete Chapter" "" "" "";
menusep;
menu chapterorder "&Rearrange Chapters..." "" "" "";
menusep;
menu enablechapter "&Enable Chapters" "" "" "";
menupopz;
menupop "&Section";
menu firstsection "&First" "" "" "";
menu lastsection "&Last" "" "" "";
menu selectsection "&Select..." "" "" "";
menusep;
menu insertsection "&Insert Section" "" "" "";
menu deletesection "&Delete Section" "" "" "";
menusep;
menu sectionorder "&Rearrange Sections..." "" "" "";
menusep;
menu restoresection "Rest&ore Section" "" "" "";
menupopz;
menupop "&Help";
menu overview "&Overview" "" "" "";
menusep;
menu helpauthor "&Author" "" "" "";
menupopz;
bin v;
bin hs;
cc wrap button;cn "&Wrap";
cc close button;cn "&Close";
bin z;
bin h;
cc singlechapter static;cn "Chapter";
cc schapter static;cn "Chapter:";
cc chapter edit;
bin z;
bin h;
cc ssection static;cn "Section:";
cc section edit;
cc tposition static;
cc back button;cn "&<<";
cc run button;cn "&Run";
cc next button;cn "&>>";
bin z;
cc tctd static;cn "(ctd)";
cc ruler static;
wh 664 200;cc text editm;
wh 664 290;cc code editm;
bin z;
pas 0 0;pcenter;
rem form end;
)
author_run=: 3 : 0
if. wdisparent 'author' do.
  wd 'psel author;pshow;pactive' return.
end.
wd TLAB
author_setfont''
wd 'set ruler text *',truler''
wd 'setshow schapter 0'
wd 'setshow chapter 0'
if. #y do.
  topenfile y
else.
  tnew''
end.
author_setchapters 0
wd 'setfocus text'
wd 'pshow;'
)
author_setchapters=: 3 : 0
wd 'psel author'
wd 'set singlechapter text *',(y=1)#'Lab has a single Chapter'
if=. ":IFCHAPTERS
wd 'setshow singlechapter ',":0=IFCHAPTERS
wd 'setshow schapter ',if
wd 'setshow chapter ',if
wd 'setenable previouschapter ',if
wd 'setenable nextchapter ',if
wd 'setenable selectchapter ',if
wd 'setenable insertchapter ',if
wd 'setenable deletechapter ',if
wd 'setenable chapterorder ',if
wd 'set enablechapter ',if
)
author_setfont=: 3 : 0
wd 'psel author'
wd 'setfont ruler ',LABFONT
wd 'setfont text ',LABFONT
wd 'setfont code ',LABFONT
)
author_actrl_fkey=: 3 : 0
if. NDX >: #SECTIONDATA do.
  output 'End of Chapter'
else.
  author_run_button''
  if. CODENDX >: #CODE do.
    author_next_button ''
    d=. wd 'qd'
    ({."1 d)=: {:"1 d
  end.
end.
)
author_back_button=: 3 : 0
if. 0<NDX do.
  if. tread'' do.
    NDX=: 0 >. <: NDX
    tshow 0 1
  end.
end.
)
author_chapter=: 3 : 0
if. y=CHAPTERNDX do. return. end.
if. 0=tread'' do. return. end.
labopenchapter y
tshow''
)
author_close=: 3 : 0
if. 0=tcanclosefile '' do. return. end.
wd 'pclose'
tcleanup ''
)
author_deletechapter_button=: 3 : 0
if. (CHAPTERNDX=0) *. 1=#CHAPTERDATA do.
  tinfo 'Cannot delete Chapter 1 if there is no Chapter 2.'
  return.
end.
j=. 'OK to delete this chapter?'
if. 0=2 tquery j do.
  tdelchapter NDX
  tshow 0
end.
)
author_deletesection_button=: 3 : 0
if. (NDX=0) *. 1=#SECTIONDATA do.
  tinfo 'Cannot delete Section 1 if there is no Section 2.'
  return.
end.
j=. 'OK to delete this section?'
if. 0=2 tquery j do.
  tdelsection NDX
  tshow 0
end.
)
author_enablechapter_button=: 3 : 0
if. IFCHAPTERS do.
  if. (1<#CHAPTERS) +. # 0 pick CHAPTERS do.
    msg=. 'Do you want to revert to a single chapter?'
    if. 1=2 tquery msg do. return. end.
    j=. 'Close Lab Author and edit out the Chapters manually'
    tinfo 'This option not supported yet.',LF,LF,j
    return.
  end.
end.
IFCHAPTERS=: -.IFCHAPTERS
author_setchapters 1
)
author_firstsection_button=: 3 : 0
if. 0<NDX do.
  if. tread'' do. tshow 0 [ NDX=: 0 end.
end.
)
author_helpauthor_button=: 3 : 0
htmlhelp_j_ 'user/lab_author.htm'
)
author_insertchapter_button=: 3 : 0
tbuildchapter''
ndx=. CHAPTERNDX+1
CHAPTERDATA=: (ndx{.CHAPTERDATA),a:,ndx}.CHAPTERDATA
CHAPTERS=: (ndx{.CHAPTERS),a:,ndx}.CHAPTERS
labopenchapter ndx
tshow 0
)
author_insertsection_button=: 3 : 0
if. 0=tread'' do. return. end.
NDX=: NDX+1
SECTIONDATA=: (NDX{.SECTIONDATA),a:,NDX}.SECTIONDATA
SECTIONINDEX=: SECTIONINDEX + SECTIONINDEX >: NDX
tshow 0
)
author_lastsection_button=: 3 : 0
if. NDX < <:#SECTIONDATA do.
  if. tread'' do. tshow 0 [ NDX=: <:#SECTIONDATA end.
end.
)
author_llast_button=: 3 : 0
if. tcanclosefile'' do. llast_run'' end.
)
author_lrecent_button=: 3 : 0
if. tcanclosefile'' do. lrecent_run'' end.
)
author_next_button=: 3 : 0
if. 0=tread'' do. return. end.
ndx=. >:NDX
if. ndx = #SECTIONDATA do.
  if. IFNEWSECTION=0 do.
    j=. 'End of Chapter',LF,LF,'Add new section?'
    if. 1=2 tquery j do. return. end.
  end.
  IFNEWSECTION=: 1
  SECTIONDATA=: SECTIONDATA,a:
end.
NDX=: ndx
tshow 0 1
)
author_newchapter=: 3 : 0
tbuildchapter''
CHAPTERS=: CHAPTERS,a:
CHAPTERDATA=: CHAPTERDATA,a:
author_chapter <:#CHAPTERS
)
author_nextchapter_button=: 3 : 0
if. 0=tread'' do. return. end.
if. 0=#CHAPTERNDX pick CHAPTERS do.
  tinfo 'First complete the current Chapter' return.
end.
if. CHAPTERNDX=<:#CHAPTERS do.
  msg=. 'At the last Chapter.',LF,LF,'Add a new Chapter?'
  if. 0=2 tquery msg do. author_newchapter'' end.
  return.
end.
tbuildchapter''
author_chapter CHAPTERNDX+1
)
author_overview_button=: 3 : 0
htmlhelp_j_ 'user/lab_system_overview.htm'
)
author_new_button=: 3 : 0
if. tcanclosefile'' do. latprop_run tnew '' end.
)
author_open_button=: 3 : 0
if. tcanclosefile '' do. topenfile '' end.
)
author_previouschapter_button=: 3 : 0
if. CHAPTERNDX=0 do.
  tinfo 'At the first Chapter'
  return.
end.
tbuildchapter''
author_chapter CHAPTERNDX-1
)
author_print_button=: 3 : 0
prints_j_ tbuild''
)
author_restoresection_button=: 3 : 0
if. 0=2 tquery 'OK to restore section?' do.
  SECTIONDATA=: ORGSECTIONDATA NDX} SECTIONDATA
  tshow 1
end.
)
author_run_button=: 3 : 0
ndx=. NDX
if. CODENDX < #CODE do.
  tcopylab 0
  labruncode_jlab_''
else.
  if. tread'' do.
    tcopylab 0
    tshow 1 1
    labrun0_jlab_ NDX pick SECTIONDATA
  end.
end.
NDX=: ndx
)
author_selectchapter_button=: 3 : 0
if. 0=tread'' do. return. end.
if. 1=#CHAPTERS do.
  tinfo 'Only one Chapter to select from'
else.
  latchap_run''
end.
)
author_selectsection_button=: 3 : 0
if. 0=tread'' do. return. end.
if. 0=#;SECTIONS do.
  tinfo 'Nothing to select from.'
else.
  latsel_run''
end.
)
author_runlab_button=: 3 : 0
if. 0=#LABTITLE do.
  info 'Lab not created yet'
else.
  if. tclosefile'' do.
    if. #LABFILE do. lab_j_ LABPATH,LABFILE end.
  end.
end.
)
author_enter=: 3 : 0
if. tread'' do. tshow 1 end.
)
author_wrap_button=: 3 : 0
if. 0=#text do. return. end.
if. 0=tread'' do. return. end.
'text code'=. labsplit NDX pick SECTIONDATA
old=. termdelLF }: text
text=. LABWIDTH foldtext old
if. old -: text do. return. end.
dat=. text tjoin code
UNWRAP=: old
UNWRAPIT=: 1
SECTIONDATA=: (<dat) NDX} SECTIONDATA
tshow 1
)
author_unwrap_button=: 3 : 0
dat=. UNWRAP tjoin code
SECTIONDATA=: (<dat) NDX} SECTIONDATA
tshow 1
)
author_cancel=: author_close
author_chapter_button=: author_enter
author_chapterorder_button=: torder_run bind 1
author_close_button=: author_close
author_deletefile_button=: tdeletefile
author_exit_button=: author_close
author_header_button=: latprop_run
author_font_button=: tfont_run
author_quit_button=: tcleanup @ wd bind 'pclose'
author_save_button=: tsave
author_saveas_button=: tsaveas
author_section_button=: author_enter
author_sectionorder_button=: torder_run bind 0

author_sctrl_fkey=: author_save_button
author=: 3 : 0
labreset''
tcfgread''
author_run''
)
