%% expected:
%% hold(s(p,a),1).
%% hold(s(p,a),3).
%% hold(s(p',a),2).
#include "defined.lp".
pred((p;p'),1).
isa(t,pred((p;p'),1)).
var(x).
isa(t,var(x)).
obj(a).
isa(t,obj(a)).
xor(pred(p,1),pred(p',1)).

time(1..3).

init(s(pred(p,1),obj(a))).

causal(1;2).

rule_head(causal(1),s(pred(p,1),var(x))).
rule_body(causal(1),s(pred(p',1),var(x))).

rule_head(causal(2),s(pred(p',1),var(x))).
rule_body(causal(2),s(pred(p,1),var(x))).
