#include "defined.lp".
#include "assert-sensory-seq.lp".

type(sensor).
concept((p1;p2;p3),1).
isa(sensor,(concept(p1;p2;p3))).
concept((on;off),1).
isa(sensor,(concept(on;off))).
concept(r,2).
isa((sensor,sensor),concept(r)).

variable(x;y).
isa(sensor,variable(x;y)).
object(a;b).
isa(sensor,object(a;b)).

xor(concept(p1),concept(p2);concept(p2),concept(p3);concept(on),concept(off)).
exist(concept(r)).

time(1..10).

init(s(concept(p1),object(b);concept(p2),object(a))).
init(s2(concept(r),object(a),object(b);concept(r),object(b),object(a))).

rule_causal(1..3).

rule_head(rule_causal(1),s(concept(p2),variable(x))).
rule_body(rule_causal(1),s(concept(p1),variable(x))).

rule_head(rule_causal(2),s(concept(p3),variable(x))).
rule_body(rule_causal(2),s(concept(p2),variable(x))).

rule_head(rule_causal(3),s(concept(p1),variable(x))).
rule_body(rule_causal(3),s(concept(p3),variable(x))).


rule_static(4..6).

rule_head(rule_static(4),s(concept(on),variable(x))).
rule_body(rule_static(4),s(concept(p1),variable(x))).

rule_head(rule_static(5),s(concept(on),variable(x))).
rule_body(rule_static(5),s(concept(p2),variable(x))).

rule_head(rule_static(6),s(concept(off),variable(x))).
rule_body(rule_static(6),s(concept(p3),variable(x))).
