% -------- Prevent unfoundedness --------
% for each rule with a head atom that holds, we pick a substitution
% for each variable that occurs in the rule. If this variable occurs
% in the head atom, the substitution is fixed.  The ground rule
% corresponding to the substitutions picked will attempt to justify
% the head atom.
1 { unfounded_subs(R,T,G,(V,O)): subs(V,O) } 1
  :- rule_head(R,U), ground_subs(U,G,_), hold(G,T),
		 rule_var(R,V), not ground_subs(U,G,(V,_)).

unfounded_subs(R,T,G,(V,O))
  :- rule_head(R,U), ground_subs(U,G,(V,O)), hold(G,T).

% We derive unfounded(R,T,GH) if for an atom GH with a
% rule R who's head unifies with GH, we cannot fix a particular
% substitution for the remaining free variables in the rule via
% unfounded_subs(R,T,GH,(V,O)) under which the rule is suitable for
% justifying hold(GH,T). Thus, in this case rule R cannot possibly
% justify hold(GH,T).
unfounded(R,T,GH)
  :- rule_delta(R,T,TB),
		 rule_head_ground(R,GH),
		 rule_body(R,UB), ground_subs(UB,GB,_),
		 unfounded_subs(R,T,GH,(V,O)): ground_subs(UB,GB,(V,O));
		 not hold(GB,TB).

% It cannot be the case that an atom that holds in the initial time
% step is not founded by being an init atom and also not founded by a
% static rule.
:- hold(G,T), init_time(T), not init(G),
	 unfounded(static(R),T,G): rule_head_ground(static(R),G).

% It cannot be the case that an atom that holds in a non-initial time
% step is not founded by inertia and also not founded by a rule.
:- hold(G,T), not init_time(T), not hold(G,T-1),
	 unfounded(R,T,G): rule_head_ground(R,G).
