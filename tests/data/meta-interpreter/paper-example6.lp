#include "defined.lp".
#include "assert-sensory-seq.lp".

type(sensor).
concept((p1;p2;p3),1).
isa(sensor,concept((p1;p2;p3),1)).
concept((on;off),1).
isa(sensor,concept((on;off),1)).
concept(r,2).
isa((sensor,sensor),concept(r,2)).
variable(x;y).
isa(sensor,variable(x;y)).
object(a;b).
isa(sensor,object(a;b)).

xor(concept(p1,1),concept(p2,1);
		concept(p2,1),concept(p3,1);
		concept(on,1),concept(off,1)).
exist(concept(r,2)).

time(1..10).

init(s(concept(p1,1),object(b);
			 concept(p2,1),object(a))).
init(s2(concept(r,2),object(a),object(b);
				concept(r,2),object(b),object(a))).

rule_causal(1..3).

rule_head(rule_causal(1),s(concept(p2,1),variable(x))).
rule_body(rule_causal(1),s(concept(p1,1),variable(x))).

rule_head(rule_causal(2),s(concept(p3,1),variable(x))).
rule_body(rule_causal(2),s(concept(p2,1),variable(x))).

rule_head(rule_causal(3),s(concept(p1,1),variable(x))).
rule_body(rule_causal(3),s(concept(p3,1),variable(x))).


rule_static(4..6).

rule_head(rule_static(4),s(concept(on,1),variable(x))).
rule_body(rule_static(4),s(concept(p1,1),variable(x))).

rule_head(rule_static(5),s(concept(on,1),variable(x))).
rule_body(rule_static(5),s(concept(p2,1),variable(x))).

rule_head(rule_static(6),s(concept(off,1),variable(x))).
rule_body(rule_static(6),s(concept(p3,1),variable(x))).
