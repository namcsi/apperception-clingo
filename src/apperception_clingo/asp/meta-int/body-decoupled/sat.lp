%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---------------- Body-decoupled grounding via solving. ---------------- %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We try to do body-decoupled grounding via solving to avoid the
% exponential blowup of the meta-interpreter in the original paper, as
% there all substitutions of all possible rules had to be computed,
% which is O(|O|^|V|), an exponential function of |V|.
%
% Here, we just make use of the subs(V,O) predicate, which just
% O(|O|*|V|), so we can avoid the exponential blowup in grounding by
% incurring a higher solving cost.

atom_subs(s(C,V),s(C,O),(V,O)) :- unground_atom(s(C,V)), subs(V,O).
atom_subs(s2(C,V1,V2),s2(C,O1,O2),((V1,O1);(V2,O2)))
  :- unground_atom(s2(C,V1,V2)), V1 != V2, subs(V1,O1), subs(V2,O2).
atom_subs(s2(C,V,V),s2(C,O,O),(V,O)) :- unground_atom(s2(C,V,V)), subs(V,O).

rule_head_ground(R,G) :- rule_head(R,U), atom_subs(U,G,_).

rule_delta(static(R),T,T) :- static(R), time(T).
rule_delta(causal(R),T,T-1) :- causal(R), time(T), not init_time(T).

%
% ---- Guess candidate solution from ground head atoms ----
%
{ hold(G,T) } :- rule_head_ground(_,G), time(T).
{ hold(G,T) } :- init(G), time(T).
%% { hold(G,T) } :- time(T), ground_atom(G).
hold(G,T) :- senses(G,T), time(T).

%
% -------- Ensure satisfiability --------
%
% For each rule and each variable occurring in rule, we disjunct over
% all substitutions of the variable that we use for checking
% satisfiability.
sat_subs(R,(V,O)): subs(V,O) :-  rule_var(R,V).

% We derive sat(R,T) if there is some ground instantiation under which
% the rule is satisfied.
%
% This is the case in either of the following two cases.
% 1. There is a substitution via sat_subs for a body atom
% under which the ground atom does not hold.
% 2. There is a substitution via sat_subs for a head atom
% under which the head atom holds.
% 1. case
sat(R,T)
  :- R = static(_), rule_body(R,U), atom_subs(U,G,_),
		 time(T), not hold(G,T),
		 sat_subs(R,(V,O)): atom_subs(U,G,(V,O)).
sat(R,T)
  :- R = causal(_), rule_body(R,U), atom_subs(U,G,_),
		 time(T), time(T-1), not hold(G,T-1),
		 sat_subs(R,(V,O)): atom_subs(U,G,(V,O)).

%% I have no idea why this doesn't work.
%% sat(R,T)
%%   :- rule_delta(R,T,TB), rule_body(R,UB), atom_subs(UB,GB,_),
%% 		 sat_subs(R,(V,O)): atom_subs(UB,GB,(V,O)),
%% 		 not hold(GB,TB).
% 2. case
sat(R,T)
  :- rule_head(R,U), atom_subs(U,G,_), hold(G,T),
		 sat_subs(R,(V,O)): atom_subs(U,G,(V,O)).

% We have sat if for each rule and time point there is a satisfied
% ground instantiation.
all_sat
  :- sat(static(R),T): static(R), time(T);
		 sat(causal(R),T): causal(R), time(T), not init_time(T).
% saturation
sat_subs(R,(V,O)) :- all_sat, rule_var(R,V), subs(V,O).
% require sat to hold there
:- not all_sat.
% Due to the above two rules, if there is an answer set T, it must
% necessarily saturate as we have not not sat. On the other hand,
% suppose there were a ground instation of a rule r that is not
% satisfied under some substitution s. Then we could construct a
% smaller satisfying interpretation H < T by picking the corresponding
% sat_subs atoms to hold for that rule, which would mean we don't
% derive sat and avoid saturation (not a problem since sat is only
% asserted "There").
