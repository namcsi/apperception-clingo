% symmetry breaking for entity instantiation.
%
% Instantiation of entities from domains must happen in ascending
% order of identifiers, without any gaps. We exclude inputs from this
% constraint, as it could lead to unsat for valid solutions.
:- type_dom(X1), type(X2), X1 < X2, not type(X1), not input(type(X2)).
:- object_dom(X1), object(X2), X1 < X2, not object(X1), not input(object(X2)).
:- concept_dom(X1), concept(X2), X1 < X2, not concept(X1), not input(concept(X2)).
:- variable_dom(X1), variable(X2), X1 < X2, not variable(X1), not input(variable(X2)).
:- rule_causal_dom(X1), rule_causal(X2), X1 < X2, not rule_causal(X1).
:- rule_static_dom(X1), rule_static(X2), X1 < X2, not rule_static(X1).

% Symmetry breaking for type assignment.
%
% The mapping from generated entities to their types must be
% monotonic. We again exclude input entities.
:- object(O1), object(O2), O1 < O2,
   isa(T1,O1), isa(T2,O2), T2 < T1,
	 not input(object(O1)), not input(object(O2)).
:- concept(C1), concept(C2), C1 < C2,
	 isa(T1,C1), isa(T2,C2), T2 < T1,
	 not input(concept(C1)), not input(concept(C2)).
:- concept2(C1), concept2(C2), C1 < C2,
	 isa((T1,T2),C1), isa((T3,T4),C2), (T3,T4) < (T1,T2),
	 not input(concept2(C1)), not input(concept2(C2)).
:- variable(V1), variable(V2), V1 < V2,
	 isa(T1,V1), isa(T2,V2), T2 < T1,
	 not input(variable(V1)), not input(variable(V2)).

% Symmetry breaking for constructed rules.
%
% Variables of the same type occurring in a rule must be used in
% ascending order with no gaps

:- rule_var(R,V1), isa(T,V1), isa(T,V2), V2 < V1, not rule_var(R,V2).
% We define a partial order over rules
% We first order via head atom
less_rule_head(R1,R2) :- rule_head(R1,U1), rule_head(R2,U2), U1 < U2.
eq_rule_head(R1,R2) :- rule_head(R1,U), rule_head(R2,U), R1 != R2.
% If head atom is the same, we order via size of body
less_rule_body_size(R1,R2)
  :- eq_rule_head(R1,R2), rule_body_size(R1,S1), rule_body_size(R2,S2), S1 < S2.
% if size of body is the same, we say R1 is less than R2 iff there is
% un unground atom in R1 that is less than all unground atoms in R2
% this is where the order becomes partial.
less_rule_body_dominates(R1,R2)
  :- eq_rule_head(R1,R2), rule_body_size(R1,S), rule_body_size(R2,S),
		 rule_body(R1,U1), U1 < U2: rule_body(R2,U2).
less_rule(R1,R2) :- less_rule_head(R1,R2).
less_rule(R1,R2) :- less_rule_body_size(R1,R2).
less_rule(R1,R2) :- less_rule_body_dominates(R1,R2).
% finally, the symmetry breaking constraint
:- rule(R1), rule(R2), R1 < R2, less_rule(R2,R1).
