% -------- Prevent unfoundedness --------
% for each rule with a head atom that holds, we pick a substitution
% for each variable that occurs in the rule. If this variable occurs
% in the head atom, the substitution is fixed.  The ground rule
% corresponding to the substitutions picked will attempt to justify
% the head atom.
1 { unfounded_subs(R,G,T,(V,O)): subs(V,O) } 1
  :- rule_head(R,U), atom_subs(U,G,_), hold(G,T),
		 rule_var(R,V), not atom_subs(U,G,(V,_)).
unfounded_subs(R,G,T,(V,O)) :- rule_head(R,U), atom_subs(U,G,(V,O)), hold(G,T).

% We derive unfounded(R,G,T) if for an atom G with hold(G,T) and a
% rule R who's head unifies with G, we cannot fix a particular
% substitution for the remaining free variables in the rule via
% unfounded_subs(R,G,T,(V,O)) under which the rule is suitable for
% justifying hold(G,T). Thus, in this case rule R cannot possibly
% justify hold(G,T).
unfounded(R,G,T)
  :- rule_causal(R), time(T), not init_time(T),
		 rule_head(R,U), atom_subs(U,G,_),
		 rule_body(R,UB), atom_subs(UB,GB,_),
		 unfounded_subs(R,G,T,(V,O)): atom_subs(UB,GB,(V,O));
		 not hold(GB,T-1).
unfounded(R,G,T)
  :- rule_static(R), time(T),
		 rule_head(R,U), atom_subs(U,G,_),
		 rule_body(R,UB), atom_subs(UB,GB,_),
		 unfounded_subs(R,G,T,(V,O)): atom_subs(UB,GB,(V,O));
		 not hold(GB,T).

% It cannot be the case that an atom is not founded by a rule or by
% inertia or by being an initial fact.
%% :- rule_head(R,U), atom_subs(U,G,_),

:- hold(G,T), init_time(T), not init(G),
	 unfounded(R,G,T): rule_static(R), rule_head(R,U), atom_subs(U,G,_).

:- hold(G,T), not init_time(T), not hold(G,T-1),
	 unfounded(R,G,T): rule(R), rule_head(R,U), atom_subs(U,G,_).
