NB. build

3 : 0''
T=. jpath '~addons/labs/labs/'
S=. jpath '~Addons/labs/labs/'


mkdir_j_ each T&, each cutopen 'core general graphics livetexts math personal system'

f=. {."1 dirtree S
t=. T&, each (#S) }.each f
empty t fcopynew each f
)

