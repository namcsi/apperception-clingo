:- xor_repr(_,C), time(T), ground_atom(s(C,O)),
	 { hold(s(C',O),T): xor(C,C') } != 1.

:- xor_repr(_,C), time(T), ground_atom(s2(C,O1,O2)),
	 { hold(s2(C',O1,O2),T): xor(C,C') } != 1.

:- exist(C), time(T), ground_atom(s2(C,O1,_)),
	 { hold(s2(C,O1,O2),T): ground_atom(s2(C,O1,O2)) } != 1.
