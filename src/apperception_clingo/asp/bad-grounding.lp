%% Old attempt at calculating substitutions during grounding

%% last(R,P) :- rule_pos_var(R,P,V), not rule_pos_var(R,P+1,_).
%% map(R,-1,(,)) :- rule_pos_var(R,0,V), subs(V,O).
%% map(R,P,((V,O),M)) :- rule_pos_var(R,P,V), subs(V,O), map(R,P-1,M).

%% subst_(((V,O),M),((V,O),M),V,O) :- last(R,P), map(R,P,((V,O),M)).
%% subst_(S,M,V,O) :- subst_(S,((V,O),M),_,_).
%% subst(S,V,O) :- subst_(S,_,V,O).
