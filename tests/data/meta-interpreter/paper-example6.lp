#include "defined.lp".
#include "assert-sensory-seq.lp".

type(sensor).
concept((p1;p2;p3),1).
isa(sensor,(p1;p2;p3)).
concept((on;off),1).
isa(sensor,(on;off)).
concept(r,2).
isa((sensor,sensor),r).

variable(x;y).
isa(sensor,(x;y)).
object(a;b).
isa(sensor,(a;b)).

xor(p1,p2;p2,p3;on,off).
exist(r).

time(1..10).

init(s(p1,b;p2,a)).
init(s2(r,a,b;r,b,a)).

rule_causal(1..3).

rule_head(1,s(p2,x)).
rule_body(1,s(p1,x)).

rule_head(2,s(p3,x)).
rule_body(2,s(p2,x)).

rule_head(3,s(p1,x)).
rule_body(3,s(p3,x)).


rule_static(4..6).

rule_head(4,s(on,x)).
rule_body(4,s(p1,x)).

rule_head(5,s(on,x)).
rule_body(5,s(p2,x)).

rule_head(6,s(off,x)).
rule_body(6,s(p3,x)).
