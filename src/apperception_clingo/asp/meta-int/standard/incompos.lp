incomp_ground_atoms((CR,O),s(C,O))
  :- C = pred(_,1),  xor_repr(C,CR), ground_atom(s(C,O)).
incomp_ground_atoms((CR,O1,O2),s2(C,O1,O2))
  :- C = pred(_,1), xor_repr(C,CR), ground_atom(s2(C,O1,O2)).
incomp_ground_atoms((C,O1),s2(C,O1,O2)) :- exist(C), ground_atom(s2(C,O1,O2)).

% definition of incompossible set of ground atoms
:- incomp_ground_atoms(ID,_), time(T), not hold(Y,T): incomp_ground_atoms(ID,Y).
-hold(Z,T) :- hold(Y,T), incomp_ground_atoms(ID,Y), incomp_ground_atoms(ID,Z), Y!=Z.
% frame axiom
hold(Y,T+1) :- hold(Y,T), time(T+1), not -hold(Y,T+1).
