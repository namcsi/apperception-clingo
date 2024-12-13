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
isa(u,concept((f;g;h),1)).

isa((t,u),concept(r,2)).
isa((u,u),concept(q,2)).

xor(concept(f,1),concept(g,1);concept(g,1),concept(h,1)).
exist(concept(r,2);concept(q,2)).

time(1..4).

init(s2(concept(r,2),object(a),object(b))).
init(s2(concept(q,2),object(b),object(c))).
init(s2(concept(q,2),object(c),object(b))).
init(s(concept(h,1),object(b))).
init(s(concept(g,1),object(c))).

rule_causal(1..4).

rule_head(rule_causal(1),s(concept(f,1),variable(y))).
rule_body(rule_causal(1),s(concept(g,1),variable(y))).

rule_head(rule_causal(2),s(concept(g,1),variable(y))).
rule_body(rule_causal(2),s(concept(h,1),variable(y))).

rule_head(rule_causal(3),s(concept(h,1),variable(y))).
rule_body(rule_causal(3),s(concept(f,1),variable(y))).

rule_head(rule_causal(4),s2(concept(r,2),variable(x),variable(z))).
rule_body(rule_causal(4),s(concept(f,1),variable(z))).
rule_body(rule_causal(4),s2(concept(r,2),variable(x),variable(y))).
