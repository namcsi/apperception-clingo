% -------- Prevent unfoundedness --------

edge(R,V,V) :- rule_body_var(R,V).
edge(R,V1,V2) :- rule_body(R,s2(_,V1,V2)).
edge(R,V2,V1) :- edge(R,V1,V2).

reach(R,V1,V2) :- edge(R,V1,V2).
reach(R,V1,V3) :- reach(R,V1,V2), reach(R,V2,V3).

independent_var(R,V)
  :- rule(R), rule_var(R,V),
		 not reach(R,V,VH): rule_head(R,UH), atom_var(UH,VH).

% For each rule with a head atom that holds, we pick a substitution
% for each variable that occurs in the rule. The ground rule
% corresponding to the substitutions picked will attempt to justify
% the head atom.
1 { unfounded_subs(R,G,T,(V,O)): subs(V,O) } 1
  :- rule_head(R,U), atom_subs(U,G,_),
		 hold(G,T), rule_var(R,V),
		 not atom_subs(U,G,(V,_)),
     not independent_var(R,V).

% If this variable occurs in the head atom, the substitution is fixed.
unfounded_subs(R,G,T,(V,O))
  :- rule_head_ground(R,G,(V,O)), hold(G,T).

% If the variable cannot reach any of the variables in the head of the
% rule, then the choice of substitution is independent of the head
% atom we are attempting to justify.
1 { unfounded_subs(R,T,(V,O)): subs(V,O) } 1
  :- time(T), rule_head_ground(R,G,_),
		 hold(G,T), independent_var(R,V).

% For a given grounding GB of a head atom UB, we derive

unfounded(R,G,T,(UB,GB),(VH,OH))
  :- rule_delta(R,T,TB),
		 rule_head(R,UH), atom_subs(UH,GH,(VH,OH)),
		 rule_body(R,UB), atom_subs(UB,GB,_),
		 atom_var(UB,VB), reach(R,VB,VH),
		 unfounded_subs(R,GH,T,(V,O)): atom_subs(UB,GB,(V,O));
		 not hold(GB,TB).

unfounded(R,G,T)
  :- rule_head_ground(R,G), unfounded(R,T,G,ID,_),
		 rule_head_ground(R,G,(V,O)): unfounded(R,T,G,ID,(V,O)).


unfounded(R,T)
  :- rule_delta(R,T,TB),
		 rule_body_ground(R,GB,(VB,_)), independent_var(R,VB),
		 unfounded_subs(R,T,(V,O)): rule_body_ground(R,GB,(V,O));
		 not hold(GB,TB).

unfounded(R,G,T)
  :- rule_head_ground(R,G,_), unfounded(R,T).

% It cannot be the case that an atom that holds in the initial time
% step is not founded by being an init atom or sensory reading and
% also not founded by a static rule.
:- hold(G,T), init_time(T), not init(G),
	 unfounded(static(R),G,T): rule_head_ground(static(R),G,_).

% It cannot be the case that an atom that holds in a non-initial time
% step is not founded by inertia and also not founded by a causal rule.
:- hold(G,T), not init_time(T), not hold(G,T-1),
	 unfounded(R,G,T): rule_head_ground(R,G,_).
