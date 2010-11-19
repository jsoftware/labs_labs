NB. built from project: ~Source/main/labs/labs
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

NB.! script_z_ '~system/main/compare.ijs'
NB.! script_z_ '~system/main/dir.ijs'
NB.! script_z_ '~system/main/dll.ijs'
NB.! script_z_ '~system/main/files.ijs'
NB.! script_z_ '~system/packages/files/jfiles.ijs'
NB.! script_z_ '~system/packages/files/kfiles.ijs'
NB.! script_z_ '~system/main/regex.ijs'
NB.! script_z_ '~system/main/strings.ijs'
NB.! script_z_ '~system/main/text.ijs'

PATHSEP_j_=: '/' NB.!

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
termLF=: , (0: < #) # LF"_ -. _1&{.
termdelLF=: }.~ [: - 0: i.~ LF&= @ |.
tolist=: }. @ ; @: (LF&, each)
wdifopen=: boxopen e. <;._2 @ (wd bind 'qp')
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
'x y w h'=. 0 ". wd 'psel ',x,';qformx'
if. px < 0 do. px=. sx - w + 1 + px end.
if. py < 0 do. py=. sy - h + 1 + py end.
wd 'pmovex ',": px,py,w,h
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
labaddons=: 3 : 0
ADDLABS=: ''
p=. jpath '~addons/'
0!:0 :: ] <jpath p,'config/config.ijs'
if. #ADDLABS do.
  nms=. <;._1 &> ' ' ,each <;._2 jhostpath ADDLABS
  fls=. (<p) ,each {."1 nms
  msk=. fexist &> fls
  fls=. msk # fls
  nms=. msk # nms
  cat=. {:"1 nms
  tit=. labgettitle1 each fls
  ADDLABS=: cat,.tit,.fls,.<0
else.
  ADDLABS=: i.0 4
end.
)
labgetsubdir=: 3 : 0
t=. 1!:0 y,'*'
b=. 'd' = 4{ &> 4{"1 t
{."1 b # t
)
labdir=: 3 : 0
fl=. jpath '~config\labdir.ijs'
if. 0 = fexist fl do.
  fl=. LABDIRECTORY,'labdir.ijs'
end.
0!:0 <fl
n=. '_ '&charsub each {."1 LABDIR
d=. {:"1 LABDIR
LABDIR=: (~:d) # n,.d
)
labdir1=: 3 : 0
t=. 1!:0 y,'*'
d=. 'd' = 4{ &> 4{"1 t
t=. tolower each {."1 d#t
n=. ((toupper)@{. , }.) each t
t=. n ,. (y&,) each t
b=. 0 < # @ (1!:0) @ (,&'\*.ijt') &> {:"1 t
b=. b +. 0 < # @ (1!:0) @ (,&'\*.rtf') &> {:"1 t
b # t
)
labgetfiles=: 3 : 0
if. #y do.
  path=. y,PATHSEP_j_ -. {:y
  j=. labgetjt path
  if. 0=#j do.
    info 'No tutorials found in: ',":y
    labreset''
    return.
  end.
  dname=. 1 pick pathname }:path
  LABDIR=: 1 2$dname;path
else.
  labdir''
  j=. ; < @ ({. ,. labgettutor &> @ {:)"1 LABDIR
  j=. j,~ADDLABS
end.
j=. (~: 1 {"1 j) # j
LABS=: j sort > 1{"1 j
)
labgettutor=: labgetjt , labgetrtf
labgetjt=: 3 : 0
path=. y, PATHSEP_j_ -. _1{.y
files=. 1 dir jhostpath path,'*.ijt'

if. 0=#files do.
  t=. i.0 3
else.
  sf=. 1 dir jhostpath path,'*.ijf'
  if. #sf do.
    j=. _4&}. each sf
    k=. _4&}. each files
    s=. k e. j
  else.
    s=. (#files)#0
  end.
  t=. labgettitle1 each files
  t=. t,. files (,<)"0 [s
end.

if. #s=. labgetsubdir path do.
  t=. t, ; labgetjt each path&, each s
end.

)
labgettitle1=: 3 : 0
t=. toJ 1!:11 y;0 100
". (t i. LF) {. t
)
labgetrtf=: 3 : 0
i.0 3 return.

path=. y, PATHSEP_j_ -. _1{.y
files=. 1 dir path,'*.rtf'
if. 0=#files do.
  t=. i.0 3
else.
  sf=. 1 dir path,'*.ijf'
  if. #sf do.
    j=. _4&}. each sf
    k=. _4&}. each files
    s=. k e. j
  else.
    s=. (#files)#0
  end.
  ph=. rxcomp_jregex_ 'LABTITLE[ ]*=:'
  t=. ph deb@labrtftitle each files
  rxfree_jregex_ ph
  t=. (*@# &> t) # t,. files (,<)"0 [s
end.

if. #s=. labgetsubdir path do.
  t=. t, ; labgetrtf each path&, each s
end.

)
labrtftitle=: 4 : 0
size=. 1!:4 <y
dat=. fread y;0,size <. 5000
'ndx len'=. {. x rxmatch_jregex_ dat
if. ndx=_1 do.
  'ndx len'=. {. x rxmatch_jregex_ fread y
  if. ndx=_1 do.'' return. end.
end.
dat=. (ndx+len) }. dat
j=. '{}',CRLF
". ((<./ dat i. j) {. dat) -. j
)

ADVANCE=: 0 : 0
To advance the lab, select menu Studio|Advance or the
corresponding shortcut.
)

ALL=: '(All)'
LABDIRECTORY=: jpath '~system\extras\labs\'
ADDONSDIRECTORY=: }: jpath '~addons\a'
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
LABPATH=: jpath '~system\extras\labs\'

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
  0!:0 <jpath '~system\extras\util\lauthor.ijs'
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
  smselout_jijs_''
  smfocus_jijs_''
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

LABJUMP=: 0 : 0
pc labjump closeok;pn "Lab Selection";
xywh 135 34 40 12;cc ok button leftmove rightmove;cn "OK";
xywh 135 49 40 12;cc cancel button leftmove rightmove;cn "Cancel";
xywh 6 35 120 100;cc listbox listbox ws_border ws_vscroll rightmove bottommove;
xywh 7 8 166 11;cc labid static;
xywh 7 22 120 11;cc labinfo static;cn " ";
pas 4 2;pcenter;
rem form end;
)

labfmt=: 4 : 0
DEL,(":x),'. ',y,DEL
)

labjump_run=: 3 : 0
if. 1=#CHAPTERDATA do.
  info 'There is only one chapter in the lab'
  return.
end.
wd LABJUMP
s=. #CHAPTERS
wd 'set labid *',LABTITLE,' (',(":s),(s plurals ' chapter'),')'
wd 'set labinfo *Select a chapter:'
d=. (1+i.#CHAPTERS) labfmt each CHAPTERS
wd 'set listbox ',;d
wd 'setselect listbox ',":CHAPTERNDX
wd 'setfocus listbox'
wd 'pshow;'
)

labjump_listbox_button=: 3 : 0
labopenchapter ".listbox_select
labchapterline''
wd 'pclose'
labrun''
)

labjump_enter=: labjump_ok_button=: labjump_listbox_button
labjump_close=: labjump_cancel=: labjump_cancel_button=: wd bind 'pclose'

LABOPT=: 0 : 0
pc labopt;pn "Lab Options";
xywh 9 9 113 39;cc g0 groupbox;cn "Lab Displays";
xywh 18 21 76 11;cc comments checkbox;cn "Comment text";
xywh 18 33 76 11;cc sentences checkbox group;cn "J sentences";
xywh 136 9 40 12;cc ok button;cn "OK";
xywh 136 24 40 12;cc cancel button;cn "Cancel";
pas 6 6;pcenter;
rem form end;
)
labopt_run=: 3 : 0
wd LABOPT
wd 'set comments ',":IFCOMMENTS
wd 'set sentences ',":IFSENTENCES
wd 'pshow;'
)
labopt_close=: 3 : 0
IFCOMMENTS=: 0 ". comments
IFSENTENCES=: 0 ". sentences
if. LABOUTPUT *. IFCOMMENTS do.
  output=: [: empty 1!:2 & 2
else.
  output=: ]
end.
wd 'pclose'
)
labopt_cancel=: labopt_cancel_button=: wd bind 'pclose'
labopt_ok_button=: labopt_enter=: labopt_close

LABSEL=: 0 : 0
pc labsel closeok;pn "Lab Select";
menupop "Options";
menu comments "Labs display &Comment Text" "" "" "Show comments when running Labs";
menu sentences "Labs display J &Sentences" "" "" "Show sentences when running Labs";
menusep;
menu exit "E&xit" "" "" "";
menupopz;
menupop "Help";
menu intro "&Introduction to Labs..." "" "" "";
menupopz;
xywh 11 12 124 11;cc s0 static;cn "Select a lab";
xywh 7 3 211 23;cc g0 groupbox rightmove;cn "";
xywh 163 11 50 12;cc browse button leftmove rightmove;cn "&Browse...";
xywh 11 39 37 11;cc s1 static;cn "Category:";
xywh 50 38 107 109;cc category combodrop ws_vscroll rightmove;
xywh 11 55 146 157;cc listbox listbox ws_border ws_vscroll rightmove bottommove;
xywh 163 56 50 12;cc ok button leftmove rightmove;cn "&Run";
xywh 163 71 50 12;cc print button leftmove rightmove;cn "&Print";
xywh 163 194 50 12;cc cancel button leftmove topmove rightmove bottommove;cn "&Close";
xywh 7 29 211 183;cc g1 groupbox rightmove bottommove;cn "";
pas 6 4;pcenter;
rem form end;
)

labsel_run=: 3 : 0
if. wdisparent 'labsel' do.
  wd 'psel labsel;pshow;pactive' return.
end.
wd LABSEL
if. IFWINCE do.
  wd 'setshow print 0'
end.
labshowcats''
wd 'set comments ',":IFCOMMENTS
wd 'set sentences ',":IFSENTENCES
wd 'setfocus listbox'
wdfit''
wd 'pshow;'
)
labsel_browse_button=: 3 : 0
p=. jpath '~user'
j=. '"Labs (*.ijt)|*.ijt|All Files (*.*)|*.*"'
j=. j,' ofn_filemustexist'
f=. wd 'mbopen "Open File" "',p,'" "" ',j
if. #f do.
  labselrun f
