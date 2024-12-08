% definition and effect of incompassibility, xor and exist constraints
xor(C2,C1) :- xor(C1,C2).
xor(C1,C3) :- xor(C1,C2), xor(C2,C3).
xor(C,C) :- xor(C,_).

% we choose the minimal element of an xor equivalence class as the representative element
xor_repr(C,CR) :- xor(C,_), CR = #min{ C': xor(C,C') }.

incomp_var_atoms((CR,V),s(C,V))
  :- concept(C,1), xor_repr(C,CR), unground_atom(s(C,V)).
incomp_var_atoms((CR,V1,V2),s2(C,V1,V2))
  :- concept(C,2), xor_repr(C,CR), unground_atom(s2(C,V1,V2)).

incomp_ground_atoms((CR,O),s(C,O))
  :- concept(C,1), xor_repr(C,CR), ground_atom(s(C,O)).
incomp_ground_atoms((CR,O1,O2),s2(C,O1,O2))
  :- concept(C,2), xor_repr(C,CR), ground_atom(s2(C,O1,O2)).
incomp_ground_atoms((C,O1),s2(C,O1,O2)) :- exist(C), ground_atom(s2(C,O1,O2)).

% definition of incompossible set of ground atoms
:- incomp_ground_atoms(ID,_), time(T), not hold(Y,T): incomp_ground_atoms(ID,Y).
-hold(Z,T) :- hold(Y,T), incomp_ground_atoms(ID,Y), incomp_ground_atoms(ID,Z), Y!=Z.
hold(Y,T+1) :- hold(Y,T), time(T+1), not -hold(Y,T+1).
