%% expected: don't derive atoms in loop, i.e.
%% UNSAT
#include "defined.lp".
pred((p;q;p';q'),1).
isa(t,(p;q;p';q')).
var(x;y).
isa(t,(x;y)).
obj(a).
isa(t,a).
xor(p,p';q,q').

static(1;2).

rule_head(1,s(p,x)).
rule_body(1,s(q,x)).

rule_head(2,s(q,y)).
rule_body(2,s(p,y)).

time(1).
