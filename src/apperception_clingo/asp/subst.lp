

sub_var(V,O) :- is_var(V), isa(T,V), object(O), isa(T,O).

last(R,P) :- rule_pos_var(R,P,V), not rule_pos_var(R,P+1,_).
map(R,-1,(,)) :- rule_pos_var(R,0,V), sub_var(V,O).
map(R,P,((V,O),M)) :- rule_pos_var(R,P,V), sub_var(V,O), map(R,P-1,M).

subst_(((V,O),M),((V,O),M),V,O) :- last(R,P), map(R,P,((V,O),M)).
subst_(S,M,V,O) :- subst_(S,((V,O),M),_,_).
subst(S,V,O) :- subst_(S,_,V,O).

%% is_rule(1).
%% rule_pos_var(1,0,2). rule_pos_var(1,1,3).
%% is_var(2;3).
%% isa(t1,2).
%% isa(t2,3).
%% object(a;b;c;d).
%% isa(t1,(a;b)).
%% isa(t2,(c;d)).

%% #show subst/3.
%% #show rule_pos_var/3.
%% #show sub_var/2.
