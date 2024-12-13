#include "defined.lp".
concept((p;p';f;g;h),1).
isa(t,concept((p;p';f;g;h),1)).
variable(x).
isa(t,variable(x)).
object(a).
isa(t,object(a)).

xor(concept(p,1),concept(p',1);
		concept(f,1),concept(g,1);
		concept(g,1),concept(h,1)).

time(1..3).

init(s(concept(p,1),object(a))).
init(s(concept(f,1),object(a))).

rule_causal(1..2).
rule_static(3).

rule_head(rule_causal(2),s(concept(h,1),variable(x))).
rule_body(rule_causal(2),s(concept(g,1),variable(x))).

rule_head(rule_causal(1),s(concept(g,1),variable(x))).
rule_body(rule_causal(1),s(concept(f,1),variable(x))).

rule_head(rule_static(3),s(concept(p',1),variable(x))).
rule_body(rule_static(3),s(concept(h,1),variable(x))).
