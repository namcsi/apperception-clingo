% ---- spacial unity ----
% All objects must be related via (the transitive, symmetric closure
% of) some binary relation.
related(A,B,T) :- hold(s2(_,A,B),T).
related(B,A,T) :- related(A,B,T).
related(A,C,T) :- related(A,B,T), related(B,C,T).
:- object(O1), object(O2), time(T), not related(O1,O2,T).

% ---- conceptual unity ----
% Each unary concept must appear in an xor constraint
% Each binary concept must appear in an xor or exist constraint.
:- concept(C,1), not xor(C,_).
:- concept(C,2), not xor(C,_), not exist(C).
