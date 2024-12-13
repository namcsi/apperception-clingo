% expected:
%% hold(s(p,a),1).
%% hold(s(q,a),1).
%% hold(s(r,a),1).
#include "defined.lp".
type(t).
pred((p;q;r;p';q';r'),1).
isa(t,pred((p;q;r;p';q';r'),1)).
var(x).
isa(t,var(x)).
xor(pred(r,1),pred(r',1);pred(p,1),pred(p',1);pred(q,1),pred(q',1)).

obj(a).
isa(t,obj(a)).

init(s(pred(p,1),obj(a);pred(q,1),obj(a))).

static(1).

rule_head(static(1),s(pred(r,1),var(x))).
rule_body(static(1),s(pred(p,1),var(x))).
rule_body(static(1),s(pred(q,1),var(x))).

time(1).
