#include "../core.lp".

:- senses(G,T), time(T), not hold(G,T).

subs_group(((V,O),())) :- subs(V,O).
subs_group(((VN,ON),((V,O),Cdr)))
  :- subs_group(((V,O),Cdr)), VN=var(_), V < VN, subs(VN,ON).

subs_group(((V,O),Cdr),(V,O)) :- subs_group(((V,O),Cdr)).
subs_group(((VN,ON),((V,O),Cdr)),(V',O'))
  :- subs_group(((VN,ON),((V,O),Cdr))), subs_group(((V,O),Cdr),(V',O')).


rule_subs_group(R,G)
  :- rule(R), subs_group(G),
		 rule_var(R,V): subs_group(G,(V,_));
		 subs_group(G,(V,_)): rule_var(R,V).

hold_body(R,S,T)
  :- rule_subs_group(R,S),
		 time(T),
		 hold(s(P,O),T): rule_body(R,s(P,V)), subs_group(S,(V,O));
		 hold(s2(P,O1,O2),T): rule_body(R,s2(P,V1,V2)),
		                       subs_group(S,(V1,O1)),
												   subs_group(S,(V2,O2)).

hold(s(P,O),T)
  :- R = static(_),
		 rule_head(R,s(P,V)),
		 hold_body(R,S,T),
		 subs_group(S,(V,O)).

hold(s2(P,O1,O2),T)
  :- R = static(_),
		 rule_head(R,s2(P,V1,V2)),
		 hold_body(R,S,T),
		 subs_group(S,(V1,O1)), subs_group(S,(V2,O2)).

hold(s(P,O),T+1)
  :- R = causal(_),
		 rule_head(R,s(P,V)),
		 hold_body(R,S,T),
		 subs_group(S,(V,O)),
     time(T+1).

hold(s2(P,O1,O2),T+1)
  :- R = causal(_),
		 rule_head(R,s2(P,V1,V2)),
		 hold_body(R,S,T),
		 subs_group(S,(V1,O1)), subs_group(S,(V2,O2)),
     time(T+1).
