concept((p1;p2;p3),1).
isa(t_sensor,(p1;p2;p3)).
concept(r,2).
isa((t_sensor,t_sensor),r).
xor(p1,p2;p2,p3).
exist(r).
variable(x;y).
isa(t_sensor,(x;y)).

init(s(p1,obj_sensor_a;p2,obj_sensor_b)).
init(s2(r,obj_sensor_a,obj_sensor_b)).

rule_causal(1..3).

rule_head(1,s(p2,x)).
rule_body(1,s(p1,x)).

rule_head(2,s(p3,x)).
rule_body(2,s(p2,x)).

rule_head(3,s(p1,x)).
rule_body(3,s(p3,x)).


rule_static(4..6).

rule_head(4,s(c_on,x)).
rule_body(4,s(p1,x)).

rule_head(5,s(c_on,x)).
rule_body(5,s(p2,x)).

rule_head(6,s(c_off,x)).
rule_body(6,s(p3,x)).

#show hold/2.
#show sat/2.
#show sat_subs/2.
