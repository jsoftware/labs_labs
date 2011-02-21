NB. labfiles
NB.
NB.   labdir       makes LABDIR directory
NB.   labgetfiles
NB.   labgetjt

NB. =========================================================
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

NB. =========================================================
labgetsubdir=: 3 : 0
t=. 1!:0 y,'*'
b=. 'd' = 4{ &> 4{"1 t
{."1 b # t
)

NB. =========================================================
NB. run when labs first loaded
NB. builds global LABDIR
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

NB. =========================================================
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

NB. =========================================================
NB. labgetfiles
NB. get files from directory, or LABDIR if empty
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

NB. =========================================================
NB. labgettutor
labgettutor=: labgetjt , labgetrtf

NB. =========================================================
NB. labgetjt   - get jt files in single directory
NB. returning: titles;filenames
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

NB. =========================================================
labgettitle1=: 3 : 0
t=. toJ 1!:11 y;0 100
". (t i. LF) {. t
)

NB. =========================================================
NB. labgetrtf   - get rtf files in single directory
NB. returning: titles;filenames
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

NB. =========================================================
NB. labrtftitle   - rtf title
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
