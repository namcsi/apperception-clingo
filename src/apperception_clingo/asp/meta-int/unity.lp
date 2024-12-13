% ---- spacial unity ----
% All objects must be related via (the transitive, symmetric closure
% of) some binary relation.
related(A,B,T) :- hold(s2(_,A,B),T).
related(B,A,T) :- related(A,B,T), A != B.
related(A,C,T) :- related(A,B,T), related(B,C,T), A != B, B != C, A != C.
:- object(O1), object(O2), O1 < O2, time(T), not related(object(O1),object(O2),T).

% ---- conceptual unity ----
% Each unary concept must appear in an xor constraint
% Each binary concept must appear in an xor or exist constraint.
:- concept(C,1), not xor(concept(C,1),_).
:- concept(C,2), not xor(concept(C,2),_), not exist(concept(C,2)).
