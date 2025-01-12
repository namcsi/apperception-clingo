%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -------------------- Generate --------------------  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#const gen_types = 0.
#const gen_objs = 0.
#const gen_unary_preds = 0.
#const gen_binary_preds = 0.
#const gen_vars = 2.
#const causal_max = 1.
#const static_max = 1.
#const rule_body_size_max = 1.

obj_domain(1..gen_objs).
unary_pred_domain(1..gen_unary_preds).
binary_pred_domain(1..gen_binary_preds).
causal_domain(1..causal_max).
static_domain(1..static_max).

gen(type(1..gen_types)).
{gen(obj(O))} :- obj_domain(O).
{gen(pred(P,1))} :- unary_pred_domain(P).
{gen(pred(P,2))} :- binary_pred_domain(P).
gen(var(1..gen_vars)).

type(T) :- gen(type(T)).
pred(P,A) :- gen(pred(P,A)).
obj(O) :- gen(obj(O)).
var(V) :- gen(var(V)).

% choose to use rules
{ causal(R) } :- causal_domain(R).
{ static(R) } :- static_domain(R).

% choose type signatures for entities
1 { isa(type(T),obj(O)): type(T) } 1 :- obj(O).
1 { isa(type(T),pred(C,1)): type(T) } 1 :- pred(C,1).
1 { isa((type(T1),type(T2)),pred(C,2)): type(T1), type(T2) } 1 :- pred(C,2).
1 { isa(type(T),var(V)): type(T) } 1 :- var(V).

% choose xor and exist constraints
{ xor(C1,C2): C2 = pred(_,A), isa(T,C2), C1 < C2 } :- C1 = pred(_,A), isa(T,C1).
{ exist(pred(C,2)) } :- pred(C,2).

% choose atoms that hold in the initial time step.
{ init(G) } :- ground_atom(G).
init(G) :- senses(G,T), init_time(T).

% choose rules
1 { rule_head(R,U): unground_atom(U) } 1 :- rule(R).
1 { rule_body(R,U): unground_atom(U) } rule_body_size_max :- rule(R).
