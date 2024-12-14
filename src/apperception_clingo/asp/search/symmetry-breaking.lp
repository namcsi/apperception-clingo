% symmetry breaking for entity instantiation.
%
% Instantiation of entities from domains must happen in ascending
% order of identifiers, without any gaps. We apply this constraint
% only to generated entities, as otherwise it could lead to unsat for
% valid inputs.

:- obj_domain(X1), not gen(obj(X1)), X1 < X2, gen(obj(X2)).
:- unary_pred_domain(X1), not gen(pred(X1,1)), X1 < X2, gen(pred(X2,1)).
:- binary_pred_domain(X1), not gen(pred(X1,2)), X1 < X2, gen(pred(X2,2)).
:- causal_domain(X1), not causal(X1), X1 < X2, causal(X2).
:- static_domain(X1), not static(X1), X1 < X2, static(X2).

% Symmetry breaking for type assignment.
%
% The mapping from generated entities to types must be
% monotonic.
:- gen(obj(O1)), gen(obj(O2)),
	 isa(T1,obj(O1)), isa(T2,obj(O2)),
	 O1 < O2, T2 < T1.

:- gen(pred(P1,1)), gen(pred(P2,1)),
	 isa(T1,pred(P1,1)), isa(T2,pred(P2,1)),
	 P1 < P2, T2 < T1.

:- gen(pred(P1,2)), gen(pred(P2,2)),
	 isa((T1,T2),pred(P1,2)), isa((T3,T4),pred(P2,2)),
	 (T3,T4) < (T1,T2).

:- gen(var(V1)), gen(var(V2)),
	 isa(T1,var(V1)), isa(T2,var(V2)),
	 V1 < V2, T2 < T1.

% Symmetry breaking for constructed rules.
%
% Variables of the same type occurring in a rule must be used in
% ascending order with no gaps
:- var(V1), var(V2), isa(T,V1), isa(T,V2),
	 rule_var(R,V1), V2 < V1, not rule_var(R,V2).

% We define a partial order over rules
% We first order via head atom
less_rule_head(static(R1),static(R2))
  :- static(R1), static(R2), rule_head(static(R1),U1),
		 rule_head(static(R2),U2), U1 < U2.
less_rule_head(causal(R1),causal(R2))
  :- causal(R1), causal(R2), rule_head(causal(R1),U1),
		 rule_head(causal(R2),U2), U1 < U2.

eq_rule_head(causal(R1),causal(R2))
  :- rule_head(causal(R1),U), rule_head(causal(R2),U), R1 != R2.
eq_rule_head(static(R1),static(R2))
  :- rule_head(static(R1),U), rule_head(static(R2),U), R1 != R2.

% If head atom is the same, we order via size of body
rule_body_size(R,S) :- rule(R), S = #count{ U: rule_body(R,U) }.
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
:- static(R1), static(R2), R1 < R2, less_rule(static(R2),static(R1)).
:- causal(R1), causal(R2), R1 < R2, less_rule(causal(R2),causal(R1)).
