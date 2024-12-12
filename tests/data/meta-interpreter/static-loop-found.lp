%% expected:
%% hold(s(p,a),1).
%% hold(s(q,a),1).
#include "defined.lp".
concept((q;p;q';p'),1).
isa(t,concept(q;p;q';p')).
variable(x;y).
isa(t,variable(x;y)).
object(a).
isa(t,object(a)).
xor(concept(p),concept(p');concept(q),concept(q')).

time(1).

init(s(concept(q),object(a))).

rule_static(1;2).

rule_head(rule_static(1),s(concept(p),variable(x))).
rule_body(rule_static(1),s(concept(q),variable(x))).

rule_head(rule_static(2),s(concept(q),variable(y))).
rule_body(rule_static(2),s(concept(p),variable(y))).
