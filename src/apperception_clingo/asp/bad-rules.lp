% Version that eliminates all symmetries by having a total order over all rules, but entails more grounding
% I think this is way too expensive to ground unfortunately
%% rule_body_dom((U,()),1) :- rule_body_size_max > 0, unground_atom(U).
%% rule_body_dom((U,(Cons,Cdr)),Size+1)
%%   :- rule_body_dom((Cons,Cdr),Size), unground_atom(U), U < Cons, Size < rule_body_size_max.
%% rule_dom((Head,Body))
%%   :- rule_body_dom(Body,_), unground_atom(Head), rule_var(Body,Var): atom_var(Head,V).
%% rule_body((Cons,Cdr),Cons) :- rule_body_dom((Cons,Cdr),_).
%% rule_body((Cons,Cdr),U) :- rule_body_dom((Cons,Cdr),_), rule_body(Cdr,U).
