NB. y is text of a CSV file
NB. Result is list of boxes, one per line
NB.  Each box contains a list of boxes, one per field, containing a string
NB. Fields quoted with " are allowed.  Quoted fields may contain any character including LF.
NB. To put " in a quoted field, escape it by using two quotes "" .
NB. The enclosing ", and any escaping ", are removed in the result.
splitcsv =: verb define
NB.~stop splitcsv
NB.~title 3	Convert CSV File
NB.~title1 0	Remove CR & check for ending LF
NB.~link1 0	CSV format	http://en.wikipedia.org/wiki/Comma-separated_values
NB.~link2 0	if. blocks	http://www.jsoftware.com/jwiki/Vocabulary/TBlock
NB.~link3 0	Other control words	http://www.jsoftware.com/help/dictionary/ctrl.htm
NB. Remove CR characters; if file doesn't end with LF, add LF
if. LF ~: {: csvdata =. y -. CR do.
  csvdata =. csvdata , LF
end.
NB. Split file on sections ending with unquoted LF; box each section, discarding the LF
NB.~title1 0	Split into lines
NB.~link1 0	CSV format	http://en.wikipedia.org/wiki/Comma-separated_values
NB.~link2
NB.~link3
lines =. (LF unescapeddelimpos csvdata) <;._2 csvdata
NB. Process each line and return the result
NB.~title1 0	Split each line
NB.~link1 0	CSV format	http://en.wikipedia.org/wiki/Comma-separated_values
NB.~link2 0	each	http://www.jsoftware.com/jwiki/Vocabulary/ampdot
splitline each lines
)

NB. y is text, x is a delimiter string
NB. Result is a Boolean list, one per character of y, with
NB. 1 in the places where the delimiter is found, but
NB. only places that are preceded by an even number of " characters
unescapeddelimpos =: dyad define
NB.~stop delim
NB.~title 3	Convert CSV File
NB.~title1 0	Calculate parity of " characters
NB.~link1 0	shift	http://www.jsoftware.com/jwiki/Vocabulary/bardot#monadicfit
NB. Get the even-odd parity of " characters including
NB. current char; shift right 1 to make it parity of preceding
parity =. (|.!.0) 2 | +/\ '"' = y
NB. Find delimiters, ignore any that have odd parity
NB.~title1 0	Find delimiters with even parity
NB.~link0
(-. parity) *. x E. y
)

NB. y is the text of a comma-delimited line
NB. result is list of boxed fields
NB. Fields containing comma or " must be enclosed in " characters.
NB. Enclosing " characters are removed from the field value.
NB. A " character is escaped inside a string by doubling it
splitline =: verb define
NB.~stop splitline
NB.~title 3	Convert CSV File
NB.~title1 0	Split line on unquoted commas
NB.~link1 0	Intervals	http://www.jsoftware.com/jwiki/Vocabulary/semidot1#dyadic
NB. Split the line on comma delimiters, discarding them.  Add
NB. a trailing delimiter to delimit the last field
boxedfields =. ((',' unescapeddelimpos y),1) <;._2 y,' '
NB.~title1 0	Split line on unquoted commas
NB.~link0 0	each	http://www.jsoftware.com/jwiki/Vocabulary/ampdot
NB.~link1 0	Dynamic If	http://www.jsoftware.com/jwiki/Vocabulary/hatco#IfDyad
NB.~link2 0	Fork	http://www.jsoftware.com/jwiki/Vocabulary/fork
NB. If any field begins with ", delete the first and last characters
boxedfields =. }.@}:^:('"'={.) each boxedfields
NB.~title1 0	Remove escaped quotes
NB.~link0 0	each	http://www.jsoftware.com/jwiki/Vocabulary/ampdot
NB.~link1
NB.~link2
NB. Remove escaped quotes, which are positions of "" that
NB. have even parity
(-. each '""'&unescapeddelimpos each boxedfields) # each boxedfields
)

