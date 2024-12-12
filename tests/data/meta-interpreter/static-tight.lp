% expected:
%% hold(s(p,a),1).
%% hold(s(q,a),1).
%% hold(s(r,a),1).
#include "defined.lp".
type(t).
concept((p;q;r;p';q';r'),1).
isa(t,concept(p;q;r;p';q';r')).
variable(x).
isa(t,variable(x)).
xor(concept(r),concept(r');concept(p),concept(p');concept(q),concept(q')).

object(a).
isa(t,object(a)).

init(s(concept(p),object(a);concept(q),object(a))).

rule_static(1).

rule_head(rule_static(1),s(concept(r),variable(x))).
rule_body(rule_static(1),s(concept(p),variable(x))).
rule_body(rule_static(1),s(concept(q),variable(x))).

time(1).
