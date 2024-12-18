% definition and effect of incompassibility, xor and exist constraints
xor(C2,C1) :- xor(C1,C2).
xor(C1,C3) :- xor(C1,C2), xor(C2,C3).
xor(C,C) :- xor(C,_).
xor(C,C) :- xor(_,C).

% we choose the minimal element of an xor equivalence class as the representative element
xor_repr(C,CR) :- xor(C,_), CR = #min{ C': xor(C,C') }.

incomp_var_atoms((CR,V),s(C,V))
  :- C = pred(_,1), xor_repr(C,CR), unground_atom(s(C,V)).
incomp_var_atoms((CR,V1,V2),s2(C,V1,V2))
  :- C = pred(_,2), xor_repr(C,CR), unground_atom(s2(C,V1,V2)).

:- xor_repr(_,C), time(T), ground_atom(s(C,O)),
	 { hold(s(C',O),T): xor(C,C') } != 1.

:- xor_repr(_,C), time(T), ground_atom(s2(C,O1,O2)),
	 { hold(s2(C',O1,O2),T): xor(C,C') } != 1.

:- exist(C), time(T), ground_atom(s2(C,O1,_)),
	 { hold(s2(C,O1,O2),T): ground_atom(s2(C,O1,O2)) } != 1.
