%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -------------------- Generate --------------------  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#const gen_type_max = 0.
#const gen_object_max = 0.
#const gen_concept_max = 0.
#const gen_variable_max = 0.
#const rule_causal_max = 0.
#const rule_static_max = 0.
#const rule_body_size_max = 0.
type_dom(0..gen_type_max-1).
object_dom(0..gen_object_max-1).
concept_dom(0..gen_concept_max-1).
variable_dom(0..gen_variable_max-1).
rule_causal_dom(0..rule_causal_max-1).
rule_static_dom(0..rule_static_max-1).

% choose to instatiate from domains
{ type(T) } :- type_dom(T).
{ object(O) } :- object_dom(O).
{ concept(C,1); concept(C,2) } = 1 :- concept_dom(C).
{ variable(V) } :- variable_dom(V).
{ rule_causal(R) } :- rule_causal_dom(R).
{ rule_static(R) } :- rule_static_dom(R).

% choose type signatures for entities
{ isa(T,O): type(T) } = 1 :- object(O).
{ isa(T,C): type(T) } = 1 :- concept(C,1).
{ isa((T1,T2),C): type(T1), type(T2) } = 1 :- concept(C,2).
{ isa(T,V): type(T) } = 1 :- variable(V).

% choose xor and exist constraints
{ xor(C1,C2): concept(C2,Arity), isa(T,C2), C2 != C1 } :- concept(C1,Arity), isa(T,C1).
{ exist(C) } :- concept(C,2).

% choose atoms that hold in the initial time step.
{ init(G) } :- ground_atom(G).

% choose rules
{ rule_head(R,U): unground_atom(U) } = 1 :- rule(R).
{ rule_body_size(R,S): 1 <= S <= rule_body_size_max } = 1 :- rule(R).
1 { rule_body(R,U): unground_atom(U) } S :- rule(R), rule_body_size(R,S).
