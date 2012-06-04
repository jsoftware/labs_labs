NB. labini.ijs    - initialize lab system
NB.
NB. main verbs:
NB.   lab          run lab (=runlab)
NB.   labinit      initialize globals for current lab
NB.   labjump      lab jump
NB.   labopen      open lab file
NB.   labreset     reset lab system
NB.   labrun       run lab section
NB.   labselect    run selection dialog
NB.
NB. other:
NB.   labline      lab line header
NB.   labposition  current position
NB.   labrun0      run bit 0 of code
NB.   labrunnext   run next bit of code
NB.   labsplit     split data into text and code
NB.   labsplitcode split code into sections
NB.   labsection     current section
NB.
NB.   ALL          all category
NB.   CMARKER      marks lab chapters
NB.   SMARKER      marks lab sections

ADVANCE=: 'To advance the lab, press Esc A in JHS or Ctrl-J in Gtk.'

ALL=: '(All)'
LABDIRECTORY=: jpath '~system\extras\labs\'
ADDONSDIRECTORY=: }: jpath '~addons\a'
CMARKER=: 'Lab Chapter'
RXCMARKER=: '\\par [\\[:alnum:]* ]*',CMARKER
SMARKER=: 'Lab Section'
RXSMARKER=: '\\par [\\[:alnum:]* ]*',SMARKER
RXPAREN=: '\\par [\\[:alnum:]* ]*)'

IFCOMMENTS=: 1        NB. show comments
IFSENTENCES=: 1       NB. show sentences
LABFOCUS=: _1         NB. return focus to session (0 if not given)
IFWINDOWS=: 1         NB. show windows (if specified)

LABS=: ''
LABCAT=: ''
LABCATS=: ''
LABCATSEL=: 0
LABCTD=: ' (ctd)'
NB. LABFILE=: ''
NB. LABPATH=: jpath '~system\extras\labs\'
FONTSCALE=: 1

AUTOLAB=: 0

NB. =========================================================
labreset=: 3 : 0
LABAUTHOR=: ''
LABCOMMENTS=: ''
LABERRORS=: 0
LABTITLE=: ''
LABWINPOS=: _1
LABOUTPUT=: 1
LABWIDTH=: 61
LABFILE=: ''

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
)

NB. =========================================================
output=: [: empty 1!:2 & 2
outputwin=: labwin_output

NB. =========================================================
start=: 3 : 0
if. #LABS do. y labinit 1 pick LABNDX{LABS end.
empty''
)

NB. =========================================================
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

NB. =========================================================
labnext=: 3 : 0
if. #LABFILE do.
  lab 0
end.
)

NB. =========================================================
NB. labchapterline
labchapterline=: 3 : 0
if. IFCHAPTERS do.
  j=. ' Chapter ',(":1+CHAPTERNDX),' ',(CHAPTERNDX pick CHAPTERS),' '
  output LF,(2$LINE),j,(0>.LABWIDTH-2+#j)$LINE
end.
)

NB. =========================================================
labchaptername=: 3 : 0
if. 1 < #CHAPTERS do.
  (":CHAPTERNDX+1),' ',(CHAPTERNDX pick CHAPTERS),' '
else. '' end.
)

NB. =========================================================
NB. [section] labinit filename
NB.
NB. initialize lab for given file
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

NB. =========================================================
NB. labjump      - jump to chapter in lab
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

NB. =========================================================
labline=: 3 : 0
j=. ' ',labsectionname''
(2$LINE),j,' ',(0>.LABWIDTH-3+#j)$LINE
)

NB. =========================================================
NB. labopen filename
NB.
NB. open lab file, return success
labopen=: 3 : 0
labreset''
try. dat=. 1!:1 boxopen y
catch.
  info 'not found: ',":>y
  0 return.
end.

NB. if not given, set to 0:
LABFOCUS=: 0 >. LABFOCUS

'LABPATH LABFILE'=: pathname >y

IFCHAPTERS=: 1 e. CMARKER E. dat

NB. ---------------------------------------------------------

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

NB. =========================================================
NB. labopenchapter
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

NB. =========================================================
labposition=: 3 : 0
j=. (":NDX+1),' of ',":#SECTIONDATA
if. IFCHAPTERS do.
NB.  'Ch ',(":CHAPTERNDX+1),'. ',j
  '(',(":CHAPTERNDX+1),') ',j
end.
)

NB. =========================================================
NB. labrun''  - run section in lab, default NDX
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

NB. =========================================================
NB. run first time in section
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

NB. =========================================================
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

NB. advance indices before running code:

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

NB. =========================================================
labsetfocus=: 3 : 0
if. LABFOCUS do.
  smselout_jijs_''
  smfocus_jijs_''
end.
)

NB. =========================================================
labadvance=: 3 : 0
NDX=: >:NDX
CODE=: ''
CODENDX=: 0
)

NB. =========================================================
labsectionname=: 3 : 0
j=. '(',(labposition''),') ',;labsection''
)

NB. =========================================================
NB. labselect directory
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

NB. =========================================================
labwelcome=: 3 : 0
r=. LF,'Welcome to lab: ',LABTITLE
if. 0<#LABAUTHOR do.
  r=. r,LF,LF,'Author: ',LABAUTHOR
end.
r=. r,LF,LF,ADVANCE
)

NB. =========================================================
labsection=: 3 : 0
r=. ({.SECTIONS),a:
if. 0 < NDX do.
  j=. (<:+/NDX >: SECTIONINDEX) pick SECTIONS
  k=. (-.NDX e. SECTIONINDEX)#LABCTD
  if. #j do. r=. j;k end.
end.
r
)

NB. =========================================================
NB. labsplit data
labsplit=: 3 : 0
ind=. 2+((LF,')') E. y) i. 1
}. each ind ({.;}.) y
)

NB. =========================================================
NB. labsplitcode data
labsplitcode=: 3 : 0
f=. 'SOUND'&-: @ (5&{.) &>
dat=. <;.2 termLF y
dat=. ;dat #~ -. f dat
,<dat;''
)
