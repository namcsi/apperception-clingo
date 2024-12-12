#include "defined.lp".
type(t;u).
concept((f;g;h),1).
concept((r;q),2).
variable(x;y;z).
object(a;b;c).

isa(t,object(a)).
isa(u,object(b;c)).
isa(t,variable(x)).
isa(u,variable(y;z)).
isa(u,concept(f;g;h)).

isa((t,u),concept(r)).
isa((u,u),concept(q)).

xor(concept(f),concept(g);concept(g),concept(h)).
exist(concept(r);concept(q)).

time(1..4).

init(s2(concept(r),object(a),object(b))).
init(s2(concept(q),object(b),object(c))).
init(s2(concept(q),object(c),object(b))).
init(s(concept(h),object(b))).
init(s(concept(g),object(c))).

rule_causal(1..4).

rule_head(rule_causal(1),s(concept(f),variable(y))).
rule_body(rule_causal(1),s(concept(g),variable(y))).

rule_head(rule_causal(2),s(concept(g),variable(y))).
rule_body(rule_causal(2),s(concept(h),variable(y))).

rule_head(rule_causal(3),s(concept(h),variable(y))).
rule_body(rule_causal(3),s(concept(f),variable(y))).

rule_head(rule_causal(4),s2(concept(r),variable(x),variable(z))).
rule_body(rule_causal(4),s(concept(f),variable(z))).
rule_body(rule_causal(4),s2(concept(r),variable(x),variable(y))).
