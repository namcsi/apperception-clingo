% could we do this with more efficiently with clingo-dl?
1 { less(G1,G2); less(G2,G1) } 1 :- ground_atom(G1), ground_atom(G2), G1 < G2, time(T).
:- less(G1,G2), less(G2,G3), less(G3,G1).

unfounded(R,G,T)
  :- R = static(_), time(T),
		 rule_head(R,U), atom_subs(U,G,_),
		 rule_body(R,UB), atom_subs(UB,GB,_),
		 unfounded_subs(R,G,T,(V,O)): atom_subs(UB,GB,(V,O));
		 not less(GB,G).

%% count_ground_atom(N) :- N = #count { G: ground_atom(G) }.
%% 1 { perm(G,P,T): P=1..N } 1 :- ground_atom(G), time(T), count_ground_atom(N).

%% unfounded(R,G,T)
%%   :- R = static(_), time(T),
%% 		 rule_head(R,U), atom_subs(U,G,_),
%% 		 rule_body(R,UB), atom_subs(UB,GB,_),
%% 		 unfounded_subs(R,G,T,(V,O)): atom_subs(UB,GB,(V,O));
%% 		 perm(G,P,T), perm(GB,PB,T), P <= PB.
