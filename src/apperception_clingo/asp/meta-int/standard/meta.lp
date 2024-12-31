#include "../definitions.lp".
#include "../incompos.lp".
#include "../unity.lp".

:- senses(G,T), time(T), not hold(G,T).

%% first(var(0)) :- gen(var(0)).
%% input(var(V)) :- var(V), not gen(var(V)).
%% first(var(V)) :- var(V), V = #min{ V': var(V') }.
%% last_input(var(V)) :- var(V), V = #max{ V': var(V') }.
position(var(V),P) :- var(V), P = #count{ V': var(V'), V' <= V }.

subs_group(((var(V),O),())) :- subs(var(V),O), position(var(V),1).
subs_group(((VN,ON),((V,O),Cdr)))
  :- subs_group(((V,O),Cdr)), position(V,P), position(VN,P+1), subs(VN,ON).

subs_group(((V,O),Cdr),(V,O)) :- subs_group(((V,O),Cdr)).
subs_group(((VN,ON),((V,O),Cdr)),(V',O'))
  :- subs_group(((VN,ON),((V,O),Cdr))), subs_group(((V,O),Cdr),(V',O')).

hold_body(R,S,T)
  :- subs_group(S),
		 time(T),
		 rule(R),
		 hold(s(P,O),T): rule_body(R,s(P,V)), subs_group(S,(V,O));
		 hold(s2(P,O1,O2),T): rule_body(R,s2(P,V1,V2)),
		                       subs_group(S,(V1,O1)),
												   subs_group(S,(V2,O2)).

hold(s(P,O),T)
  :- rule_delta(R,T,TB),
		 rule_head(R,s(P,V)),
		 hold_body(R,S,TB),
		 subs_group(S,(V,O)).

hold(s2(P,O1,O2),T)
  :- rule_delta(R,T,TB),
		 rule_head(R,s2(P,V1,V2)),
		 hold_body(R,S,TB),
		 subs_group(S,(V1,O1)), subs_group(S,(V2,O2)).
