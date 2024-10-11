% rule body can never be satisfied and is thus useless.
:- rule_body(R,U1), rule_body(R,U2), U1 < U2, incomp_var_atoms(U1,U2).
% rule body can be satified, but one of the atoms can be dropped to
% get a lower cost
:- exist(C), rule_body(R,s2(C,V1,V2)), rule_body(R,s2(C,V1,V3)), V2 < V3.
% useless rule
:- rule_body(R,U), rule_head(R,U).
% safety
:- rule_head(R,U), atom_var(U,V), not rule_body_var(R,V).
% causes incompossibility violation
:- rule_body(static(R),U1), rule_head(static(R),U2), U1 < U2,
	 incomp_var_atoms(U1,U2).
