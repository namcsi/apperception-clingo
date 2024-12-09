

concept((p;p';f;g;h),1).
isa(t,(p;p';f;g;h)).
variable(x).
isa(t,(x)).
object(a).
isa(t,a).
xor(p,p';f,g;g,h).

time(1..3).

init(s(p,a)).

rule_causal(1..2).
rule_static(3).

rule_head(1,s(g,x)).
rule_body(1,s(f,x)).

rule_head(2,s(h,x)).
rule_body(2,s(g,x)).

rule_head(3,s(p',x)).
rule_body(3,s(h,x)).
