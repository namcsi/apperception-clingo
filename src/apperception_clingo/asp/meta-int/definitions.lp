%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -------------------- Definitions -------------------- %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#const first_time_point = 1.
init_time(first_time_point).
hold(G,T) :- init_time(T), init(G).

% always instatiate input
#defined input/1.
type(T) :- input(type(T)).
obj(O) :- input(obj(O)).
isa(T,A) :- input(isa(T,A)).
pred(C,Arity) :- input(pred(C,Arity)).
xor(C1,C2) :- input(xor(C1,C2)).
exist(C) :- input(exist(C)).
var(V) :- input(var(V)).


% construct unground atoms.
unground_atom(s(C,V))
  :- C = pred(_,1), V = var(_), isa(T,V), isa(T,C).
unground_atom(s2(C,V1,V2))
  :- C = pred(_,2), V1 = var(_), V2 = var(_),
		 isa((T1,T2),C), isa(T1,V1), isa(T2,V2).
atom_var(s(C,V),V) :- unground_atom(s(C,V)).
atom_var(s2(C,V1,V2),(V1;V2)) :- unground_atom(s2(C,V1,V2)).

% construct ground atoms.
ground_atom(s(C,O))
  :- C =pred(_,1), O = obj(_), isa(T,C), isa(T,O).
ground_atom(s2(C,O1,O2))
  :- C = pred(_,2), O1 = obj(_), O2 = obj(_),
		 isa((T1,T2),C), isa(T1,O1), isa(T2,O2).

% generate var substitutions.
subs(V,O) :- V = var(_),  O = obj(_), isa(T,O), isa(T,V).
atom_subs(s(C,V),s(C,O),(V,O)) :- unground_atom(s(C,V)), subs(V,O).
atom_subs(s2(C,V1,V2),s2(C,O1,O2),((V1,O1);(V2,O2)))
  :- unground_atom(s2(C,V1,V2)), V1 != V2, subs(V1,O1), subs(V2,O2).
atom_subs(s2(C,V,V),s2(C,O,O),(V,O)) :- unground_atom(s2(C,V,V)), subs(V,O).

% construct rules
% Version with more symmetries but much less grounding
rule(causal(R)) :- causal(R).
rule(static(R)) :- static(R).
rule_body_var(R,V) :- rule_body(R,U), atom_var(U,V).
rule_var(R,V) :- rule_body_var(R,V).
rule_var(R,V) :- rule_head(R,U), atom_var(U,V).
rule_ground_head(R,G) :- rule_head(R,U), atom_subs(U,G,_).
rule_ground_body(R,G) :- rule_body(R,U), atom_subs(U,G,_).