end.
)
labsel_listbox_button=: 3 : 0
if. #listbox do.
  labselrun 2 pick (".listbox_select) { LABCATSEL#LABS
end.
)
labsel_print_button=: 3 : 0
if. #listbox do.
  printfiles_j_ 2 pick (".listbox_select) { LABCATSEL#LABS
end.
)
labsel_enter=: labsel_ok_button=: labsel_listbox_button
labsel_intro_button=: labselrun bind (jpath '~system\extras\labs\labintro.txt')
labselrun=: 3 : 0
labinit y
wd :: ] 'psel labsel;pclose;'
if. IFWINCE=0 do.
  smselout_jijs_''
  smfocus_jijs_''
end.
)
labsel_cancel_button=: wd bind 'pclose'
labsel_exit_button=: labsel_cancel_button
labsel_category_button=: 3 : 0
if. LABCAT -: <category do. return. end.
LABCAT=: <category
labshowcats''
)
labsel_comments_button=: 3 : 0
IFCOMMENTS=: -. IFCOMMENTS
wd 'set comments ',":IFCOMMENTS
)
labsel_sentences_button=: 3 : 0
IFSENTENCES=: -. IFSENTENCES
wd 'set sentences ',":IFSENTENCES
)
labshowcats=: 3 : 0
if. LABCAT -: <ALL do.
  LABCATSEL=: 1 #~ #LABS
