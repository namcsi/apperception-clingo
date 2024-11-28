% definition of incompossibilty
:- not holds(Y,T): incompossible_set(X,Y), incompossible_set(X,_), time(T).
-holds(Z,T) :- holds(Y,T), incompossible_set(X,Y), incompossible_set(X,Z), Y!=Z, time(T).
holds(Y,T+1) :- holds(Y,T), time(T+1), not -holds(Y,T+1).

% extract incompossibility from xor constraints
incompossible_set((Xor,O),s(C,O))
  :- xor_constraint(Xor,T), xor_member(Xor,C), object(O), isa(T,O).

incompossible_set((Xor,O1,O2),s2(C,O1,O2))
  :- xor_constraint2(Xor,T1,T2), xor_member(Xor,C),
     object(O1), isa(T1,O1), object(O2), isa(T2,O2).

:- xor_constraint(Xor,T), xor_member(Xor,C), not isa(T,C).
:- xor_constraint(Xor,T), not xor_member(Xor,_).

:- xor_constraint2(Xor,T1,T2), xor_member(Xor,C), not isa2(T1,T2,C).
:- xor_constraint2(Xor,T1,T2), not xor_member(Xor,_).

% extract incompossibility from exist constraint
incompossible_set((C,O1),s2(C,O1,O2))
  :- exist_constraint(C), concept2(C), isa2(T1,T2,C), object(O1), object(O2),
		 isa(T1,O1), isa(T2,O2).

% sanity check
%% incompossible_set(1,s(on,a)).
%% incompossible_set(1,s(off,a)).
%% time(1..2).
%% holds(s(on,a),1).
%% holds(s(off,a),T+1):- holds(s(on,a),T), time(T+1).

%% #show holds/2.
