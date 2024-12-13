%
% Allow only tight logic programs. In this case no ordering is required.
%
pos_dep_path(CB,C)
  :- R = static(_), rule_head(R,U), rule_body(R,UB),
		 U=(s(C,_);s2(C,_,_)), UB=(s(CB,_);s2(CB,_,_)).
pos_dep_path(C,E) :- pos_dep_path(C,D), pos_dep_path(D,E).
:- pos_dep_path(C,C).
