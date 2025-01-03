% defer choice over atoms in body-decoupled grounding this seems to
% increase speed of finding first solution as well as proving
% optimality
#heuristic hold(G,T) : rule_head_ground(_,G), time(T). [-1, level]
#heuristic hold(G,T) : init(G), time(T). [-1, level]
#heuristic sat_subs(R,(V,O)): subs(V,O), rule_var(R,V). [-2, level]
#heuristic unfounded_subs(R,G,T,(V,O)):
     rule_head(R,U), ground_subs(U,G,_), hold(G,T),
		 rule_var(R,V), not ground_subs(U,G,(V,_)). [-2, level]
