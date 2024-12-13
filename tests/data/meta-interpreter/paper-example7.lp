#include "defined.lp".
#include "assert-sensory-seq.lp".

type(sensor).
concept((on;off),1).
isa(sensor,concept((on;off),1)).
concept(r,2).
isa((sensor,sensor),concept(r,2)).

variable(x;y).
isa(sensor,variable(x;y)).
object(a;b;c).
isa(sensor,object(a;b;c)).

xor(concept(on,1),concept(off,1)).
exist(concept(r,2)).

time(1..10).

init(s(concept(on,1),object(a);
			 concept(on,1),object(b);
			 concept(off,1),object(c))).
init(s2(concept(r,2),object(a),object(b);
				concept(r,2),object(b),object(c);
				concept(r,2),object(c),object(a))).

rule_causal(1..2).

rule_head(rule_causal(1),s(concept(off,1),variable(y))).
rule_body(rule_causal(1),s(concept(off,1),variable(x))).
rule_body(rule_causal(1),s2(concept(r,2),variable(x),variable(y))).

rule_head(rule_causal(2),s(concept(on,1),variable(y))).
rule_body(rule_causal(2),s(concept(on,1),variable(x))).
rule_body(rule_causal(2),s2(concept(r,2),variable(x),variable(y))).
