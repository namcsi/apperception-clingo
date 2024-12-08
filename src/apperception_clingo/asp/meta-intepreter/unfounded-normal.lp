count_ground_atom(N) :- N = #count { G: ground_atom(G) }.
1 { perm(G,P,T): P=1..N } 1 :- ground_atom(G), time(T), count_ground_atom(N).

unfounded(R,G,T)
  :- rule_static(R), time(T),
		 rule_head(R,U), atom_subs(U,G,_),
		 rule_body(R,UB), atom_subs(UB,GB,_),
		 unfounded_subs(R,G,T,(V,O)): atom_subs(UB,GB,(V,O));
		 perm(G,P,T), perm(GB,PB,T), PB >= P.
