load 'debug/dissect'
load 'debug'
require 'regex'

NB. Markup language for scripts
NB.
NB. Scripts are normal J scripts, but with )) rather than ) to end definitions
NB.  (so the script can fit in a lab inside 0: 0)
NB.
NB. Action lines begin with NB.~ and have brittle fixed format:
NB. NB.~actionnameSPvalue
NB. actionname is one of: stop auto datasize check title link titlen linkn
NB.    where n is a digit 0-9
NB.  stop - set debug stop.  Value is a class which can be used
NB.    in subsequent debugchangestops to enable/disable stop
NB.  auto - autodissect this line if stepped to.  Value is 0 or 1 (default 1)
NB.  datasize - max size of noun value, in percent of screen, vert then horiz.  example: datasize 20 30
NB.  check - dissect checking level, all (default), shape, error, no
NB.  title - title to use when the debugger dissects this line.
NB.   value is font size adjustmentTABtitle
NB.     example: NB.~title 3	Fine the mean
NB.  link - link to add to links table in the dissect display when the debugger dissects this line.
NB.   value is font size adjustmentTABdisplayed textTABurl
NB.     ex: NB.~link 0	search	http://www.google.com
NB.
NB. Each action applies to lines that follow it.
NB. An action stays in effect until overridden by another action of the same name.
NB. An action with an empty value terminates a previous action but does not start a new one.
NB.
NB. Actions are applied to each line in the order in which they appear in the file.
NB.
NB. titlen and linkn actions, e. g. title0, link5, are like title and link.
NB. They allow for multiple titles/links to be active.
NB.
NB. An action is active only in the definition and valence in which it appeared.

NB. Routines that a lab can use:
NB. opendebscript - apply markup and load script, stops, etc.
NB.   y is the script with markup
NB. debugstep'' - run stepover in the debugger
NB. debugstop'' - clear the debugger
NB. debugchangestops - enable/disable stops.  y is the class(es) from stop markup commands,
NB.   either a string or a (list of) boxed strings
NB.   x is 0 to clear stops, 1 to set stops, 2 to toggle stops

NB. Process script y into an edit tab
NB. y is a script, in markup form (dissect/debug lines start with NB.~
NB. and the definitions end with ))
NB. (the script was inlined in the lab, so )) is needed)
NB. No result.
NB. Side effects: the action table, containing stop and dissect info,
NB. is loaded into the debugger; the text is put into an edit tab.
opendebscript =: 3 : 0
NB. process the markup, returning actions and displayable script
if. '' -: $ 'acttbl text' =. prepscript y do.
  smoutput 'error processing script - ' , acttbl {:: '';'no ) found'
else.
  NB. Start/restart the debugger before text is loaded
  if. 0 > 4!:0 <'STOPS_jdebug_' do. jdb_open_jdebug_'' end.
  jdb_clear_jdebug_''
  jdb_open_jdebug_ ''
  NB. Load the script into the edit window
  _1 1 loadedittab text
  NB. Load the actions into the debugger - after verbs are loaded.
  jdb_extstops_jdebug_ acttbl
end.
0 0$0
)

NB. single-step the debugger, by emulating the stepover button.
NB. NOP if debugger inactive
debugstep =: 3 : 0
if. -. jdb_inactive_jdebug_'' do.
  jdebug_stepover_button_jdebug_''
end.
0 0$0
)

NB. Run to next stop if any.  NOP if debugger inactive
debugrun =: 3 : 0
if. -. jdb_inactive_jdebug_'' do.
  jdebug_run_button_jdebug_''
end.
0 0$0
)

NB. Clear debugger
debugstop =: 3 : 0
jdb_clear_jdebug_''
)

NB. Run, then clear
debugrunstop =: debugstop@debugrun

NB. x is 0 to clear, 1, to set, 2 to toggle stops
NB. y is class(es) to change
debugchangestops =: 4 : 0
assert. x e. 0 1 2
classes =. boxopen y
if. #stopmods =. (<x) (<a:;0)} (#~ classes e.~ {."1) labdebugstops do.
  jdb_extstops_jdebug_ <stopmods
end.
0 0$0
)

NB. Put a script into an edit window
NB. y is the text of the script
NB. x is (tab number);(run);filename
NB.  if tab number is _1, a new tab is created (default _1)
NB.  if run is 1, the script is loaded after it is set
NB.  if filename is not empty, that name is applied to the tab
NB. Result is (tab number that was created);tablabel
loadedittab =: 4 : 0
'tab run fn' =. (,   (_1;1;'') }.~ #) <"0^:(0=L.) x
open '~addons/labs/labs/core/emptyfile.ijs'
wd 'sm set edit text ',DEL,y
if. run do.
  NB. Make sure comments are preserved for debugger
  comments =. 9!:40''
  9!:41 (1)
  0!:100 y
  9!:41 comments
end. NB. needed till load command provided
0
)

