% defer choice over atoms in body-decoupled grounding
#heuristic hold(G,T) : rule_head_ground(_,G,_), time(T). [-1, level]
#heuristic hold(G,T) : init(G), time(T). [-1, level]
#heuristic sat_subs(R,(V,O)): subs(V,O), rule_var(R,V). [-1, level]
#heuristic unfounded_subs(R,G,T,(V,O)): rule_head_ground(R,G,_), hold(G,T),
		 rule_var(R,V), not rule_head_ground(R,G,(V,_)), subs(V,O). [-1, level]