else.
  LABCATSEL=: ({."1 LABS) e. LABCAT
end.
labshowall''
)
labsel_category_select=: labsel_category_button
labshowall=: 3 : 0
if. -. (<'labsel') e. < ;. _2 wd 'qp' do. return. end.
wd 'set category *', tolist LABCATS
wd 'setselect category ',":LABCATS i. LABCAT
d=. LABCATSEL # LABS
wd 'set listbox *', tolist 1{"1 d
wd 'setselect listbox 0'
)

PTOP=: 1

LABWIN=: 0 : 0
pc labwin;
menupop "&Options";
menupop "Font";
menu largest "Larg&est" "" "" "";
menu larger "&Larger" "" "" "";
menu medium "&Medium" "" "" "";
menu smaller "&Smaller" "" "" "";
menu smallest "Sm&allest" "" "" "";
menupopz;
menusep ;
menu close "&Close Window" "" "" "";
menupopz;
xywh 4 3 11 9;cc down button;cn "&<<";
xywh 15 3 11 9;cc up button;cn "&>>";
xywh 29 4 15 9;cc index static;cn "(555)";
xywh 45 4 94 9;cc pos static rightmove;cn "555 of 555";
xywh 143 3 20 9;cc ptop checkbox leftmove rightmove;cn "&Top";
xywh 4 18 158 9;cc section static rightmove;cn "";
xywh 165 2 42 11;cc next button leftmove rightmove;cn "&Advance";
xywh 165 17 42 11;cc runline button leftmove rightmove;cn "&Run Selection";
xywh 0 29 210 100;cc text editm ws_border ws_vscroll rightmove bottommove;
pas 0 0;
rem form end;
)
labwin_init=: 3 : 0
labwin=. LABWIN
if. IFCHAPTERS do.
  j=. 'menu chapter'&, @ ": each i.#CHAPTERS
  chaps=. ;j ,each ' "'&, @ (,&'";') each CHAPTERS
  txt=. 'menupop "&Chapters";',chaps
  labwin=. labwin rplc 'xywh 0 0';txt,'xywh 0 0'
