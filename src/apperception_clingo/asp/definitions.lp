%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -------------------- Definitions -------------------- %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init_time(1).
hold(G,T) :- init_time(T), init(G).

% always instatiate input
type(T) :- input(type(T)).
object(O) :- input(object(O)).
isa(T,A) :- input(isa(T,A)).
concept(C,Arity) :- input(concept(C,Arity)).
xor(C1,C2) :- input(xor(C1,C2)).
exist(C) :- input(exist(C)).
#defined input/1.


% construct unground atoms
unground_atom(s(C,V)) :- concept(C,1), isa(T,C), variable(V), isa(T,V).
unground_atom(s2(C,V1,V2))
  :- concept(C,2), isa((T1,T2),C), variable(V1), isa(T1,V), variable(V2), isa(T2,V2).
atom_var(s(C,V),V) :- unground_atom(s(C,V)).
atom_var(s2(C,V1,V2),(V1;V2)) :- unground_atom(s2(C,V1,V2)).

% generate variable substitutions and ground atoms
subs(V,O) :- variable(V), isa(T,V), object(O), isa(T,O).
atom_subs(s(C,V),s(C,O),(V,O)) :- unground_atom(s(C,V)), subs(V,O).
atom_subs(s2(C,V1,V2),s2(C,O1,O2),((V1,O1);(V2,O2)))
  :- unground_atom(s2(C,V1,V2)), V1 != V2, subs(V1,O1), subs(V2,O2).
atom_subs(s2(C,V,V),s2(C,O,O),(V,O)) :- unground_atom(s2(C,V,V)), subs(V,O).
ground_atom(G) :- atom_subs(_,G,_).

% construct rules
% Version with more symmetries but much less grounding
rule(R) :- rule_causal(R).
rule(R) :- rule_static(R).
rule_var(R,V) :- rule_body(R,U), atom_var(U,V).
%% rule_var(R,V) :- rule_head(R,U), atom_var(U,V).
