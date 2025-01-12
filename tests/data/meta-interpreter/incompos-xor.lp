#include "defined.lp".
pred((p;p';f;g;h),1).
isa(type(t),pred((p;p';f;g;h),1)).
var(x).
isa(type(t),var(x)).
obj(a).
isa(type(t),obj(a)).

xor(pred(p,1),pred(p',1);
		pred(f,1),pred(g,1);
		pred(g,1),pred(h,1)).

time(1..3).

init(s(pred(p,1),obj(a))).
init(s(pred(f,1),obj(a))).

causal(1..2).
static(3).

rule_head(causal(2),s(pred(h,1),var(x))).
rule_body(causal(2),s(pred(g,1),var(x))).

rule_head(causal(1),s(pred(g,1),var(x))).
rule_body(causal(1),s(pred(f,1),var(x))).

rule_head(static(3),s(pred(p',1),var(x))).
rule_body(static(3),s(pred(h,1),var(x))).
