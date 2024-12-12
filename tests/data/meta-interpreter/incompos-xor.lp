#include "defined.lp".
concept((p;p';f;g;h),1).
isa(t,concept(p;p';f;g;h)).
variable(x).
isa(t,variable(x)).
object(a).
isa(t,object(a)).
xor(concept(p),concept(p');concept(f),concept(g);concept(g),concept(h)).

time(1..3).

init(s(concept(p),object(a))).
init(s(concept(f),object(a))).

rule_causal(1..2).
rule_static(3).

rule_head(rule_causal(2),s(concept(h),variable(x))).
rule_body(rule_causal(2),s(concept(g),variable(x))).

rule_head(rule_causal(1),s(concept(g),variable(x))).
rule_body(rule_causal(1),s(concept(f),variable(x))).

rule_head(rule_static(3),s(concept(p'),variable(x))).
rule_body(rule_static(3),s(concept(h),variable(x))).
