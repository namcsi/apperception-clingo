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
1 { unfounded_subs(R,T,G,(V,O)): subs(V,O) } 1
  :- rule_head(R,U), ground_subs(U,G,_),
		 hold(G,T), rule_var(R,V),
		 not ground_subs(U,G,(V,_)),
     not independent_var(R,V).

% If the variable cannot reach any of the variables in the head of the
% rule, then the choice of substitution can be made independent of the
% head atom we are attempting to justify.
1 { unfounded_subs(R,T,(V,O)): subs(V,O) } 1
  :- rule_head_ground(R,G), hold(G,T), independent_var(R,V).

% If this variable occurs in the head atom, the substitution is fixed.
unfounded_subs(R,T,G,(V,O))
  :- rule_head(R,U), ground_subs(U,G,(V,O)), hold(G,T).

% Consider a ground substitution of a body atom (UB,GB) for which GB
% does not hold. The substitution of any head variables VH in UH reachable
% from UB are then collected into a group via
% unfounded(R,T,(UB,UH),(VH,OH)).

unfounded(R,T,(UB,UH,GH),(VH,OH))
  :- rule_delta(R,T,TB),
		 rule_body(R,UB), ground_subs(UB,GB,(VB,_)),
		 rule_head(R,UH), ground_subs(UH,GH,(VH,OH)),
		 reach(R,VB,VH),
		 unfounded_subs(R,T,GH,(V,O)): ground_subs(UB,GB,(V,O));
		 not hold(GB,TB).

unfounded(R,T)
  :- rule_delta(R,T,TB),
		 rule_body(R,UB), ground_subs(UB,GB,(VB,_)),
		 independent_var(R,VB),
		 unfounded_subs(R,T,(V,O)): ground_subs(UB,GB,(V,O));
		 not hold(GB,TB).

% A rule cannot found G if the substitution that results in G has as a
% subset a group of unfounded substitutions.
unfounded(R,T,GH)
  :- rule_delta(R,T,_),
		 rule_head(R,UH), ground_subs(UH,GH,_),
		 unfounded(R,T,(_,UH,G),_),
		 ground_subs(UH,GH,(V,O)): unfounded(R,T,(_,UH,G),(V,O)).

unfounded(R,T,G)
  :- rule_head_ground(R,G), unfounded(R,T).

% It cannot be the case that an atom that holds in the initial time
% step is not founded by being an init atom or sensory reading and
% also not founded by a static rule.
:- hold(G,T), init_time(T), not init(G),
	 unfounded(static(R),T,G): rule_head_ground(static(R),G).

% It cannot be the case that an atom that holds in a non-initial time
% step is not founded by inertia and also not founded by a causal rule.
:- hold(G,T), not init_time(T), not hold(G,T-1),
	 unfounded(R,T,G): rule_head_ground(R,G).
