#include "defined.lp".
#include "assert-sensory-seq.lp".

type(sensor).
concept((on;off),1).
isa(sensor,(on;off)).
concept(r,2).
isa((sensor,sensor),r).

variable(x;y).
isa(sensor,(x;y)).
object(a;b;c).
isa(sensor,(a;b;c)).

xor(on,off).
exist(r).

time(1..10).

init(s(on,a;on,b;off,c)).
init(s2(r,a,b;r,b,c;r,c,a)).

rule_causal(1..2).

rule_head(1,s(off,y)).
rule_body(1,s(off,x)).
rule_body(1,s2(r,x,y)).

rule_head(2,s(on,y)).
rule_body(2,s(on,x)).
rule_body(2,s2(r,x,y)).
