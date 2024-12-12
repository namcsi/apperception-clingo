%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -------------------- Generate --------------------  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#const gen_types = 0.
#const gen_objects = 0.
#const gen_unary_concepts = 0.
#const gen_binary_concepts = 0.
#const gen_variables = 0.
#const rule_causal_max = 0.
#const rule_static_max = 0.
#const rule_body_size_max = 0.

type(0..gen_types-1).
concept(0..gen_unary_concepts-1,1).
concept(0..gen_binary_concepts-1,2).
object(0..gen_objects-1).
variable(0..gen_variables-1).
rule_causal_domain(0..rule_causal_max-1).
rule_static_domain(0..rule_static_max-1).

% choose to use rules
{ rule_causal(R) } :- rule_causal_domain(R).
{ rule_static(R) } :- rule_static_domain(R).

% choose type signatures for entities
1 { isa(T,object(O)): type(T) } 1 :- object(O).
1 { isa(T,concept(C)): type(T) } 1 :- concept(C,1).
1 { isa((T1,T2),concept(C)): type(T1), type(T2) } 1 :- concept(C,2).
1 { isa(T,variable(V)): type(T) } 1 :- variable(V).

% choose xor and exist constraints
{ xor(C1,C2): concept(C2,Arity), isa(T,C2), C1 < C2 } :- concept(C1,Arity), isa(T,concept(C1)).
{ exist(C) } :- concept(C,2).

% choose atoms that hold in the initial time step.
{ init(G) } :- ground_atom(G).

% choose rules
1 { rule_head(R,U): unground_atom(U) } 1 :- rule(R).
1 { rule_body_size(R,S): 1 <= S <= rule_body_size_max } 1 :- rule(R).
1 { rule_body(R,U): unground_atom(U) } S :- rule(R), rule_body_size(R,S).