end.
wd labwin
wd 'setfont text ',WINFONT
wd 'setenable down 0'
wd 'setenable runline 0'
wd 'setcaption index'
wd 'setcaption pos'
wd 'setfocus next'
wd 'set ptop ',":PTOP
'labwin' wdmove _1 0
wd 'pshow ',":PTOP
)
labwin_open=: 3 : 0
if. -. wdifopen 'labwin' do. labwin_init'' end.
)
labwin_output=: (1&$:) : (4 : 0)
labwin_open''
wd 'psel labwin;set text *', y
wd 'pn *',WINTITLE
if. x do.
  wd 'pn *',WINTITLE
  wd 'setcaption section *',;labsection''
  wd 'setcaption pos *',labposition''
  wd 'setcaption index'
  LABWINPOS=: NDX
  wd 'setenable down ',":0<LABWINPOS
  wd 'setenable up ',":LABWINPOS<<:#SECTIONDATA
  wd 'setenable runline 1'

else.
  wd 'pn *',LABTITLE
end.
)
labwin_close_button=: 3 : 0
wd :: ] 'psel labwin;pclose'
)

labwin_cancel=: labwin_close=: labwin_close_button
labwin_chapter_button=: labjump
labwin_ptop_button=: 3 : 0
wd 'ptop ',ptop
PTOP=: ".ptop
)
labwin_runline_button=: 3 : 0
sel=. ".text_select
if. =/sel do.
  ndx=. I. LF=text=. LF,text,LF
  ind=. +/ndx <: {.sel
  bgn=. >:(ind-1){ndx
  end=. ind{ndx
else.
  'bgn end'=. sel
end.
cmd=. bgn}.end{.text
cmd=. cmd #~ +./\cmd ~: ' '
run1 cmd
)
labwin_scalefont=: 3 : 0
FONTSCALE=: 1+0.1*y
WINFONTSIZENOW=: <.0.5+FONTSCALE*WINFONTSIZE
wd 'setfont text ',WINFONTSIZENOW setfontsize WINFONT
)

labwin_largest_button=: labwin_scalefont bind 2
labwin_larger_button=: labwin_scalefont bind 1
labwin_medium_button=: labwin_scalefont bind 0
labwin_smaller_button=: labwin_scalefont bind _1
labwin_smallest_button=: labwin_scalefont bind _2
labwin_down_button=: labwin_showpos bind _1
labwin_up_button=: labwin_showpos bind 1
labwin_showpos=: 3 : 0
LABWINPOS=: 0 >. (<:#SECTIONDATA) <. LABWINPOS+y

dat=. _2 }. 0 pick labsplit LABWINPOS pick SECTIONDATA

wd 'setenable down ',":0<LABWINPOS
wd 'setenable up ',":LABWINPOS<<:#SECTIONDATA

wd 'psel labwin;set text *',dat
wd 'setcaption index *(',(":LABWINPOS+1),')'
)

labwin_default=: 3 : 0
if. 'chapter' -: 7{.syschild do.
  labopenchapter ".7}.syschild
  labrun''
end.
)
labwin_actrl_fkey=: labrun
labwin_next_button=: labrun



labreset ''

