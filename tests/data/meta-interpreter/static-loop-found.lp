%% expected:
%% hold(s(p,a),1).
%% hold(s(q,a),1).
#include "defined.lp".
pred((q;p;q';p'),1).
isa(type(t),pred((q;p;q';p'),1)).
var(x;y).
isa(type(t),var(x;y)).
obj(a).
isa(type(t),obj(a)).
xor(pred(p,1),pred(p',1);pred(q,1),pred(q',1)).

time(1).

init(s(pred(q,1),obj(a))).

static(1;2).

rule_head(static(1),s(pred(p,1),var(x))).
rule_body(static(1),s(pred(q,1),var(x))).

rule_head(static(2),s(pred(q,1),var(y))).
rule_body(static(2),s(pred(p,1),var(y))).
