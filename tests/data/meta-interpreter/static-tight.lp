% expected:
%% hold(s(p,a),1).
%% hold(s(q,a),1).
%% hold(s(r,a),1).
#include "defined.lp".
concept((p;q;r;p';q';r'),1).
isa(t,(p;q;r;p';q';r')).
variable(x).
isa(t,x).
xor(r,r';p,p';q,q').

object(a).
isa(t,a).

init(s(p,a;q,a)).

rule_static(1).

rule_head(1,s(r,x)).
rule_body(1,s(p,x)).
rule_body(1,s(q,x)).

time(1).