NB. Prepare a script for analysis
NB. y is text (a verb or a script)
NB. NB.~ comments indicate debug/dissect controls
NB. Result is (control info for debug);(text of the script) or scalar retcode if error
NB. We keep the global name 'labdebugstops' which is the stop
NB. class followed by the stop data (action;name;locale;valence;lines) for each stop
prepscript =: 3 : 0
NB. Convert script to table of prefix;start;locale;body
pslb =. splitscript y
NB. pick off trailer
trailer =. (<_1 0) { pslb
if. 0 = #pslb =. }: pslb do. 1 return. end. NB. no definitions
NB. Get the <verbname;locale for each definition
nameloc =. getexpnameloc 1 2 {"1 pslb
NB. For each definition, see if it's dyadic
dyaddef =. _1 ~: (<0 0)&{::@(exppattd&rxmatch)@> 1 {"1 pslb

NB. Convert each valence to stopinfo;debug info;text (LF form)
NB.  where debug info is table of (action;lines)
bodies =. extractstops&.> 3 {"1 pslb
NB. Get the table of class;line for each valence in each definition;
NB. append valence to give class;line;valence.  Run together
NB. to produce single table of class;line;valence
if. # stops =. dyaddef (  ( ;@(] (,. <)&.> (>. i.@#)) 0&{"1 )  )&.> bodies do.
  NB. Put into stops to make name;locale;class;line;valence.  Then add action (action is always 1, =add)
  NB. Run into single table of name;locale;class;line;valence
  stops =. ; nameloc ,"1&.> stops
  NB. Reorder to saved order: class;name;locale;valence;line
  labdebugstops =: 2 0 1 4 3 {"1 stops
  NB. Create return value, which is 1;name;locale;valence;lines
  NB. for each line with a stop
  NB. Coalesce lines with same stop
  stops =. (<1) ,. (1 2 3&{"1 (~.@[ ,. <@;/.) 4&{"1) labdebugstops
  NB. Remove lines with no stops
  stops =. (#~  a: ~: 4&{"1) stops
else. stops =. 0 4$a:
end.

NB. Get the text for each definition (the valences run together)
texts =. (2&}.)@;@:(((':',LF)&,)&.>)@:(2&{"1)&.> bodies
NB. Get the action table for each valence in each definition;
NB. append valence to give action;lines;valence.  Run together
NB. to produce single table of action;lines;valence

acttbls =. dyaddef  ;@([   (] (,. <)&.> (>. i.@#)) 1&{"1@])&.> bodies
NB. Put into acttbls to make action;lines;valence;name;locale
acttbls =. acttbls ,"1&.> nameloc
NB. Run the tables together & reorder into action;name;loc;valence;lines
acttbls =.  0 3 4 2 1 {"1 ; acttbls

NB. Assemble all the text: prefix,start,text
text =. ; (, (2 {."1 pslb) ,. texts ,. <')',LF) , trailer
NB. Format the info to pass to debug, followed by the text
(stops;1;<acttbls) ; text
)

NB. y is startingline;locale (singly boxed)
NB. Result is <verbname;locale
getexpnameloc =: 3 : 0"1
'start loc' =. y
< (' ' -.~ '=' taketo start);loc
)

NB. y is text of a single valence (as boxed lines)
NB. Result is  stoplines;debug info;text (LF form)
NB.  where debug info is table of (action;lines)
NB.  stoplines is a table of (stopclass;line)
extractstops =: 3 : 0@>
NB. Set defaults in case of missing elements
stops =. 0 2$a:
acttbl =. 0 2$a:
text =. y
NB. Convert each line to action;value (for exec/comment, empty)
if. #actval =. (($0)&;)`(' ' (taketo ; takeafter) 4&}.@}:)@.('NB.~'-:4&{.)@> y do. NB. discard LF from action lines
  NB. Audit actions (auto, stop, datasize, check, title[n], link[n])
  okact =. a:,(;: 'stop auto datasize check') , (;:'title link') ([ , [: , ,&.>/) '0123456789'
  if. # invact =. ({."1 actval) -. okact do.
    ('invalid actions: ' , ;:^:_1 invact) 13!:8 (1)
  end.
  NB. Group by sections ending with exec/comment (discard anything after the last)
  actvalbyexeline =. (a: = {."1 actval) <;.2 actval
  NB. Roll the actions through the lines.  For each line, keep only the most recent
  NB. of each type of action.
  actvalbyexeline =. ({:@[ ,~ (#~ ~:&.|.@:({."1))@(,~)&}:)&.>/\.&.|. actvalbyexeline
  NB. Put numbers into executable lines, and delete all actions on comment lines
  actvalbyexeline =. (i.#actvalbyexeline) (<@[ (<_1 0)} ])`(_1&{.@])@.('NB.' -: 3 {. (0&{::)@;:@(_1 1&{::)@])&.> actvalbyexeline
  NB. Take only actions, and append line #
  actvalline =. ; (}: ,. (<_1 0)&{)&.> actvalbyexeline
  NB. Delete actions with empty body
  if. #actvalline =. (#~  *@#@>@(1&{"1)) actvalline do.
    NB. Remove numeric suffixes from actions
    actvalline =. (-.&'0123456789'&.> 0 {"1 actvalline) (<a:;0)} actvalline
    NB. Coalesce line numbers for identical action+body
    actvalline =. (((<0;0 1)&{ , <@;@:(2&{"1))/.~   0 1&{"1) actvalline

    NB. Collect all line numbers for the stop action and remove stop actions from the table
    stops =. 1 2&{"1 (#~  (<'stop') = 0&{"1) actvalline
    actvalline =. (#~  (<'stop') ~: 0&{"1) actvalline
    NB. Grouping by line numbers, convert from action;body;linenums to (action;body);linenums
    acttbl =. ((<@:(0 1&{"1) , (<0 2)&{)/.~  2&{"1) actvalline
  end.

  NB. Collect all exec/comments, roll them into text
  text =. ; (<_1 1)&{@> actvalbyexeline
end.

NB. Return the stoplist, action table, and the executable lines in LF form
stops;acttbl;text
)


NB.*exppatt n pattern to match the start of an explicit definition
NB.-descrip: regex pattern to detect start-of-explicit-definition
NB.-note: modify if you have novel ways of starting an explicit definition
exppattn=: rxcomp '(?:^\s*|[^a-zA-Z0-9_])(?:(?:0|noun)\s+define(?:\s|$)|(?:noun|0)\s+:\s*0|Note(?![a-zA-Z0-9_])\s*(?!\s)(?!=[:.]))'
exppatt=: rxcomp '(?:^\s*|[^a-zA-Z0-9_])(?:0|1|2|3|4|13|noun|verb|adverb|conjunction|monad|dyad)\s+(?:define(?:\s|$)|:\s*0)'
exppattd=: rxcomp '(?:^\s*|[^a-zA-Z0-9_])(?:4|dyad)\s+(?:define(?:\s|$)|:\s*0)'


NB. Split a script into verbs
NB. y is the text
NB. Result is a table, with one line per explicit definition, as follows:
NB. prefix;starting line;locale;body
NB.  prefix is text preceding the starting line (LF form)
NB.  starting line is the first line of the definition (LF form)
NB.  locale is the (singly boxed) locale of the definition
NB.  body is a list of boxed text (one box per defined valence)
NB. The last row of the result is the lines after the last ),
NB.  with an empty starting-line and body
splitscript =: 3 : 0
NB. Cut into lines, leaving the LF
lines =. <;.2 LF ,~^:(~: {:) y -. CR
NB. Append empty line for suffix.  This line will be marked
NB. as a start and an end
lines =. lines , <''
NB. Find the starts of explicit definitions, using exppatt.
NB. Discard comment if any, and throw out quoted strings (because the assignment of Note contains quoted 00 : 0)
NB. Change exppatt to accommodate other patterns
NB. First find start of nouns
nstartmsk =. _1 ~: (<0 0)&{::@(exppattn&rxmatch)@> explines=. (#~   '''' ~: {.@>)@:(}:^:('NB.' -: 3 {. >@{:))&.;: :: (''"_)&.> lines
NB. Then everything else, and make sure nouns are included
estartmsk =. 1 (_1)} nstartmsk +. _1 ~: (<0 0)&{::@(exppatt&rxmatch)@> explines
NB. Find end-of-definition lines
endmsk =. 1 (_1)} (')' = {.@>@{.@;:)@> lines
NB. For each end, split the definition into prefix;start;body.  Remove )) from body
psb =. endmsk ({.@I.@:>@:({."1) (;@{. ; { (,<) }:@}.@}.) {:"1);.2 estartmsk ;"0 lines
NB. Check each body for multiple valences
(}:"1 psb) ,"1 (coname'') ,. <;._2@:(,&(<':',LF))&.> {:"1 psb 
)

testtext =: 0 : 0
NB. Find largest prime divisor
largediv =: 3 : 0
NB.~title1 3	Find Largest Divisor
NB.~auto 0
num =. y
NB. Find divisors
NB.~stop largediv
NB.~auto 1
NB.~title2 0	Find Divisors
NB.~link1 0	q:	http://Vocabulary/qco
divisors =. q: num
NB.~title2 0	Take Largest
NB.~link2 0	Tail	http://Vocabulary/curlylfco
NB. Get the largest
largest =. {: divisors
))

NB. Read file y and see if x is inside it
checkfile =: 4 : 0
fname =. y
NB.~stop checkfile
NB.~link 0	File Foreigns	http://www.jsoftware.com/jwiki/Vocabulary/Foreigns#m1
NB.~title0 3	Check In File
fd =. 1!:1 <y
x +./@:E. fd
))

NB. See if string y contains the same letter repeated at least x times.
NB. x defaults to 2
repeatedletter =: 3 : 0
NB.~title 3	Bivalent Verb
2 repeatedletter y
:
NB.~stop repeat
NB.~title 3	Check for repeated letter
+./ x (-: 1&|.)\ y
))


NB. trailer


)