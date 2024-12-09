%% expected:
%% hold(s(p,a),1).
%% hold(s(q,a),1).

concept((q;p;q';p'),1).
isa(t,(q;p;q';p')).
variable(x;y).
isa(t,(x;y)).
object(a).
isa(t,a).
xor(p,p';q,q').

time(1).

init(s(q,a)).

rule_static(1;2).

rule_head(1,s(p,x)).
rule_body(1,s(q,x)).

rule_head(2,s(q,y)).
rule_body(2,s(p,y)).
