%% expected:
%% hold(s(p,a),1).
%% hold(s(p,a),3).
%% hold(s(p',a),2).
#include "defined.lp".
concept((p;p'),1).
isa(t,concept(p;p')).
variable(x).
isa(t,variable(x)).
object(a).
isa(t,object(a)).
xor(concept(p),concept(p')).

time(1..3).

init(s(concept(p),object(a))).

rule_causal(1;2).

rule_head(rule_causal(1),s(concept(p),variable(x))).
rule_body(rule_causal(1),s(concept(p'),variable(x))).

rule_head(rule_causal(2),s(concept(p'),variable(x))).
rule_body(rule_causal(2),s(concept(p),variable(x))).
