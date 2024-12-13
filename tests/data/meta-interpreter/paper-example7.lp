#include "defined.lp".
#include "assert-sensory-seq.lp".

type(sensor).
pred((on;off),1).
isa(sensor,pred((on;off),1)).
pred(r,2).
isa((sensor,sensor),pred(r,2)).

var(x;y).
isa(sensor,var(x;y)).
obj(a;b;c).
isa(sensor,obj(a;b;c)).

xor(pred(on,1),pred(off,1)).
exist(pred(r,2)).

time(1..10).

init(s(pred(on,1),obj(a);
			 pred(on,1),obj(b);
			 pred(off,1),obj(c))).
init(s2(pred(r,2),obj(a),obj(b);
				pred(r,2),obj(b),obj(c);
				pred(r,2),obj(c),obj(a))).

causal(1..2).

rule_head(causal(1),s(pred(off,1),var(y))).
rule_body(causal(1),s(pred(off,1),var(x))).
rule_body(causal(1),s2(pred(r,2),var(x),var(y))).

rule_head(causal(2),s(pred(on,1),var(y))).
rule_body(causal(2),s(pred(on,1),var(x))).
rule_body(causal(2),s2(pred(r,2),var(x),var(y))).
