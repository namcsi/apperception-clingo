%% expected: don't derive atoms in loop, i.e.
%% UNSAT
#include "defined.lp".
pred((p;q;p';q'),1).
isa(type(t),(p;q;p';q')).
var(x;y).
isa(type(t),(x;y)).
obj(a).
isa(type(t),a).
xor(p,p';q,q';r,r').

init(s(pred(r,1),obj(a))).

static(1;2).

rule_head(1,s(p,x)).
rule_body(1,s(q,x)).

rule_head(2,s(q,y)).
rule_body(2,s(p,y)).

time(1).
