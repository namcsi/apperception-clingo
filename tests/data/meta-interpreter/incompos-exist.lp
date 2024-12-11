#include "defined.lp".
type(t;u).
concept((f;g;h),1).
concept((r;q),2).
variable(x;y;z).
object(a;b;c).

isa(t,(x;a)).
isa(u,(f;g;h;b;c;y;z)).
isa((t,u),r).
isa((u,u),q).

xor(f,g;g,h).
exist(r;q).

time(1..4).

init(s2(r,a,b)).
init(s2(q,b,c)).
init(s2(q,c,b)).
init(s(h,b)).
init(s(g,c)).

rule_causal(1..3).

rule_head(1,s(f,y)).
rule_body(1,s(g,y)).

rule_head(2,s(g,y)).
rule_body(2,s(h,y)).

rule_head(3,s(h,y)).
rule_body(3,s(f,y)).

rule_causal(4).
rule_head(4,s2(r,x,z)).
rule_body(4,s(f,z)).
rule_body(4,s2(r,x,y)).
