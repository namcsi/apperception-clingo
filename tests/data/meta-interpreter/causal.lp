%% expected:
%% hold(s(p,a),1).
%% hold(s(p,a),3).
%% hold(s(p',a),2).

concept((p;p'),1).
isa(t,(p;p')).
variable(x).
isa(t,(x)).
object(a).
isa(t,a).
xor(p,p').

time(1..3).

init(s(p,a)).

rule_causal(1;2).

rule_head(1,s(p,x)).
rule_body(1,s(p',x)).

rule_head(2,s(p',x)).
rule_body(2,s(p,x)).
