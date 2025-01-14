% ---- spacial unity ----
% All objects must be related via (the transitive, symmetric closure
% of) some binary relation.
related(A,B,T) :- hold(s2(_,A,B),T).
related(B,A,T) :- related(A,B,T), A != B.
related(A,C,T) :- related(A,B,T), related(B,C,T), A != B, B != C, A != C.
:- obj(O1), obj(O2), O1 < O2, time(T), not related(obj(O1),obj(O2),T).

% ---- conceptual unity ----
xor(C2,C1) :- xor(C1,C2).
xor(C1,C3) :- xor(C1,C2), xor(C2,C3).

% we choose the minimal element of an xor equivalence class as the representative element
xor_repr(C,CR) :- xor(C,_), CR = #min{ C': xor(C,C') }.


% Each unary pred must appear in an xor constraint
% Each binary pred must appear in an xor or exist constraint.
:- pred(C,1), not xor(pred(C,1),_).
:- pred(C,2), not xor(pred(C,2),_), not exist(pred(C,2)).
