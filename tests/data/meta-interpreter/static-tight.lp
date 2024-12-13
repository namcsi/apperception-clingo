% expected:
%% hold(s(p,a),1).
%% hold(s(q,a),1).
%% hold(s(r,a),1).
#include "defined.lp".
type(t).
concept((p;q;r;p';q';r'),1).
isa(t,concept((p;q;r;p';q';r'),1)).
variable(x).
isa(t,variable(x)).
xor(concept(r,1),concept(r',1);concept(p,1),concept(p',1);concept(q,1),concept(q',1)).

object(a).
isa(t,object(a)).

init(s(concept(p,1),object(a);concept(q,1),object(a))).

rule_static(1).

rule_head(rule_static(1),s(concept(r,1),variable(x))).
rule_body(rule_static(1),s(concept(p,1),variable(x))).
rule_body(rule_static(1),s(concept(q,1),variable(x))).

time(1).
