%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -------------------- Definitions -------------------- %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#const first_time_point = 1.
init_time(first_time_point).
init(G) :- senses(G,T), init_time(T).
hold(G,T) :- init_time(T), init(G).

% always instatiate input
#defined input/1.
type(T) :- input(type(T)).
object(O) :- input(object(O)).
isa(T,A) :- input(isa(T,A)).
concept(C,Arity) :- input(concept(C,Arity)).
xor(C1,C2) :- input(xor(C1,C2)).
exist(C) :- input(exist(C)).
variable(V) :- input(variable(V)).


% construct unground atoms.
unground_atom(s(concept(C,1),variable(V)))
  :- concept(C,1), isa(T,concept(C,1)), variable(V), isa(T,variable(V)).
unground_atom(s2(concept(C,2),variable(V1),variable(V2)))
  :- concept(C,2), isa((T1,T2),concept(C,2)), variable(V1), isa(T1,variable(V)),
		 variable(V2), isa(T2,variable(V2)).
atom_var(s(C,V),V) :- unground_atom(s(C,V)).
atom_var(s2(C,V1,V2),(V1;V2)) :- unground_atom(s2(C,V1,V2)).

% construct ground atoms.
ground_atom(s(concept(C,1),object(O)))
  :- concept(C,1), isa(T,concept(C,1)), object(O), isa(T,object(O)).
ground_atom(s2(concept(C,2),object(O1),object(O2)))
  :- concept(C,2), isa((T1,T2),concept(C,2)), object(O1), isa(T1,object(O1)),
		 object(O2), isa(T2,object(O2)).

% generate variable substitutions.
subs(variable(V),object(O)) :- variable(V), isa(T,variable(V)), object(O), isa(T,object(O)).
atom_subs(s(C,V),s(C,O),(V,O)) :- unground_atom(s(C,V)), subs(V,O).
atom_subs(s2(C,V1,V2),s2(C,O1,O2),((V1,O1);(V2,O2)))
  :- unground_atom(s2(C,V1,V2)), V1 != V2, subs(V1,O1), subs(V2,O2).
atom_subs(s2(C,V,V),s2(C,O,O),(V,O)) :- unground_atom(s2(C,V,V)), subs(V,O).

% construct rules
% Version with more symmetries but much less grounding
rule(rule_causal(R)) :- rule_causal(R).
rule(rule_static(R)) :- rule_static(R).
rule_body_var(R,V) :- rule_body(R,U), atom_var(U,V).
rule_var(R,V) :- rule_body_var(R,V).
rule_var(R,V) :- rule_head(R,U), atom_var(U,V).
rule_ground_head(R,G) :- rule_head(R,U), atom_subs(U,G,_).
rule_ground_body(R,G) :- rule_body(R,U), atom_subs(U,G,_).
