NB. build

T=. jpath '~addons/labs/labs/'
S=. jpath '~Addons/labs/labs/'
mkdir_j_ each T&, each cutopen 'core general graphics livetexts math system'
f=. {."1 dirtree S
t=. T&, each (#S) }.each f
empty t fcopynew each f

writesourcex_jp_ '~Addons/labs/labs/run';'~Addons/labs/labs/lab.ijs'
writesourcex_jp_ '~Addons/labs/labs/run';'~addons/labs/labs/lab.ijs'
