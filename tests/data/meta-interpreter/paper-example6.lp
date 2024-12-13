#include "defined.lp".
#include "assert-sensory-seq.lp".

type(sensor).
pred((p1;p2;p3),1).
isa(sensor,pred((p1;p2;p3),1)).
pred((on;off),1).
isa(sensor,pred((on;off),1)).
pred(r,2).
isa((sensor,sensor),pred(r,2)).
var(x;y).
isa(sensor,var(x;y)).
obj(a;b).
isa(sensor,obj(a;b)).

xor(pred(p1,1),pred(p2,1);
		pred(p2,1),pred(p3,1);
		pred(on,1),pred(off,1)).
exist(pred(r,2)).

time(1..10).

init(s(pred(p1,1),obj(b);
			 pred(p2,1),obj(a))).
init(s2(pred(r,2),obj(a),obj(b);
				pred(r,2),obj(b),obj(a))).

causal(1..3).

rule_head(causal(1),s(pred(p2,1),var(x))).
rule_body(causal(1),s(pred(p1,1),var(x))).

rule_head(causal(2),s(pred(p3,1),var(x))).
rule_body(causal(2),s(pred(p2,1),var(x))).

rule_head(causal(3),s(pred(p1,1),var(x))).
rule_body(causal(3),s(pred(p3,1),var(x))).


static(4..6).

rule_head(static(4),s(pred(on,1),var(x))).
rule_body(static(4),s(pred(p1,1),var(x))).

rule_head(static(5),s(pred(on,1),var(x))).
rule_body(static(5),s(pred(p2,1),var(x))).

rule_head(static(6),s(pred(off,1),var(x))).
rule_body(static(6),s(pred(p3,1),var(x))).
