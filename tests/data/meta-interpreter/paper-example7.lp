#include "defined.lp".
#include "assert-sensory-seq.lp".

type(sensor).
concept((on;off),1).
isa(sensor,concept(on;off)).
concept(r,2).
isa((sensor,sensor),concept(r)).

variable(x;y).
isa(sensor,variable(x;y)).
object(a;b;c).
isa(sensor,object(a;b;c)).

xor(concept(on),concept(off)).
exist(concept(r)).

time(1..10).

init(s(concept(on),object(a);
			 concept(on),object(b);
			 concept(off),object(c))).
init(s2(concept(r),object(a),object(b);
				concept(r),object(b),object(c);
				concept(r),object(c),object(a))).

rule_causal(1..2).

rule_head(rule_causal(1),s(concept(off),variable(y))).
rule_body(rule_causal(1),s(concept(off),variable(x))).
rule_body(rule_causal(1),s2(concept(r),variable(x),variable(y))).

rule_head(rule_causal(2),s(concept(on),variable(y))).
rule_body(rule_causal(2),s(concept(on),variable(x))).
rule_body(rule_causal(2),s2(concept(r),variable(x),variable(y))).
