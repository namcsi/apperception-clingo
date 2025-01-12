#include "defined.lp".
type(t;u).
pred((f;g;h),1).
pred((r;q),2).
var(x;y;z).
obj(a;b;c).

isa(type(t),obj(a)).
isa(type(u),obj(b;c)).
isa(type(t),var(x)).
isa(type(u),var(y;z)).
isa(type(u),pred((f;g;h),1)).

isa((type(t),type(u)),pred(r,2)).
isa((type(u),type(u)),pred(q,2)).

xor(pred(f,1),pred(g,1);pred(g,1),pred(h,1)).
exist(pred(r,2);pred(q,2)).

time(1..4).

init(s2(pred(r,2),obj(a),obj(b))).
init(s2(pred(q,2),obj(b),obj(c))).
init(s2(pred(q,2),obj(c),obj(b))).
init(s(pred(h,1),obj(b))).
init(s(pred(g,1),obj(c))).

causal(1..4).

rule_head(causal(1),s(pred(f,1),var(y))).
rule_body(causal(1),s(pred(g,1),var(y))).

rule_head(causal(2),s(pred(g,1),var(y))).
rule_body(causal(2),s(pred(h,1),var(y))).

rule_head(causal(3),s(pred(h,1),var(y))).
rule_body(causal(3),s(pred(f,1),var(y))).

rule_head(causal(4),s2(pred(r,2),var(x),var(z))).
rule_body(causal(4),s(pred(f,1),var(z))).
rule_body(causal(4),s2(pred(r,2),var(x),var(y))).
